/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

package nl.b3p.catalog.arcgis;

import java.io.File;
import java.io.FilenameFilter;
import java.io.IOException;
import java.util.List;
import net.sourceforge.stripes.action.ActionBeanContext;
import nl.b3p.catalog.B3PCatalogException;
import nl.b3p.catalog.filetree.Dir;
import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;

/**
 * Always use this class to access the FGDBHelper.
 * In case ArcGIS is not installed, you will get a NoClassDefFoundError while loading the class FGDBHelper, if you don't.
 * @author Erik van de Pol
 */
public class FGDBHelperProxy {
    private final static Log log = LogFactory.getLog(FGDBHelperProxy.class);

    private static void rethrow(NoClassDefFoundError ncdfex) throws B3PCatalogException {
        String message = "ArcGIS is niet (of niet correct) geïnstalleerd. Om metadata te bekijken en weg te schrijven in deze ESRI File based Geodatabase (FGDB) is dit nodig.";
        log.warn(message, ncdfex);
        throw new ArcObjectsNotFoundException(message, ncdfex);
    }
    
    public static File getRootFGDBDir(File file) {
        while (file != null) {
            if (isFGDBDir(file)) {
                return file;
            } else {
                file = file.getParentFile();
            }
        }
        return null;
    }

    public static String getRootFGDBDirname(File file) {
        File root = getRootFGDBDir(file);
        if (root == null) {
            return null;
        } else {
            return root.getAbsolutePath();
        }
    }

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

    public static boolean isInsideFGDBDir(File file) {
        if (file == null)
            return false;

        file = file.getParentFile();
        return isFGDBDirOrInsideFGDBDir(file);
    }

    public static boolean isFGDBDir(File file) {
        if (!file.exists() || !file.isDirectory())
            return false;
        String[] gdbFiles = file.list(new FilenameFilter() {
            public boolean accept(File dir, String name) {
                return name.equals("gdb");
            }
        });
        if (gdbFiles == null)
            return false;
        return gdbFiles.length >= 1;
    }

    public static String getMetadata(File fileGDBPath, int datasetType) throws IOException, B3PCatalogException {
        try {
            return FGDBHelper.getMetadata(fileGDBPath, datasetType);
        } catch(NoClassDefFoundError ncdfex) {
            rethrow(ncdfex); return null;
        }
    }

    public static void setMetadata(File fileGDBPath, int datasetType, String metadata) throws IOException, B3PCatalogException {
        try {
            FGDBHelper.setMetadata(fileGDBPath, datasetType, metadata);
        } catch(NoClassDefFoundError ncdfex) {
            rethrow(ncdfex);
        }
    }

    public static List<Dir> getAllDirDatasets(File fileGDBPath, String currentPath) throws IOException, B3PCatalogException {
        try {
            return FGDBHelper.getAllDirDatasets(fileGDBPath, currentPath);
        } catch(NoClassDefFoundError ncdfex) {
            rethrow(ncdfex); return null;
        }
    }

    public static List<nl.b3p.catalog.filetree.DirEntry> getAllFileDatasets(File fileGDBPath, String currentPath) throws IOException, B3PCatalogException {
        try {
            return FGDBHelper.getAllFileDatasets(fileGDBPath, currentPath);
        } catch(NoClassDefFoundError ncdfex) {
            rethrow(ncdfex); return null;
        }
    }

    public static void logAllDatasets(File fileGDBPath) throws IOException, B3PCatalogException {
        try {
            FGDBHelper.logAllDatasets(fileGDBPath);
        } catch(NoClassDefFoundError ncdfex) {
            rethrow(ncdfex);
        }
    }

}
