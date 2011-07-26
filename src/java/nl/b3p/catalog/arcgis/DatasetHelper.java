/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package nl.b3p.catalog.arcgis;

import com.esri.arcgis.datasourcesraster.RasterBand;
import com.esri.arcgis.datasourcesraster.RasterDataset;
import com.esri.arcgis.geodatabase.FeatureClass;
import com.esri.arcgis.geodatabase.FeatureDataset;
import com.esri.arcgis.geodatabase.GeometricNetwork;
import com.esri.arcgis.geodatabase.IDataset;
import com.esri.arcgis.geodatabase.IEnumDataset;
import com.esri.arcgis.geodatabase.NetworkDataset;
import com.esri.arcgis.geodatabase.RasterCatalog;
import com.esri.arcgis.geodatabase.RelationshipClass;
import com.esri.arcgis.geodatabase.RepresentationClass;
import com.esri.arcgis.geodatabase.Table;
import com.esri.arcgis.geodatabase.Tin;
import com.esri.arcgis.geodatabase.Topology;
import com.esri.arcgis.geodatabase.esriDatasetType;
import com.esri.arcgis.geodatabaseextensions.CadastralFabric;
import com.esri.arcgis.geodatabaseextensions.Terrain;
import com.esri.arcgis.schematic.SchematicDataset;
import java.io.IOException;
import nl.b3p.catalog.B3PCatalogException;
import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;

/**
 *
 * @author Erik van de Pol
 */
public class DatasetHelper {
    private final static Log log = LogFactory.getLog(DatasetHelper.class);
    
    public static IDataset getDataSubset(IDataset dataset, String name, int datasetType) throws IOException {
        IEnumDataset enumDataset = dataset.getSubsets();
        IDataset ds;
        while ((ds = enumDataset.next()) != null) {
            if ((datasetType < 0 || datasetType == ds.getType()) && ds.getName().equals(name)) {
                return ds;
            }
        }
        return null;
    }

    // wat een rampen-API
    public static IDataset getIDataset(IDataset ds) throws IOException, B3PCatalogException {
        switch(ds.getType()) {
            // most used 2:

            case esriDatasetType.esriDTFeatureDataset:
                return (IDataset)new FeatureDataset(ds);
            case esriDatasetType.esriDTFeatureClass:
                return (IDataset)new FeatureClass(ds);

            // others (unsupported types commented out: could not find corresponding class):

            //case esriDatasetType.esriDTCadDrawing:
            case esriDatasetType.esriDTCadastralFabric:
                return (IDataset)new CadastralFabric(ds);
            //case esriDatasetType.esriDTContainer:
            //case esriDatasetType.esriDTGeo:
            case esriDatasetType.esriDTGeometricNetwork:
                return (IDataset)new GeometricNetwork(ds);
            //case esriDatasetType.esriDTLayer:
            //case esriDatasetType.esriDTLocator:
            //case esriDatasetType.esriDTMap:
            //case esriDatasetType.esriDTMosaicDataset:
            case esriDatasetType.esriDTNetworkDataset:
                return (IDataset)new NetworkDataset(ds);
            //case esriDatasetType.esriDTPlanarGraph:
            case esriDatasetType.esriDTRasterBand:
                return (IDataset)new RasterBand(ds);
            case esriDatasetType.esriDTRasterCatalog:
                return (IDataset)new RasterCatalog(ds);
            case esriDatasetType.esriDTRasterDataset:
                return (IDataset)new RasterDataset(ds);
            case esriDatasetType.esriDTRelationshipClass:
                return (IDataset)new RelationshipClass(ds);
            case esriDatasetType.esriDTRepresentationClass:
                return (IDataset)new RepresentationClass(ds);
            case esriDatasetType.esriDTSchematicDataset:
                return (IDataset)new SchematicDataset(ds);
            //case esriDatasetType.esriDTStyle:
            case esriDatasetType.esriDTTable:
                return (IDataset)new Table(ds);
            case esriDatasetType.esriDTTerrain:
                return (IDataset)new Terrain(ds);
            //case esriDatasetType.esriDTText:
            case esriDatasetType.esriDTTin:
                return (IDataset)new Tin(ds);
            //case esriDatasetType.esriDTTool:
            //case esriDatasetType.esriDTToolbox:
            case esriDatasetType.esriDTTopology:
                return (IDataset)new Topology(ds);
            default:
                throw new B3PCatalogException("DatasetType " + ds.getType() + " not supported.");
        }
    }


}
