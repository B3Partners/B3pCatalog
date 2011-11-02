/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package nl.b3p.catalog.arcgis;

import com.esri.arcgis.geodatabase.IDataset;
import java.io.IOException;
import nl.b3p.catalog.B3PCatalogException;
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
        String message = "ArcGIS is niet (of niet correct) geïnstalleerd. Om metadata te bekijken en weg te schrijven in ArcSDE is dit nodig.";
        log.warn(message, ncdfex);
        throw new ArcObjectsNotFoundException(message, ncdfex);
    }

    public static DirContent getDirContent(SDERoot root, String prefix, String path) throws IOException, B3PCatalogException {
        try {
            return ArcSDEHelper.getDirContent(root, prefix, path);
        } catch(NoClassDefFoundError ncdfex) {
            rethrow(ncdfex); return null;
        }
    }
}
