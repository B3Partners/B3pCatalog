/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

package nl.b3p.catalog.filetree;

import java.util.ArrayList;
import java.util.Collections;
import java.util.Comparator;
import java.util.List;
import nl.b3p.catalog.config.CatalogAppConfig;

/**
 *
 * @author Erik van de Pol
 */
public class DirContent {
    public static final char SEPARATOR = '/';
    
    protected List<Dir> dirs = new ArrayList<Dir>();
    protected List<DirEntry> files = new ArrayList<DirEntry>();

    public DirContent() {
    }

    public List<Dir> getDirs() {
        return dirs;
    }

    public void setDirs(List<Dir> dirs) {
        this.dirs = dirs;
    }

    public List<DirEntry> getFiles() {
        return files;
    }

    public void setFiles(List<DirEntry> files) {
        this.files = files;
    }
    
    public void sort() {
        Collections.sort(dirs, new DirnameComparator());
        Collections.sort(files, new FilenameComparator());
    }
    
    private class DirnameComparator implements Comparator<Dir> {
        @Override
        public int compare(Dir d1, Dir d2) {
            String s1 = d1.getName();
            String s2 = d2.getName();
            return s1.compareToIgnoreCase(s2);
        }
    }   
    
    private class FilenameComparator implements Comparator<nl.b3p.catalog.filetree.DirEntry> {
        @Override
        public int compare(nl.b3p.catalog.filetree.DirEntry f1, nl.b3p.catalog.filetree.DirEntry f2) {
            String s1 = f1.getName();
            String s2 = f2.getName();
            return s1.compareToIgnoreCase(s2);
        }
    }    
}
