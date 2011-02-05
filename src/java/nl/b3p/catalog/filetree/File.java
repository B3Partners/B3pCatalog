/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

package nl.b3p.catalog.filetree;

/**
 *
 * @author Erik van de Pol
 */
public class File {
    // Full PP path from upload dir
    private String path;
    // local file name
    private String name;

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
        return name.substring(name.lastIndexOf(".") + 1).toLowerCase();
    }

}
