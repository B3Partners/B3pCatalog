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
import com.esri.arcgis.geodatabase.esriFieldType;
import com.esri.arcgis.geometry.IEnvelopeGEN;
import com.esri.arcgis.geometry.IPoint;
import com.esri.arcgis.geometry.ISpatialReference;
import com.esri.arcgis.geometry.ISpatialReferenceInfo;
import com.esri.arcgis.geometry.Point;
import com.esri.arcgis.geometry.SpatialReferenceEnvironment;
import com.esri.arcgis.geometry.esriGeometryType;
import com.esri.arcgis.geometry.esriSRGeoCSType;
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
    public void synchronizeFGDB(Document xmlDoc, File fgdbFile) throws IOException, B3PCatalogException, JDOMException {
        IDataset dataset = FGDBHelper.getTargetDataset(fgdbFile, esriDatasetType.esriDTFeatureClass);
        Workspace workspace = new Workspace(dataset.getWorkspace());
        XPathHelper.applyXPathValuePair(xmlDoc, XPathHelper.DISTR_FORMAT_NAME, "ESRI file geodatabase (FGDB)");
        // Als distribute formaat naam is ingevuld, moet ook de versie ingevuld staan, anders is de xml niet correct volgens het xsd.
        // hmmm, dit geeft 2.2 bij sample FGDB's van ArcGIS 10 ?!?
        XPathHelper.applyXPathValuePair(xmlDoc, XPathHelper.DISTR_FORMAT_VERSION, workspace.getMajorVersion() + "." + workspace.getMinorVersion());

        // We don't use the FGDBHelperProxy below. A test whether a ArcGIS connection existsmust must be done beforehand.
        sync(xmlDoc, dataset);
    }

    public void synchronizeSDE(Document xmlDoc, IDataset dataset) throws IOException, B3PCatalogException, JDOMException {

        Workspace workspace = new Workspace(dataset.getWorkspace());
        XPathHelper.applyXPathValuePair(xmlDoc, XPathHelper.DISTR_FORMAT_NAME, "ESRI ArcSDE");
        // Als distribute formaat naam is ingevuld, moet ook de versie ingevuld staan, anders is de xml niet correct volgens het xsd.
        // hmmm, dit geeft 2.2 bij sample FGDB's van ArcGIS 10 ?!?
        XPathHelper.applyXPathValuePair(xmlDoc, XPathHelper.DISTR_FORMAT_VERSION, workspace.getMajorVersion() + "." + workspace.getMinorVersion());

        sync(xmlDoc, dataset);
    }
    
    public void synchronizeShapeFile(Document xmlDoc, File shapeFile) throws IOException, B3PCatalogException, JDOMException {
        ShapefileWorkspaceFactory shapefileWorkspaceFactory = new ShapefileWorkspaceFactory();
        IWorkspace iWorkspace = shapefileWorkspaceFactory.openFromFile(shapeFile.getParent(), 0);
        Workspace workspace = new Workspace(iWorkspace);
        
        String shapefileFullname = shapeFile.getName();
        if (!shapefileFullname.endsWith(Extensions.SHAPE) || shapefileFullname.length() == Extensions.SHAPE.length())
            throw new B3PCatalogException("File is not a shape file");
        
        XPathHelper.applyXPathValuePair(xmlDoc, XPathHelper.DISTR_FORMAT_NAME, "ESRI shapefile");
        // Bug in ArcObjects. Hij zegt bij de volgende regel:
        // AutomationException: No such interface supported 
        // Dit gaat dan om de IGeodatabaseRelease interface die toch echt supported hoort te zijn.
        //XPathHelper.applyXPathValuePair(xmlDoc, XPathHelper.DISTR_FORMAT_VERSION, workspace.getMajorVersion() + "." + workspace.getMinorVersion());
        // Als distribute formaat naam is ingevuld, moet ook de versie ingevuld staan, anders is de xml niet correct volgens het xsd.
        XPathHelper.applyXPathValuePair(xmlDoc, XPathHelper.DISTR_FORMAT_VERSION, "Onbekend");
        
        String shapeFilename = shapefileFullname.substring(0, shapefileFullname.lastIndexOf('.'));
        // shape file names are unique per directory; therefore type is irrelevant (== -1)
        sync(xmlDoc, DatasetHelper.getDataSubset(workspace, shapeFilename, -1));
    }
    
    protected void sync(Document xmlDoc, IDataset dataset) throws IOException, B3PCatalogException, JDOMException {
        dataset = DatasetHelper.getIDataset(dataset); // tja, ArcGIS; dataset is in den beginne slechts een IDatasetProxy. Zie verder getIDataset
        
        IObjectClass objectClass = (IObjectClass)dataset;
        
        XPathHelper.applyXPathValuePair(xmlDoc, XPathHelper.TITLE, dataset.getBrowseName());
        XPathHelper.applyXPathValuePair(xmlDoc, XPathHelper.ALT_TITLE, objectClass.getAliasName());
        XPathHelper.applyXPathValuePair(xmlDoc, XPathHelper.SPATIAL_REPR, getSpatialRepresentation(dataset));
        
        IGeoDataset geoDataset = (IGeoDataset)dataset;
        
        IEnvelopeGEN envelope = (IEnvelopeGEN)geoDataset.getExtent();

        IPoint ll = envelope.getLowerLeft();
        IPoint ur = envelope.getUpperRight();
        SpatialReferenceEnvironment refEnv = new SpatialReferenceEnvironment();
        ISpatialReference wgs84 = refEnv.createGeographicCoordinateSystem(esriSRGeoCSType.esriSRGeoCS_WGS1984);
        ll.project(wgs84);
        ur.project(wgs84);

        XPathHelper.applyXPathValuePair(xmlDoc, XPathHelper.BBOX_WEST, "" + ll.getX());
        XPathHelper.applyXPathValuePair(xmlDoc, XPathHelper.BBOX_EAST, "" + ur.getX());
        XPathHelper.applyXPathValuePair(xmlDoc, XPathHelper.BBOX_SOUTH, "" + ll.getY());
        XPathHelper.applyXPathValuePair(xmlDoc, XPathHelper.BBOX_NORTH, "" + ur.getY());

        ISpatialReferenceInfo spatialRef = (ISpatialReferenceInfo)geoDataset.getSpatialReference();
        XPathHelper.applyXPathValuePair(xmlDoc, XPathHelper.REF_CODESPACE, "EPSG");
        XPathHelper.applyXPathValuePair(xmlDoc, XPathHelper.REF_CODE, "" + spatialRef.getFactoryCode()); // is 0 voor edam/volendam voorbeeld?!?
        
        syncFeatureCatalog(xmlDoc, dataset);
        
        //log.debug(new XMLOutputter().outputString(xmlDoc));
    }
    
    protected void syncFeatureCatalog(Document xmlDoc, IDataset dataset) throws JDOMException, IOException {
        Element gfc_FC_FeatureCatalogue = XPathHelper.selectSingleElement(xmlDoc, XPathHelper.FEATURE_CATALOG);
        gfc_FC_FeatureCatalogue.removeChildren(Names.GFC_FEATURE_TYPE, Namespaces.GFC);
        
        XPathHelper.applyXPathValuePair(xmlDoc, XPathHelper.FC_TITLE, dataset.getBrowseName());
        
        for (IFeatureClass iFeatureClass : new IFeatureClassList(dataset)) {
            FeatureClass featureClass = new FeatureClass(iFeatureClass);
            Element gfc_featureType = new Element(Names.GFC_FEATURE_TYPE, Namespaces.GFC);
            Element gfc_FC_FeatureType = new Element(Names.GFC_FC_FEATURE_TYPE, Namespaces.GFC);
            
            // is niet correct: dit moet de user invullen
            /*Element gfc_typeName = new Element(Names.GFC_TYPE_NAME, Namespaces.GFC);
            Element gco_LocalName = new Element(Names.GCO_LOCAL_NAME, Namespaces.GCO);
            gco_LocalName.setText(getFeatureClassShapeType(featureClass));
            gfc_typeName.addContent(gco_LocalName);
            
            gfc_FC_FeatureType.addContent(gfc_typeName);*/
            
            IFields fields = featureClass.getFields();
            for (int i = 0; i < fields.getFieldCount(); i++) {
                IField field = fields.getField(i);
                Element gfc_carrierOfCharacteristics = new Element(Names.GFC_CARRIER_OF_CHARACTERISTICS, Namespaces.GFC);
                Element gfc_FC_FeatureAttribute = new Element(Names.GFC_FC_FEATURE_ATTRIBUTE, Namespaces.GFC);

                Element gfc_memberName = new Element(Names.GFC_MEMBER_NAME, Namespaces.GFC);
                Element field_gco_LocalName = new Element(Names.GCO_LOCAL_NAME, Namespaces.GCO);
                field_gco_LocalName.setText(field.getAliasName());
                gfc_memberName.addContent(field_gco_LocalName);
                
                gfc_FC_FeatureAttribute.addContent(gfc_memberName);
                
                Element gfc_valueType = new Element(Names.GFC_VALUE_TYPE, Namespaces.GFC);
                Element gco_TypeName = new Element(Names.GCO_TYPE_NAME, Namespaces.GCO);
                Element gco_aName = new Element(Names.GCO_A_NAME, Namespaces.GCO);
                Element gco_CharacterString = new Element(Names.GCO_CHARACTER_STRING, Namespaces.GCO);
                gco_CharacterString.setText(getValueType(field.getType(), featureClass));
                gco_aName.addContent(gco_CharacterString);
                gco_TypeName.addContent(gco_aName);
                gfc_valueType.addContent(gco_TypeName);
                
                gfc_FC_FeatureAttribute.addContent(gfc_valueType);
                
                gfc_carrierOfCharacteristics.addContent(gfc_FC_FeatureAttribute);
                gfc_FC_FeatureType.addContent(gfc_carrierOfCharacteristics);
            }
            
            gfc_featureType.addContent(gfc_FC_FeatureType);
            gfc_FC_FeatureCatalogue.addContent(gfc_featureType);
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

    private String getValueType(int varType, IFeatureClass featureClass) throws IOException {
        switch(varType) {
            case esriFieldType.esriFieldTypeBlob:
                return "Blob";
            case esriFieldType.esriFieldTypeDate:
                return "Date";
            case esriFieldType.esriFieldTypeDouble:
                return "Double";
            case esriFieldType.esriFieldTypeGUID:
                return "GUID";
            case esriFieldType.esriFieldTypeGeometry:
                return getFeatureClassShapeType(featureClass);
            case esriFieldType.esriFieldTypeGlobalID:
                return "GlobalID";
            case esriFieldType.esriFieldTypeInteger:
                return "Integer 32bit";
            case esriFieldType.esriFieldTypeOID:
                return "Object ID";
            case esriFieldType.esriFieldTypeRaster:
                return "Raster";
            case esriFieldType.esriFieldTypeSingle:
                return "Float";
            case esriFieldType.esriFieldTypeSmallInteger:
                return "Integer 16bit";
            case esriFieldType.esriFieldTypeString:
                return "String";
            case esriFieldType.esriFieldTypeXML:
                return "XML";
            default:
                return "";
        }
    }
    
}
