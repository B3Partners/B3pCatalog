/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

package nl.b3p.catalog.filetree;

import java.util.ArrayList;
import java.util.List;
import net.sourceforge.stripes.action.ActionBeanContext;
import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;

/**
 *
 * @author Erik van de Pol
 */
public class Rewrite {
    private final static Log log = LogFactory.getLog(Rewrite.class);

    protected final static String PRETTY_DIR_SEPARATOR = "\\";
    
    public static java.io.File getFileFromPPFileName(String fileName, ActionBeanContext context) {
        String subPath = fileName.replace(PRETTY_DIR_SEPARATOR, java.io.File.separator);
        return new java.io.File(subPath);
    }

    public static String getFileNameFromPPFileName(String fileName, ActionBeanContext context) {
        java.io.File file = getFileFromPPFileName(fileName, context);
        if (file == null) {
            return null;
        } else {
            return file.getAbsolutePath();
        }
    }

    // Pretty printed version of getFileNameRelativeToUploadDir(File file).
    // This name is uniform on all systems where the server runs (*nix or Windows).
    public static String getFileNameRelativeToRootDirPP(java.io.File file, ActionBeanContext context) {
        String name = getFileNameRelativeToRootDir(file, context);
        if (name == null) {
            return null;
        } else {
            return name.replace(java.io.File.separator, PRETTY_DIR_SEPARATOR);
        }
    }

    public static String getFileNameRelativeToRootDir(java.io.File file, ActionBeanContext context) {
        return file.getAbsolutePath();
    }

    public static List<Root> getRoots(ActionBeanContext context) {
        String catalogRoots = context.getServletContext().getInitParameter("CatalogRoots");
        List<Root> roots = new ArrayList<Root>();
        for (String catalogRoot : catalogRoots.split(";")) {
            String[] catalogRootSplit = catalogRoot.split(",");
            if (catalogRootSplit.length > 0) {
                String path = catalogRootSplit[0].trim();
                String prettyName = catalogRootSplit.length > 1 ? catalogRootSplit[1].trim() : "";
                if (new java.io.File(path).exists()) {
                    roots.add(new Root(path, prettyName));
                } else {
                    log.error("Root does not exist: " + path + ". See web.xml.");
                }
            }
        }
        return roots;
    }

}
