/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package nl.b3p.catalog.arcgis;

import com.esri.arcgis.datasourcesfile.ShapefileWorkspaceFactory;
import com.esri.arcgis.geodatabase.IDataset;
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
import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;

/**
 *
 * @author Erik van de Pol
 */
public class ArcGISSynchronizer {
    private final static Log log = LogFactory.getLog(ArcGISSynchronizer.class);
    
    private final static String SHAPE_FILE_EXTENSION = ".shp";

    private final static String XPATH_TITLE = "/*/gmd:MD_Metadata/gmd:identificationInfo/gmd:MD_DataIdentification/gmd:citation/gmd:CI_Citation/gmd:title/gco:CharacterString";
    private final static String XPATH_ALT_TITLE = "/*/gmd:MD_Metadata/gmd:identificationInfo/gmd:MD_DataIdentification/gmd:citation/gmd:CI_Citation/gmd:alternateTitle/gco:CharacterString";
    private final static String XPATH_BBOX_WEST = "/*/gmd:MD_Metadata/gmd:identificationInfo/gmd:MD_DataIdentification/gmd:extent/gmd:EX_Extent/gmd:geographicElement/gmd:EX_GeographicBoundingBox/gmd:westBoundLongitude/gco:Decimal";
    private final static String XPATH_BBOX_EAST = "/*//gmd:MD_Metadata/gmd:identificationInfo/gmd:MD_DataIdentification/gmd:extent/gmd:EX_Extent/gmd:geographicElement/gmd:EX_GeographicBoundingBox/gmd:eastBoundLongitude/gco:Decimal";
    private final static String XPATH_BBOX_NORTH = "/*/gmd:MD_Metadata/gmd:identificationInfo/gmd:MD_DataIdentification/gmd:extent/gmd:EX_Extent/gmd:geographicElement/gmd:EX_GeographicBoundingBox/gmd:northBoundLatitude/gco:Decimal";
    private final static String XPATH_BBOX_SOUTH = "/*/gmd:MD_Metadata/gmd:identificationInfo/gmd:MD_DataIdentification/gmd:extent/gmd:EX_Extent/gmd:geographicElement/gmd:EX_GeographicBoundingBox/gmd:southBoundLatitude/gco:Decimal";
    private final static String XPATH_REF_CODESPACE = "/*/gmd:MD_Metadata/gmd:referenceSystemInfo/gmd:MD_ReferenceSystem/gmd:referenceSystemIdentifier/gmd:RS_Identifier/gmd:codeSpace/gco:CharacterString";
    private final static String XPATH_REF_CODE = "/*/gmd:MD_Metadata/gmd:referenceSystemInfo/gmd:MD_ReferenceSystem/gmd:referenceSystemIdentifier/gmd:RS_Identifier/gmd:code/gco:CharacterString";
    private final static String XPATH_SPATIAL_REPR = "/*/gmd:MD_Metadata/gmd:identificationInfo/gmd:MD_DataIdentification/gmd:spatialRepresentationType/gmd:MD_SpatialRepresentationTypeCode";
    
    public ArcGISSynchronizer() {
    }
    
    /**
     * 
     * @param arcGISFilename Filename to the FGDB with datasets as subdirs.
     * @param esriType
     * @return
     * @throws IOException 
     */
    public JSONObject synchronizeFGDB(File fgdbFile, int esriType) throws IOException, B3PCatalogException {
        // We don't use the FGDBHelperProxy below. A test whether a ArcGIS connection existsmust must be done beforehand.
        return sync(FGDBHelper.getTargetDataset(fgdbFile, esriType));
    }
    
    public JSONObject synchronizeShapeFile(File shapeFile) throws IOException, B3PCatalogException {
        ShapefileWorkspaceFactory shapefileWorkspaceFactory = new ShapefileWorkspaceFactory();
        IWorkspace iWorkspace = shapefileWorkspaceFactory.openFromFile(shapeFile.getParent(), 0);
        IDataset dataset = new Workspace(iWorkspace);
        
        String shapefileFullname = shapeFile.getName();
        if (!shapefileFullname.endsWith(SHAPE_FILE_EXTENSION) || shapefileFullname.length() == SHAPE_FILE_EXTENSION.length())
            throw new B3PCatalogException("File is not a shape file");
        
        // shape file names are unique per directory; therefore type is irrelevant (== -1)
        String shapeFilename = shapefileFullname.substring(0, shapefileFullname.lastIndexOf('.'));
        return sync(DatasetHelper.getDataSubset(dataset, shapeFilename, -1));
    }
    
    protected JSONObject sync(IDataset dataset) throws IOException, B3PCatalogException {
        JSONObject syncedXPathValuePairs = new JSONObject();
        dataset = DatasetHelper.getIDataset(dataset); // tja, ArcGIS; dataset is in den beginne slechts een IDatasetProxy. Zie verder getIDataset
        
        IObjectClass objectClass = (IObjectClass)dataset;
        
        syncedXPathValuePairs.put(XPATH_TITLE, dataset.getBrowseName());
        syncedXPathValuePairs.put(XPATH_ALT_TITLE, objectClass.getAliasName());
        syncedXPathValuePairs.put(XPATH_SPATIAL_REPR, getSpatialRepresentation(dataset));
        
        IGeoDataset geoDataset = (IGeoDataset)dataset;
        
        IEnvelopeGEN envelope = (IEnvelopeGEN)geoDataset.getExtent();
        syncedXPathValuePairs.put(XPATH_BBOX_WEST, envelope.getXMin());
        syncedXPathValuePairs.put(XPATH_BBOX_EAST, envelope.getXMax());
        syncedXPathValuePairs.put(XPATH_BBOX_SOUTH, envelope.getYMin());
        syncedXPathValuePairs.put(XPATH_BBOX_NORTH, envelope.getYMax());
        
        ISpatialReferenceInfo spatialRef = (ISpatialReferenceInfo)geoDataset.getSpatialReference();
        syncedXPathValuePairs.put(XPATH_REF_CODESPACE, "EPSG");
        syncedXPathValuePairs.put(XPATH_REF_CODE, spatialRef.getFactoryCode());
        
        return syncedXPathValuePairs;
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
