/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

package nl.b3p.catalog.filetree;

/**
 *
 * @author Erik van de Pol
 */
public class Root {
    private String path;
    private String prettyName;

    public Root(String path, String prettyName) {
        this.path = path;
        this.prettyName = prettyName;
    }

    public String getPath() {
        return path;
    }

    public void setPath(String path) {
        this.path = path;
    }

    public String getPrettyName() {
        return prettyName;
    }

    public void setPrettyName(String prettyName) {
        this.prettyName = prettyName;
    }

}
