/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

package nl.b3p.catalog.fgdb;

import com.esri.arcgis.datasourcesGDB.FgdbFeatureClassName;
import com.esri.arcgis.datasourcesGDB.FileGDBWorkspaceFactory;
import com.esri.arcgis.geodatabase.FeatureClass;
import com.esri.arcgis.geodatabase.FeatureDataset;
import com.esri.arcgis.geodatabase.FeatureDatasetName;
import com.esri.arcgis.geodatabase.IDataset;
import com.esri.arcgis.geodatabase.IEnumDataset;
import com.esri.arcgis.geodatabase.Workspace;
import com.esri.arcgis.geodatabase.XmlPropertySet;
import com.esri.arcgis.geodatabase.esriDatasetType;
import java.io.File;
import java.io.FilenameFilter;
import java.io.IOException;
import java.util.ArrayList;
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

    // apart dataType doorgeven vanuit jsp. In filetree als attr zetten.
    // kan namelijk zelfde naam hebben voor een dataset en featureclass in dezelfde gdb. pad is dan hetzelfde: bv C:\\usa.gdb\\highway
    public static XmlPropertySet isFGDB(String filename) throws IOException, B3PCatalogException {
        return isFGDB(new File(filename));
    }

    public static XmlPropertySet isFGDB(File file) throws IOException, B3PCatalogException {
        if (file.exists())
            return null;

        if (isFGDBDir(file))
            throw new UnsupportedOperationException("Metadata for an entire File GeoDB is not yet supported.");

        File parent = file.getParentFile();
        if (parent == null) {
            return null;
        } else if (parent.exists()) {
            if (!parent.isDirectory())
                return null;
            if (isFGDBDir(parent)) {
                // TODO geef doorgegeven featureType mee:
                return getXmlPropertySet(parent.getAbsolutePath(), file.getName(), esriDatasetType.esriDTFeatureClass);
            } else {
                throw new IOException("Wrong path: " + file.getAbsolutePath() + ". Looking for FGDB at: " + parent.getAbsolutePath());
            }
        } else {
            // oneindige nesting lijkt niet mogelijk in ArcCatalog: 2 diep is max: Dataset met daarin iets anders.
            File grandParent = parent.getParentFile();
            if (grandParent == null || !grandParent.isDirectory() || !isFGDBDir(grandParent))
                throw new IOException("Wrong path: " + file.getAbsolutePath() + ". Looking for FGDB at: " + grandParent.getAbsolutePath() + ". Only max depth of 2 supported in a FGDB.");

            // Dit kan als het goed is alleen maar van type esriDTFeatureDataset zijn.
            return getXmlPropertySet(grandParent.getAbsolutePath(), parent.getName(), esriDatasetType.esriDTFeatureDataset);
        }
    }

    public static boolean isFGDBDir(File file) {
        if (!file.isDirectory())
            return false;
        String[] gdbFiles = file.list(new FilenameFilter() {
            public boolean accept(File dir, String name) {
                return name.equals("gdb");
            }
        });
        return gdbFiles.length >= 1;
    }

    public static String getMetadata(String fileGDBPath, String dataset, int datasetType) throws IOException, B3PCatalogException {
        XmlPropertySet xmlPropertySet = getXmlPropertySet(fileGDBPath, dataset, datasetType);
        return getMetadata(xmlPropertySet);
    }

    public static void setMetadata(String fileGDBPath, String dataset, String metadata, int datasetType) throws IOException, B3PCatalogException {
        XmlPropertySet xmlPropertySet = getXmlPropertySet(fileGDBPath, dataset, datasetType);
        setMetadata(xmlPropertySet, metadata);
    }

    public static String getMetadata(XmlPropertySet xmlPropertySet) throws IOException {
        return xmlPropertySet.getXml("/");
    }

    public static void setMetadata(XmlPropertySet xmlPropertySet, String metadata) throws IOException {
        xmlPropertySet.setXml(metadata);
    }

    /*private static XmlPropertySet getFGDBXmlPropertySet(String fileGDBPath) throws Exception {
        Workspace workspace = getFGDB(fileGDBPath);
        WorkspaceName workspaceName = (WorkspaceName) workspace.getFullName();
        return (XmlPropertySet) workspaceName.get.getMetadata();
    }*/

    private static XmlPropertySet getXmlPropertySet(String fileGDBPath, String dataset, int datasetType) throws IOException, B3PCatalogException {
        IDataset ds = getDataset(fileGDBPath, dataset, datasetType);
        log.debug(ds);
        switch(datasetType) {
            case esriDatasetType.esriDTFeatureDataset: {
                FeatureDataset fDataset = new FeatureDataset(ds);
                FeatureDatasetName fDatasetName = (FeatureDatasetName)fDataset.getFullName();
                return (XmlPropertySet)fDatasetName.getMetadata();
            }
            case esriDatasetType.esriDTFeatureClass: {
                FeatureClass fClass = new FeatureClass(ds);
                FgdbFeatureClassName fclassName = (FgdbFeatureClassName)fClass.getFullName();
                return (XmlPropertySet)fclassName.getMetadata();
            }
            default:
                throw new B3PCatalogException("DatasetType " + datasetType + " not supported in a FGDB");
        }
    }

    private static IDataset getDataset(String fileGDBPath, String dataset, int datasetType) throws IOException, B3PCatalogException {
        IEnumDataset enumDataset = getDatasets(fileGDBPath, datasetType);
        IDataset ds;
        while ((ds = enumDataset.next()) != null) {
            if (ds.getName().equals(dataset))
                return ds;
        }
        throw new B3PCatalogException("Dataset " + dataset + " not found in FileGDB " + fileGDBPath);
    }

    public static List<Dir> getAllCollectionDatasets(String fileGDBPath, ActionBeanContext context) throws IOException {
        List<Dir> files = new ArrayList<Dir>();
        IEnumDataset enumDataset = getFeatureDatasets(fileGDBPath);
        IDataset ds;
        while ((ds = enumDataset.next()) != null) {
            Dir dir = new Dir();
            dir.setName(ds.getName());
            dir.setPath(Rewrite.getFileNameRelativeToRootDirPP(new File(fileGDBPath, ds.getName()), context));
            files.add(dir);
        }
        return files;
    }

    public static List<nl.b3p.catalog.filetree.File> getAllNonCollectionDatasets(String fileGDBPath, ActionBeanContext context) throws IOException {
        List<nl.b3p.catalog.filetree.File> files = new ArrayList<nl.b3p.catalog.filetree.File>();
        IEnumDataset enumDataset = getAnyDatasets(fileGDBPath);
        IDataset ds;
        while ((ds = enumDataset.next()) != null) {
            if (ds.getType() != esriDatasetType.esriDTFeatureDataset) {
                nl.b3p.catalog.filetree.File file = new nl.b3p.catalog.filetree.File();
                file.setName(ds.getName());
                file.setPath(Rewrite.getFileNameRelativeToRootDirPP(new File(fileGDBPath, ds.getName()), context));
                file.setIsGeo(true);
                files.add(file);
            }
        }
        return files;
    }

    public static void logAllDatasets(String fileGDBPath) throws IOException {
        IEnumDataset enumDataset = getAnyDatasets(fileGDBPath);
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

    private static IEnumDataset getDatasets(String fileGDBPath, int esriDatasetType) throws IOException {
        Workspace workspace = getWorkspace(fileGDBPath);
        return workspace.getDatasets(esriDatasetType);
    }

    private static IEnumDataset getFeatureClassDatasets(String fileGDBPath) throws IOException {
        Workspace workspace = getWorkspace(fileGDBPath);
        return workspace.getDatasets(esriDatasetType.esriDTFeatureClass);
    }

    private static IEnumDataset getFeatureDatasets(String fileGDBPath) throws IOException {
        Workspace workspace = getWorkspace(fileGDBPath);
        return workspace.getDatasets(esriDatasetType.esriDTFeatureDataset);
    }

    private static IEnumDataset getContainers(String fileGDBPath) throws IOException {
        Workspace workspace = getWorkspace(fileGDBPath);
        return workspace.getDatasets(esriDatasetType.esriDTContainer);
    }

    private static IEnumDataset getAnyDatasets(String fileGDBPath) throws IOException {
        Workspace workspace = getWorkspace(fileGDBPath);
        return workspace.getDatasets(esriDatasetType.esriDTAny);
    }

    private static Workspace getWorkspace(String fileGDBPath) throws IOException {
        FileGDBWorkspaceFactory factory = new FileGDBWorkspaceFactory();
        return new Workspace(factory.openFromFile(fileGDBPath, 0));
    }
}
