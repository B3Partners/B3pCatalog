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
    private boolean isFGDB;

    public Dir() {
        
    }

    public Dir(String name, String path) {
        this.name = name;
        this.path = path;
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

    public boolean isIsFGDB() {
        return isFGDB;
    }

    public void setIsFGDB(boolean isFGDB) {
        this.isFGDB = isFGDB;
    }

}
