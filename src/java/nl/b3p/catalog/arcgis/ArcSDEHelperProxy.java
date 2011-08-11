/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package nl.b3p.catalog.arcgis;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;
import java.util.TreeMap;
import net.sourceforge.stripes.action.ActionBeanContext;
import nl.b3p.catalog.filetree.ArcSDERoot;
import nl.b3p.catalog.filetree.Root;
import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;

/**
 * Why proxy? See FGDBHelperProxy.
 * @author Erik van de Pol
 */
public class ArcSDEHelperProxy {
    private final static Log log = LogFactory.getLog(ArcSDEHelperProxy.class);

    public static boolean startsWithARoot(String rootPPPath, ActionBeanContext context) {
        Root root = getRoot(rootPPPath, context);

        if (root == null)
            throw new SecurityException("Attempt to access a file not situated under a root: " + rootPPPath);

        return root != null;
    }
    
    public static Root getRoot(String rootPPPath, ActionBeanContext context) {
        if (rootPPPath == null)
            return null;

        return getRootsMap(context).get(rootPPPath.trim());
    }

    public static List<Root> getRoots(ActionBeanContext context) {
        return new ArrayList<Root>(getRootsMap(context).values());
    }
    
    public static Map<String, Root> getRootsMap(ActionBeanContext context) {
        String catalogRoots = context.getServletContext().getInitParameter("ArcSDERoots");
        Map<String, Root> roots = new TreeMap<String, Root>(); // TreeMap ipv HashMap omdat "values()" dan gesorteerd zijn: zie "getRoots()"
        for (String catalogRoot : catalogRoots.split("\n")) {
            String[] catalogRootSplit = catalogRoot.split(",");
            if (catalogRootSplit.length > 0) {
                String connectionString = catalogRootSplit[0].trim();
                String prettyName = catalogRootSplit.length > 1 ? catalogRootSplit[1].trim() : "";
                try {
                    // TODO?: hier al checken of de connectionstring klopt?
                    Root root = new ArcSDERoot(connectionString, prettyName);
                    roots.put(root.getPath(), root);
                } catch (Exception e) {
                    log.error(e);
                }
            }
        }
        return roots;
    }
    
}
