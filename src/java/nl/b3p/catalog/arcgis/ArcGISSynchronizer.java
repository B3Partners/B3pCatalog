/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package nl.b3p.catalog.arcgis;

import com.esri.arcgis.datasourcesfile.ShapefileWorkspaceFactory;
import com.esri.arcgis.geodatabase.FeatureClass;
import com.esri.arcgis.geodatabase.IDataset;
import com.esri.arcgis.geodatabase.IFeatureClass;
import com.esri.arcgis.geodatabase.IField;
import com.esri.arcgis.geodatabase.IFields;
import com.esri.arcgis.geodatabase.IGeoDataset;
import com.esri.arcgis.geodatabase.IObjectClass;
import com.esri.arcgis.geodatabase.IWorkspace;
import com.esri.arcgis.geodatabase.Workspace;
import com.esri.arcgis.geodatabase.esriDatasetType;
import com.esri.arcgis.geometry.IEnvelopeGEN;
import com.esri.arcgis.geometry.ISpatialReferenceInfo;
import com.esri.arcgis.geometry.esriGeometryType;
import java.io.File;
import java.io.IOException;
import nl.b3p.catalog.B3PCatalogException;
import nl.b3p.catalog.filetree.Extensions;
import nl.b3p.catalog.xml.Names;
import nl.b3p.catalog.xml.Namespaces;
import nl.b3p.catalog.xml.XPathHelper;
import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.jdom.Document;
import org.jdom.Element;
import org.jdom.JDOMException;
import org.jdom.output.XMLOutputter;

/**
 *
 * @author Erik van de Pol
 */
public class ArcGISSynchronizer {
    private final static Log log = LogFactory.getLog(ArcGISSynchronizer.class);
    
    public ArcGISSynchronizer() {
    }
    
    /**
     * 
     * @param arcGISFilename Filename to the FGDB with datasets as subdirs.
     * @param esriType
     * @return
     * @throws IOException 
     */
    public void synchronizeFGDB(Document xmlDoc, File fgdbFile, int esriType) throws IOException, B3PCatalogException, JDOMException {
        // We don't use the FGDBHelperProxy below. A test whether a ArcGIS connection existsmust must be done beforehand.
        sync(xmlDoc, FGDBHelper.getTargetDataset(fgdbFile, esriType));
    }
    
    public void synchronizeShapeFile(Document xmlDoc, File shapeFile) throws IOException, B3PCatalogException, JDOMException {
        ShapefileWorkspaceFactory shapefileWorkspaceFactory = new ShapefileWorkspaceFactory();
        IWorkspace iWorkspace = shapefileWorkspaceFactory.openFromFile(shapeFile.getParent(), 0);
        IDataset dataset = new Workspace(iWorkspace);
        
        String shapefileFullname = shapeFile.getName();
        if (!shapefileFullname.endsWith(Extensions.SHAPE) || shapefileFullname.length() == Extensions.SHAPE.length())
            throw new B3PCatalogException("File is not a shape file");
        
        // shape file names are unique per directory; therefore type is irrelevant (== -1)
        String shapeFilename = shapefileFullname.substring(0, shapefileFullname.lastIndexOf('.'));
        sync(xmlDoc, DatasetHelper.getDataSubset(dataset, shapeFilename, -1));
    }
    
    protected void sync(Document xmlDoc, IDataset dataset) throws IOException, B3PCatalogException, JDOMException {
        dataset = DatasetHelper.getIDataset(dataset); // tja, ArcGIS; dataset is in den beginne slechts een IDatasetProxy. Zie verder getIDataset
        
        IObjectClass objectClass = (IObjectClass)dataset;
        
        XPathHelper.applyXPathValuePair(xmlDoc, XPathHelper.TITLE, dataset.getBrowseName());
        XPathHelper.applyXPathValuePair(xmlDoc, XPathHelper.ALT_TITLE, objectClass.getAliasName());
        XPathHelper.applyXPathValuePair(xmlDoc, XPathHelper.SPATIAL_REPR, getSpatialRepresentation(dataset));
        
        IGeoDataset geoDataset = (IGeoDataset)dataset;
        
        IEnvelopeGEN envelope = (IEnvelopeGEN)geoDataset.getExtent();
        XPathHelper.applyXPathValuePair(xmlDoc, XPathHelper.BBOX_WEST, "" + envelope.getXMin());
        XPathHelper.applyXPathValuePair(xmlDoc, XPathHelper.BBOX_EAST, "" + envelope.getXMax());
        XPathHelper.applyXPathValuePair(xmlDoc, XPathHelper.BBOX_SOUTH, "" + envelope.getYMin());
        XPathHelper.applyXPathValuePair(xmlDoc, XPathHelper.BBOX_NORTH, "" + envelope.getYMax());
        
        ISpatialReferenceInfo spatialRef = (ISpatialReferenceInfo)geoDataset.getSpatialReference();
        XPathHelper.applyXPathValuePair(xmlDoc, XPathHelper.REF_CODESPACE, "EPSG");
        XPathHelper.applyXPathValuePair(xmlDoc, XPathHelper.REF_CODE, "" + spatialRef.getFactoryCode()); // is 0 voor edam/volendam voorbeeld?!?
        
        syncFeatureCatalog(xmlDoc, dataset);
        
        //log.debug(new XMLOutputter().outputString(xmlDoc));
    }
    
