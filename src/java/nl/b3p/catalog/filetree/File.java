/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

package nl.b3p.catalog.filetree;

import java.util.Arrays;
import java.util.List;

/**
 *
 * @author Erik van de Pol
 */
public class File {
    private static final List<String> DOUBLE_EXTENSIONS = Arrays.asList("url", "lnk");
    // Full PP path from upload dir
    private String path;
    // local file name
    private String name;

    private boolean isGeo;

    public File() {
        
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public String getPath() {
        return path;
    }

    public void setPath(String path) {
        this.path = path;
    }

    public String getExtension() {
        return getExtension(name);
    }

    public static String getExtension(String filename) {
        String extName = filename;
        String lastExt = extName.substring(extName.lastIndexOf(".") + 1).toLowerCase();
        if (DOUBLE_EXTENSIONS.contains(lastExt))
            extName = extName.substring(0, extName.lastIndexOf("."));
        return extName.substring(extName.lastIndexOf(".") + 1).toLowerCase();
    }

    public boolean isIsGeo() {
        return isGeo;
    }

    public void setIsGeo(boolean isGeo) {
        this.isGeo = isGeo;
    }

}
