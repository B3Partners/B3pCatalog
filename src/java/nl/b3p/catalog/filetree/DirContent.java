/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

package nl.b3p.catalog.filetree;

import java.util.List;

/**
 *
 * @author Erik van de Pol
 */
public class DirContent {
    protected List<Dir> dirs;
    protected List<File> files;

    public DirContent() {
        
    }

    public List<Dir> getDirs() {
        return dirs;
    }

    public void setDirs(List<Dir> dirs) {
        this.dirs = dirs;
    }

    public List<File> getFiles() {
        return files;
    }

    public void setFiles(List<File> files) {
        this.files = files;
    }


}