    protected void syncFeatureCatalog(Document xmlDoc, IDataset dataset) throws JDOMException, IOException {
        Element featureCatalog = XPathHelper.selectSingleElement(xmlDoc, XPathHelper.FEATURE_CATALOG);
        featureCatalog.removeChildren(Names.FEATURE_TYPE, Namespaces.GFC);
        for (IFeatureClass iFeatureClass : new IFeatureClassList(dataset)) {
            FeatureClass featureClass = new FeatureClass(iFeatureClass);
            Element featureType = new Element(Names.FEATURE_TYPE, Namespaces.GFC);
            Element fcFeatureType = new Element(Names.FC_FEATURE_TYPE, Namespaces.GFC);
            
            Element typeName = new Element(Names.TYPE_NAME, Namespaces.GFC);
            Element localName = new Element(Names.LOCAL_NAME, Namespaces.GCO);
            localName.setText(getFeatureClassShapeType(featureClass));
            typeName.addContent(localName);
            
            fcFeatureType.addContent(typeName);
            
            IFields fields = featureClass.getFields();
            for (int i = 0; i < fields.getFieldCount(); i++) {
                IField field = fields.getField(i);
                Element carrierOfCharacteristics = new Element(Names.CARRIER_OF_CHARACTERISTICS, Namespaces.GFC);
                Element fcFeatureAttribute = new Element(Names.FC_FEATURE_ATTRIBUTE, Namespaces.GFC);

                Element memberName = new Element(Names.MEMBER_NAME, Namespaces.GFC);
                Element fieldLocalName = new Element(Names.LOCAL_NAME, Namespaces.GCO);
                fieldLocalName.setText(field.getAliasName());
                memberName.addContent(fieldLocalName);
                
                fcFeatureAttribute.addContent(memberName);
                
                // TODO: hier is nog veel meer uit te halen! 
                // Als de nieuwe specs van de NL metadata standaard 1.3 het toelaten, 
                // kan nog veel meer gesyncd worden.
                
                carrierOfCharacteristics.addContent(fcFeatureAttribute);
                fcFeatureType.addContent(carrierOfCharacteristics);
            }
            
            featureType.addContent(fcFeatureType);
            featureCatalog.addContent(featureType);
        }
    }
    
    private String getSpatialRepresentation(IDataset dataset) throws IOException {
        switch(dataset.getType()) {
            // most used 2:

            case esriDatasetType.esriDTFeatureDataset: // intentional fallthrough
            case esriDatasetType.esriDTFeatureClass:
                return "vector";

            // others (unsupported types commented out: could not find corresponding class):

            //case esriDatasetType.esriDTCadDrawing:
            case esriDatasetType.esriDTCadastralFabric:
                return "";
            case esriDatasetType.esriDTContainer:
            case esriDatasetType.esriDTGeo:
            case esriDatasetType.esriDTGeometricNetwork:
                return "";
            case esriDatasetType.esriDTLayer:
            //case esriDatasetType.esriDTLocator:
            //case esriDatasetType.esriDTMap:
            //case esriDatasetType.esriDTMosaicDataset:
            case esriDatasetType.esriDTNetworkDataset:
                return "";
            //case esriDatasetType.esriDTPlanarGraph:
            case esriDatasetType.esriDTRasterBand: // intentional fallthrough
            case esriDatasetType.esriDTRasterCatalog: // intentional fallthrough
            case esriDatasetType.esriDTRasterDataset:
                return "grid"; // is dit correct??
            case esriDatasetType.esriDTRelationshipClass:
                return "";
            case esriDatasetType.esriDTRepresentationClass:
                return "";
            case esriDatasetType.esriDTSchematicDataset:
                return "";
            //case esriDatasetType.esriDTStyle:
            case esriDatasetType.esriDTTable:
                return "textTable";
            case esriDatasetType.esriDTTerrain:
                return "";
            //case esriDatasetType.esriDTText:
            case esriDatasetType.esriDTTin:
                return "tin";
            //case esriDatasetType.esriDTTool:
            //case esriDatasetType.esriDTToolbox:
            case esriDatasetType.esriDTTopology:
                return "";
            default:
                return ""; // dunno
        }
    }
    
    private String getFeatureClassShapeType(IFeatureClass featureClass) throws IOException {
        switch(featureClass.getShapeType()) {
            case esriGeometryType.esriGeometryAny:
                return "Any";
            case esriGeometryType.esriGeometryBag:
                return "Bag";
            case esriGeometryType.esriGeometryBezier3Curve:
                return "Bezier 3Curve";
            case esriGeometryType.esriGeometryCircularArc:
                return "Circular Arc";
            case esriGeometryType.esriGeometryEllipticArc:
                return "Elliptic Arc";
            case esriGeometryType.esriGeometryEnvelope:
                return "Envelope";
            case esriGeometryType.esriGeometryLine:
                return "Line";
            case esriGeometryType.esriGeometryMultiPatch:
                return "MultiPatch";
            case esriGeometryType.esriGeometryMultipoint:
                return "Multipoint";
            case esriGeometryType.esriGeometryNull:
                return "Null";
            case esriGeometryType.esriGeometryPath:
                return "Path";
            case esriGeometryType.esriGeometryPoint:
                return "Point";
            case esriGeometryType.esriGeometryPolygon:
                return "Polygon";
            case esriGeometryType.esriGeometryPolyline:
                return "Polyline";
            case esriGeometryType.esriGeometryRay:
                return "Ray";
            case esriGeometryType.esriGeometryRing:
                return "Ring";
            case esriGeometryType.esriGeometrySphere:
                return "Sphere";
            case esriGeometryType.esriGeometryTriangleFan:
                return "Triangle Fan";
            case esriGeometryType.esriGeometryTriangleStrip:
                return "Triangle Strip";
            case esriGeometryType.esriGeometryTriangles:
                return "Triangles";
            default:
                return "Unknown"; // dunno
        }
    }
    
}
