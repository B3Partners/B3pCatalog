/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

package nl.b3p.catalog.arcgis;

import com.esri.arcgis.datasourcesGDB.FileGDBWorkspaceFactory;
import com.esri.arcgis.datasourcesraster.RasterBand;
import com.esri.arcgis.datasourcesraster.RasterDataset;
import com.esri.arcgis.geodatabase.FeatureClass;
import com.esri.arcgis.geodatabase.FeatureDataset;
import com.esri.arcgis.geodatabase.GeometricNetwork;
import com.esri.arcgis.geodatabase.IDataset;
import com.esri.arcgis.geodatabase.IEnumDataset;
import com.esri.arcgis.geodatabase.IMetadata;
import com.esri.arcgis.geodatabase.NetworkDataset;
import com.esri.arcgis.geodatabase.RasterCatalog;
import com.esri.arcgis.geodatabase.RelationshipClass;
import com.esri.arcgis.geodatabase.RepresentationClass;
import com.esri.arcgis.geodatabase.Table;
import com.esri.arcgis.geodatabase.Tin;
import com.esri.arcgis.geodatabase.Topology;
import com.esri.arcgis.geodatabase.Workspace;
import com.esri.arcgis.geodatabase.XmlPropertySet;
import com.esri.arcgis.geodatabase.esriDatasetType;
import com.esri.arcgis.geodatabaseextensions.CadastralFabric;
import com.esri.arcgis.geodatabaseextensions.Terrain;
import com.esri.arcgis.schematic.SchematicDataset;
import java.io.File;
import java.io.IOException;
import java.util.ArrayList;
import java.util.LinkedList;
import java.util.List;
import net.sourceforge.stripes.action.ActionBeanContext;
import nl.b3p.catalog.B3PCatalogException;
import nl.b3p.catalog.filetree.Dir;
import nl.b3p.catalog.filetree.Rewrite;
import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;

/**
 *
 * @author Erik
 */
public class FGDBHelper {
    private final static Log log = LogFactory.getLog(FGDBHelper.class);

    public static String getMetadata(File fileGDBPath, int datasetType) throws IOException, B3PCatalogException {
        IMetadata iMetadata = getIMetadata(fileGDBPath, datasetType);
        XmlPropertySet xmlPropertySet = (XmlPropertySet)iMetadata.getMetadata();
        return xmlPropertySet.getXml("/");
    }

    public static void setMetadata(File fileGDBPath, int datasetType, String metadata) throws IOException, B3PCatalogException {
        IMetadata iMetadata = getIMetadata(fileGDBPath, datasetType);
        XmlPropertySet xmlPropertySet = (XmlPropertySet)iMetadata.getMetadata();
        xmlPropertySet.setXml(metadata);
        iMetadata.setMetadata(xmlPropertySet);
    }

    private static IMetadata getIMetadata(File fileGDBPath, int datasetType) throws IOException, B3PCatalogException {
        if (datasetType <= 0) {
            // we at least try to make something of this:
            datasetType = esriDatasetType.esriDTFeatureDataset;
        }
        IDataset ds = getTargetDataset(fileGDBPath, datasetType);
        return getIMetadata(ds, datasetType);
    }
    
    private static IMetadata getIMetadata(IDataset ds, int datasetType) throws IOException, B3PCatalogException {
        switch(datasetType) {
            // most used 2:

            case esriDatasetType.esriDTFeatureDataset:
                return (IMetadata)new FeatureDataset(ds).getFullName();
            case esriDatasetType.esriDTFeatureClass:
                return (IMetadata)new FeatureClass(ds).getFullName();

            // others (unsupported types commented out: could not find corresponding class):

            //case esriDatasetType.esriDTCadDrawing:
            case esriDatasetType.esriDTCadastralFabric:
                return (IMetadata)new CadastralFabric(ds).getFullName();
            //case esriDatasetType.esriDTContainer:
            //case esriDatasetType.esriDTGeo:
            case esriDatasetType.esriDTGeometricNetwork:
                return (IMetadata)new GeometricNetwork(ds).getFullName();
            //case esriDatasetType.esriDTLayer:
            //case esriDatasetType.esriDTLocator:
            //case esriDatasetType.esriDTMap:
            //case esriDatasetType.esriDTMosaicDataset:
            case esriDatasetType.esriDTNetworkDataset:
                return (IMetadata)new NetworkDataset(ds).getFullName();
            //case esriDatasetType.esriDTPlanarGraph:
            case esriDatasetType.esriDTRasterBand:
                return (IMetadata)new RasterBand(ds).getFullName();
            case esriDatasetType.esriDTRasterCatalog:
                return (IMetadata)new RasterCatalog(ds).getFullName();
            case esriDatasetType.esriDTRasterDataset:
                return (IMetadata)new RasterDataset(ds).getFullName();
            case esriDatasetType.esriDTRelationshipClass:
                return (IMetadata)new RelationshipClass(ds).getFullName();
            case esriDatasetType.esriDTRepresentationClass:
                return (IMetadata)new RepresentationClass(ds).getFullName();
            case esriDatasetType.esriDTSchematicDataset:
                return (IMetadata)new SchematicDataset(ds).getFullName();
            //case esriDatasetType.esriDTStyle:
            case esriDatasetType.esriDTTable:
                return (IMetadata)new Table(ds).getFullName();
            case esriDatasetType.esriDTTerrain:
                return (IMetadata)new Terrain(ds).getFullName();
            //case esriDatasetType.esriDTText:
            case esriDatasetType.esriDTTin:
                return (IMetadata)new Tin(ds).getFullName();
            //case esriDatasetType.esriDTTool:
            //case esriDatasetType.esriDTToolbox:
            case esriDatasetType.esriDTTopology:
                return (IMetadata)new Topology(ds).getFullName();
            default:
                throw new B3PCatalogException("DatasetType " + datasetType + " not supported in a leaf in a FGDB");
        }
    }

