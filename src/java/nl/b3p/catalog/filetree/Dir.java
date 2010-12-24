/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

package nl.b3p.catalog.filetree;

/**
 *
 * @author Erik van de Pol
 */
public class Dir {
    // Full PP path from upload dir
    private String path;
    // Local dir name
    private String name;
    private DirContent content;

    public Dir() {
        
    }

    public DirContent getContent() {
        return content;
    }

    public void setContent(DirContent content) {
        this.content = content;
    }

    public String getPath() {
        return path;
    }

    public void setPath(String path) {
        this.path = path;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

}
