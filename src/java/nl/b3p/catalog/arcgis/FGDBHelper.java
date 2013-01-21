/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

package nl.b3p.catalog.arcgis;

import com.esri.arcgis.datasourcesGDB.FileGDBWorkspaceFactory;
import com.esri.arcgis.geodatabase.IDataset;
import com.esri.arcgis.geodatabase.IEnumDataset;
import com.esri.arcgis.geodatabase.IMetadata;
import com.esri.arcgis.geodatabase.Workspace;
import com.esri.arcgis.geodatabase.XmlPropertySet;
import com.esri.arcgis.geodatabase.esriDatasetType;
import com.esri.arcgis.system.Cleaner;
import java.io.File;
import java.io.IOException;
import java.util.ArrayList;
import java.util.LinkedList;
import java.util.List;
import nl.b3p.catalog.B3PCatalogException;
import nl.b3p.catalog.filetree.Dir;
import nl.b3p.catalog.filetree.DirEntry;
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
        IDataset ds = getTargetDataset(fileGDBPath, datasetType);
        return (IMetadata)DatasetHelper.getIDataset(ds).getFullName();
    }
    
    public static List<Dir> getAllDirDatasets(File fileGDBPath, String currentPath) throws IOException {
        List<Dir> files = new ArrayList<Dir>();

        IDataset targetDataset = getTargetDataset(fileGDBPath, esriDatasetType.esriDTFeatureDataset);

        IEnumDataset enumDataset = targetDataset.getSubsets();
        IDataset ds;
        while ((ds = enumDataset.next()) != null) {
            if (ds.getType() == esriDatasetType.esriDTFeatureDataset) {
                Dir dir = new Dir();
                dir.setName(ds.getName());
                dir.setPath(currentPath + ds.getName());
                files.add(dir);
            }
        }
        return files;
    }

    public static List<nl.b3p.catalog.filetree.DirEntry> getAllFileDatasets(File fileGDBPath, String currentPath) throws IOException {
        List<nl.b3p.catalog.filetree.DirEntry> files = new ArrayList<nl.b3p.catalog.filetree.DirEntry>();

        IDataset targetDataset = getTargetDataset(fileGDBPath, esriDatasetType.esriDTFeatureDataset);
        
        IEnumDataset enumDataset = targetDataset.getSubsets();
        IDataset ds;
        while ((ds = enumDataset.next()) != null) {
            if (ds.getType() != esriDatasetType.esriDTFeatureDataset) {
                DirEntry file = new nl.b3p.catalog.filetree.DirEntry();
                file.setName(ds.getName());
                file.setPath(currentPath + ds.getName());
                file.setIsGeo(true);
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
            if(subDirList.size()>2) {
                throw new IllegalStateException("Feature datasets inside feature datasets not supported");
            }
            targetDataset = getWorkspace(fgdb.getCanonicalPath());
            for (String subDir : subDirList) {
                if (!subDir.equals(subDirList.get(subDirList.size() - 1))) {
                    targetDataset = DatasetHelper.getDataSubset(targetDataset, subDir, esriDatasetType.esriDTFeatureDataset);
                } else {
                    targetDataset = DatasetHelper.getDataSubset(targetDataset, subDir, dataType);
                }
            }
        } else {
            throw new IOException("Not a FGDB or inside a FGDB: " + fileGDBPath.getAbsolutePath());
        }
        return targetDataset;
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
    
    public static void cleanerTrackObjectsInCurrentThread() {
        Cleaner.trackObjectsInCurrentThread();
    }
    
    public static void cleanerReleaseAllInCurrentThread() {
        Cleaner.releaseAllInCurrentThread();
    }
}
