/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

package nl.b3p.catalog.filetree;

import java.util.ArrayList;
import java.util.List;
import net.sourceforge.stripes.action.ActionBeanContext;

/**
 *
 * @author Erik van de Pol
 */
public class Rewrite {
    protected final static String PRETTY_DIR_SEPARATOR = "/";
    
    public static java.io.File getFileFromPPFileName(String fileName, ActionBeanContext context) {
        String subPath = fileName.replace(PRETTY_DIR_SEPARATOR, java.io.File.separator);
        return new java.io.File(getRootDirectoryIOFile(context), subPath);
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
        String absName = file.getAbsolutePath();
        String uploadDir = getRootDirectory(context);
        if (uploadDir == null || !absName.startsWith(uploadDir)) {
            return null;
        } else {
            return absName.substring(getRootDirectory(context).length());
        }
    }

    public static String getRootDirectory(ActionBeanContext context) {
        return getRootDirectoryIOFile(context).getAbsolutePath();
    }

    /**
     * Nu nog maar ondersteuning voor één afzonderlijke root.
     * @return
     */
    public static java.io.File getRootDirectoryIOFile(ActionBeanContext context) {
        String catalogRoots = context.getServletContext().getInitParameter("CatalogRoots");
        List<Root> roots = new ArrayList<Root>();
        for (String catalogRoot : catalogRoots.split(";")) {
            String[] catalogRootSplit = catalogRoot.split(",");
            if (catalogRootSplit.length > 0) {
                String path = catalogRootSplit[0];
                String prettyName = catalogRootSplit.length > 1 ? catalogRootSplit[1] : null;
                roots.add(new Root(path, prettyName));
            }
        }
        if (roots.isEmpty())
            throw new RuntimeException("'CatalogRoots' context parameter not or uncorrectly defined: " + catalogRoots);
        return new java.io.File(roots.get(0).getPath());
    }
}
