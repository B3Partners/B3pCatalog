/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package nl.b3p.catalog.arcgis;

import com.esri.arcgis.datasourcesfile.ShapefileWorkspaceFactory;
import com.esri.arcgis.geodatabase.IDataset;
import com.esri.arcgis.geodatabase.IFeatureClass;
import com.esri.arcgis.geodatabase.IGeoDataset;
import com.esri.arcgis.geodatabase.IObjectClass;
import com.esri.arcgis.geodatabase.IWorkspace;
import com.esri.arcgis.geodatabase.Workspace;
import com.esri.arcgis.geodatabase.esriDatasetType;
import com.esri.arcgis.geometry.IEnvelopeGEN;
import com.esri.arcgis.geometry.ISpatialReferenceInfo;
import java.io.File;
import java.io.IOException;
import net.sf.json.JSONObject;
import nl.b3p.catalog.B3PCatalogException;
import nl.b3p.catalog.xml.XPathHelper;
import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.jdom.Document;
import org.jdom.JDOMException;

/**
 *
 * @author Erik van de Pol
 */
public class ArcGISSynchronizer {
    private final static Log log = LogFactory.getLog(ArcGISSynchronizer.class);
    
    private final static String SHAPE_FILE_EXTENSION = ".shp";

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
        if (!shapefileFullname.endsWith(SHAPE_FILE_EXTENSION) || shapefileFullname.length() == SHAPE_FILE_EXTENSION.length())
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
        
        for (IFeatureClass featureClass : new IFeatureClassList(dataset)) {
            log.debug("featureClass visited");
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
            //case esriDatasetType.esriDTContainer:
            //case esriDatasetType.esriDTGeo:
            case esriDatasetType.esriDTGeometricNetwork:
                return "";
            //case esriDatasetType.esriDTLayer:
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
    
}
