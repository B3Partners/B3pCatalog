/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package nl.b3p.catalog.arcgis;

import java.io.IOException;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;
import java.util.TreeMap;
import net.sourceforge.stripes.action.ActionBeanContext;
import nl.b3p.catalog.B3PCatalogException;
import nl.b3p.catalog.filetree.ArcSDERoot;
import nl.b3p.catalog.filetree.Dir;
import nl.b3p.catalog.filetree.Root;
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

    public static Root getRoot(String rootPPPath, ActionBeanContext context) {
        if (rootPPPath == null)
            return null;

        return getRootsMap(context).get(rootPPPath.trim());
    }

    public static List<ArcSDERoot> getRoots(ActionBeanContext context) {
        return new ArrayList<ArcSDERoot>(getRootsMap(context).values());
    }
    
    public static Map<String, ArcSDERoot> getRootsMap(ActionBeanContext context) {
        String catalogRoots = context.getServletContext().getInitParameter("ArcSDERoots");
        Map<String, ArcSDERoot> roots = new TreeMap<String, ArcSDERoot>(); // TreeMap ipv HashMap omdat "values()" dan gesorteerd zijn: zie "getRoots()"
        int index = 0;
        for (String catalogRoot : catalogRoots.split("\n")) {
            String[] catalogRootSplit = catalogRoot.split(",");
            if (catalogRootSplit.length > 0) {
                String connectionString = catalogRootSplit[0].trim();
                String prettyName = catalogRootSplit.length > 1 ? catalogRootSplit[1].trim() : "";

                ArcSDERoot root = new ArcSDERoot(index, connectionString, prettyName);
                roots.put(root.getPath(), root);
            }
        }
        return roots;
    }

    public static List<Dir> getFeatureDatasets(ArcSDERoot sdeRoot, String path) throws IOException, B3PCatalogException {
        try {
            return ArcSDEHelper.getFeatureDatasets(sdeRoot, path);
        } catch(NoClassDefFoundError ncdfex) {
            rethrow(ncdfex); return null;
        }
    }

    public static List<nl.b3p.catalog.filetree.File> getFeatureClasses(ArcSDERoot sdeRoot, String path) throws IOException, B3PCatalogException {
        try {
            return ArcSDEHelper.getFeatureClasses(sdeRoot, path);
        } catch(NoClassDefFoundError ncdfex) {
            rethrow(ncdfex); return null;
        }
    }

    public static List<nl.b3p.catalog.filetree.File> getFeatureClassesInDataset(ArcSDERoot sdeRoot, String path, String dataset) throws Exception {
        try {
            return ArcSDEHelper.getFeatureClassesInDataset(sdeRoot, path, dataset);
        } catch(NoClassDefFoundError ncdfex) {
            rethrow(ncdfex); return null;
        }
    }
}