    public static List<Dir> getAllDirDatasets(File fileGDBPath, ActionBeanContext context) throws IOException {
        List<Dir> files = new ArrayList<Dir>();

        IDataset targetDataset = getTargetDataset(fileGDBPath, esriDatasetType.esriDTFeatureDataset);

        IEnumDataset enumDataset = targetDataset.getSubsets();
        IDataset ds;
        while ((ds = enumDataset.next()) != null) {
            if (ds.getType() == esriDatasetType.esriDTFeatureDataset) {
                Dir dir = new Dir();
                dir.setName(ds.getName());
                dir.setPath(Rewrite.getFileNameRelativeToRootDirPP(new File(fileGDBPath, ds.getName()), context));
                files.add(dir);
            }
        }
        return files;
    }

    public static List<nl.b3p.catalog.filetree.File> getAllFileDatasets(File fileGDBPath, ActionBeanContext context) throws IOException {
        List<nl.b3p.catalog.filetree.File> files = new ArrayList<nl.b3p.catalog.filetree.File>();

        IDataset targetDataset = getTargetDataset(fileGDBPath, esriDatasetType.esriDTFeatureDataset);
        
        IEnumDataset enumDataset = targetDataset.getSubsets();
        IDataset ds;
        while ((ds = enumDataset.next()) != null) {
            if (ds.getType() != esriDatasetType.esriDTFeatureDataset) {
                nl.b3p.catalog.filetree.File file = new nl.b3p.catalog.filetree.File();
                file.setName(ds.getName());
                file.setPath(Rewrite.getFileNameRelativeToRootDirPP(new File(fileGDBPath, ds.getName()), context));
                file.setIsGeo(true);
                file.setEsriType(ds.getType());
                files.add(file);
            }
        }
        return files;
    }

    public static IDataset getTargetDataset(File fileGDBPath, int dataType) throws IOException {
        IDataset targetDataset = null;
        if (FGDBHelperProxy.isFGDBDir(fileGDBPath)) {
            targetDataset = getWorkspace(fileGDBPath.getCanonicalPath());
        } else if (FGDBHelperProxy.isInsideFGDBDir(fileGDBPath)) {
            File fgdb = FGDBHelperProxy.getRootFGDBDir(fileGDBPath);
            File currentDirFile = fileGDBPath;
            List<String> subDirList = new LinkedList<String>();
            while (!currentDirFile.getCanonicalFile().equals(fgdb.getCanonicalFile())) {
                subDirList.add(0, currentDirFile.getName());
                currentDirFile = currentDirFile.getParentFile();
            }
            targetDataset = getWorkspace(fgdb.getCanonicalPath());
            for (String subDir : subDirList) {
                if (!subDir.equals(subDirList.get(subDirList.size() - 1))) {
                    targetDataset = getDataset(targetDataset, subDir, esriDatasetType.esriDTFeatureDataset);
                } else {
                    targetDataset = getDataset(targetDataset, subDir, dataType);
                }
            }
        } else {
            throw new IOException("Not a FGDB or inside a FGDB: " + fileGDBPath.getAbsolutePath());
        }
        return targetDataset;
    }

    private static IDataset getDataset(IDataset dataset, String name, int datasetType) throws IOException {
        IEnumDataset enumDataset = dataset.getSubsets();
        IDataset ds;
        while ((ds = enumDataset.next()) != null) {
            if (ds.getType() == datasetType && ds.getName().equals(name)) {
                return ds;
            }
        }
        return null;
    }

    private static Workspace getWorkspace(String fileGDBPath) throws IOException {
        FileGDBWorkspaceFactory factory = new FileGDBWorkspaceFactory();
        return new Workspace(factory.openFromFile(fileGDBPath, 0));
    }

    public static void logAllDatasets(File fileGDBPath) throws IOException {
        IDataset targetDataset = getTargetDataset(fileGDBPath, esriDatasetType.esriDTFeatureDataset);
        IEnumDataset enumDataset = targetDataset.getSubsets();
        log.debug("esriDatasetType.esriDTAny: " + esriDatasetType.esriDTAny);
        log.debug("esriDatasetType.esriDTContainer: " + esriDatasetType.esriDTContainer);
        log.debug("esriDatasetType.esriDTFeatureDataset: " + esriDatasetType.esriDTFeatureDataset);
        log.debug("esriDatasetType.esriDTFeatureClass: " + esriDatasetType.esriDTFeatureClass);
        log.debug("esriDatasetType.esriDTGeometricNetwork: " + esriDatasetType.esriDTGeometricNetwork);
        IDataset ds;
        while ((ds = enumDataset.next()) != null) {
            log.debug(ds.getName());
            log.debug(ds.getType());
        }
    }

}
