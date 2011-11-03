/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package nl.b3p.catalog.arcgis;

import java.io.IOException;
import nl.b3p.catalog.B3PCatalogException;
import nl.b3p.catalog.config.Root;
import nl.b3p.catalog.config.SDERoot;
import nl.b3p.catalog.filetree.DirContent;
import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;

/**
 * Why proxy? See FGDBHelperProxy.
 * @author Erik van de Pol
 */
public class ArcSDEHelperProxy {
    private final static Log log = LogFactory.getLog(ArcSDEHelperProxy.class);

    static void rethrow(NoClassDefFoundError ncdfex) throws B3PCatalogException {
        String message = "ArcObjects is niet goed geinitialiseerd. Om metadata te bekijken en weg te schrijven in ArcSDE is dit nodig.";
        log.warn(message, ncdfex);
        throw new ArcObjectsNotFoundException(message, ncdfex);
    }

    public static DirContent getDirContent(Root root, String fullPath) throws IOException, B3PCatalogException {
        try {
            return ArcSDEHelper.getDirContent((SDERoot)root, fullPath);
        } catch(NoClassDefFoundError ncdfex) {
            rethrow(ncdfex); return null;
        }
    }    
    
    public static Object getDataset(Root root, String path) throws Exception {
        try {
            return ArcSDEHelper.getDataset(root, path);
        } catch(NoClassDefFoundError ncdfex) {
            rethrow(ncdfex); return null;
        }
    }    
    
    public static String getMetadata(Object dataset) throws Exception {
        try {
            return ArcSDEHelper.getMetadata(dataset);
        } catch(NoClassDefFoundError ncdfex) {
            rethrow(ncdfex); return null;
        }
    }
    
    public static String getMetadata(Root root, String path) throws Exception {
        try {
            return ArcSDEHelper.getMetadata(ArcSDEHelper.getDataset(root, path));
        } catch(NoClassDefFoundError ncdfex) {
            rethrow(ncdfex); return null;
        }
    }

    public static void saveMetadata(Object dataset, String metadata) throws Exception {
        try {
            ArcSDEHelper.saveMetadata(dataset, metadata);
        } catch(NoClassDefFoundError ncdfex) {
            rethrow(ncdfex);
        }
    }
}
