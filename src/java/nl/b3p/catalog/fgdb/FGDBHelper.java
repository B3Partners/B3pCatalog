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

    public static boolean isFGDBDirOrInsideFGDBDir(File file) {
        while (file != null) {
            if (isFGDBDir(file)) {
                return true;
            } else {
                file = file.getParentFile();
            }
        }
        return false;
    }

    private static boolean isInsideFGDBDir(File file) {
        if (file == null)
            return false;

        file = file.getParentFile();
        return isFGDBDirOrInsideFGDBDir(file);
    }

    private static boolean isFGDBDir(File file) {
        if (!file.exists() || !file.isDirectory())
            return false;
        String[] gdbFiles = file.list(new FilenameFilter() {
            public boolean accept(File dir, String name) {
                return name.equals("gdb");
            }
        });
        return gdbFiles.length >= 1;
    }

    private static File getRootFGDBDir(File file) throws IOException {
        while (file != null) {
            if (isFGDBDir(file)) {
                return file;
            } else {
                file = file.getParentFile();
            }
        }
        return null;
    }

    // dit save en load moet met dezelfde XmlPropertySet ?!?!
    public static String getMetadata(XmlPropertySet xmlPropertySet, int datasetType) throws IOException, B3PCatalogException {
        return xmlPropertySet.getXml("/");
    }

    public static void setMetadata(XmlPropertySet xmlPropertySet, int datasetType, String metadata) throws IOException, B3PCatalogException {
        log.debug("before: " + xmlPropertySet.getXml("/"));
        xmlPropertySet.setXml(metadata);
        log.debug("after: " + xmlPropertySet.getXml("/"));
    }

    public static XmlPropertySet getXmlPropertySet(File fileGDBPath, int datasetType) throws IOException, B3PCatalogException {
        IDataset ds = getTargetDataset(fileGDBPath, datasetType);
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

    private static IDataset getTargetDataset(File fileGDBPath, int dataType) throws IOException {
        IDataset targetDataset = null;
        if (isFGDBDir(fileGDBPath)) {
            targetDataset = getWorkspace(fileGDBPath.getCanonicalPath());
        } else if (isInsideFGDBDir(fileGDBPath)) {
            File fgdb = getRootFGDBDir(fileGDBPath);
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
