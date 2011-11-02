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
    private String name;
    private String path;
    private boolean isFGDB;

    public Dir() {
    }

    public Dir(String name, String path) {
        this.name = name;
        this.path = path;
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
