/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

package nl.b3p.catalog.stripes;

/**
 *
 * @author Erik van de Pol
 */

import java.io.File;
import java.io.FileFilter;
import java.util.ArrayList;
import java.util.Collections;
import java.util.Comparator;
import java.util.LinkedList;
import java.util.List;
import net.sourceforge.stripes.action.ForwardResolution;
import net.sourceforge.stripes.action.Resolution;
import net.sourceforge.stripes.util.Log;
import nl.b3p.catalog.filetree.Dir;
import nl.b3p.catalog.filetree.DirContent;
import nl.b3p.catalog.filetree.Root;

/**
 *
 * @author Erik van de Pol
 */
public class FiletreeAction extends DefaultAction {

    private final static Log log = Log.getInstance(FiletreeAction.class);

    protected final static String SHAPE_EXT = ".shp";
    protected final static String PRETTY_DIR_SEPARATOR = "/";
    /*protected final static String[] ALLOWED_CONTENT_TYPES = {
        ""
    };*/

    private final static String DIRCONTENTS_JSP = "/WEB-INF/jsp/main/file/filetreeConnector.jsp";

    private DirContent dirContent;
    private String dir;
    private String expandTo;
    private String selectedFilePath;
    

    public Resolution listDir() {
        log.debug("Directory requested: " + dir);
        log.debug("expandTo: " + expandTo);

        File directory = null;
        if (dir != null) {
            // wordt dit niet gewoon goed geregeld met user privileges?
            // De tomcat user kan in *nix niet naar de root / parent dir?
            // Voorbeelden bekijken / info inwinnen.
            if (dir.contains("..")) {
                log.error("Possible hack attempt; Dir requested: " + dir);
                return null;
            }

            directory = getFileFromPPFileName(dir);
        } else {
            directory = getRootDirectoryIOFile();
        }

        if (expandTo == null) {
            dirContent = getDirContent(directory, null);
        } else {
            selectedFilePath = expandTo.trim().replace("\n", "").replace("\r", "");
            log.debug("selectedFilePath/expandTo: " + selectedFilePath);

            List<String> subDirList = new LinkedList<String>();

            File currentDirFile = getFileFromPPFileName(selectedFilePath);
            while (!currentDirFile.getAbsolutePath().equals(directory.getAbsolutePath())) {
                subDirList.add(0, currentDirFile.getName());
                currentDirFile = currentDirFile.getParentFile();
            }

            dirContent = getDirContent(directory, subDirList);
        }

        //log.debug("dirs: " + directories.size());
        //log.debug("files: " + files.size());

        return new ForwardResolution(DIRCONTENTS_JSP);
    }

    protected DirContent getDirContent(File directory, List<String> subDirList) {
        DirContent dc = new DirContent();

        File[] dirs = directory.listFiles(new FileFilter() {
            public boolean accept(File file) {
                return file.isDirectory();
            }
        });

        File[] files = directory.listFiles(new FileFilter() {
            public boolean accept(File file) {
                return !file.isDirectory();
            }
        });

        List<Dir> dirsList = new ArrayList<Dir>();
        for (File dir : dirs) {
            Dir newDir = new Dir();
            newDir.setName(dir.getName());
            newDir.setPath(getFileNameRelativeToRootDirPP(dir));
            dirsList.add(newDir);
        }

        List<nl.b3p.catalog.filetree.File> filesList = new ArrayList<nl.b3p.catalog.filetree.File>();
        for (File file : files) {
            nl.b3p.catalog.filetree.File newFile = new nl.b3p.catalog.filetree.File();
            newFile.setName(file.getName());
            newFile.setPath(getFileNameRelativeToRootDirPP(file));
            filesList.add(newFile);
        }

        dc.setDirs(dirsList);
        dc.setFiles(filesList);

        filterOutFilesToHide(dc);

        // sort just at the end, because filters (above) could have needed sorting (of a different kind).
        Collections.sort(dirsList, new DirExtensionComparator());
        Collections.sort(filesList, new FileExtensionComparator());

        if (subDirList != null && subDirList.size() > 0) {
            String subDirString = subDirList.remove(0);

            for (Dir subDir : dc.getDirs()) {
                if (subDir.getName().equals(subDirString)) {
                    File followSubDir = getFileFromPPFileName(subDir.getPath());
                    subDir.setContent(getDirContent(followSubDir, subDirList));
                    break;
                }
            }
        }

        return dc;
    }

    protected void filterOutFilesToHide(DirContent dc) {
        filterOutMetadataFiles(dc);
        filterOutShapeExtraFiles(dc);
    }

    protected void filterOutMetadataFiles(DirContent dc) {
        List<nl.b3p.catalog.filetree.File> toBeIgnoredFiles = new ArrayList<nl.b3p.catalog.filetree.File>();

        List<nl.b3p.catalog.filetree.File> filesList = dc.getFiles();
        Collections.sort(filesList, new FilenameComparator());
        
        String lastFilename = null;
        for (nl.b3p.catalog.filetree.File file : filesList) {
            String filename = file.getName();

            if (lastFilename == null || !filename.startsWith(lastFilename)) {
                lastFilename = filename;
            } else if (filename.length() == (lastFilename.length() + 4) && filename.endsWith(".xml")) {
                toBeIgnoredFiles.add(file);
            }
        }

        for (nl.b3p.catalog.filetree.File file : toBeIgnoredFiles) {
            filesList.remove(file);
        }
    }

    protected void filterOutShapeExtraFiles(DirContent dc) {
        List<String> shapeNames = new ArrayList<String>();
        for (nl.b3p.catalog.filetree.File file : dc.getFiles()) {
            if (file.getName().endsWith(SHAPE_EXT)) {
                shapeNames.add(file.getName().substring(0, file.getName().length() - SHAPE_EXT.length()));
            }
        }

        for (String shapeName : shapeNames) {
            List<nl.b3p.catalog.filetree.File> toBeIgnoredFiles = new ArrayList<nl.b3p.catalog.filetree.File>();
            for (nl.b3p.catalog.filetree.File file : dc.getFiles()) {
                if (file.getName().startsWith(shapeName) && !file.getName().endsWith(SHAPE_EXT)) {
                    toBeIgnoredFiles.add(file);
                }
            }
            for (nl.b3p.catalog.filetree.File file : toBeIgnoredFiles) {
                dc.getFiles().remove(file);
            }
        }
    }

    private File getFileFromPPFileName(String fileName) {
        String subPath = fileName.replace(PRETTY_DIR_SEPARATOR, File.separator);
        return new File(getRootDirectoryIOFile(), subPath);
    }

    public String getFileNameFromPPFileName(String fileName) {
        File file = getFileFromPPFileName(fileName);
        if (file == null) {
            return null;
        } else {
            return file.getAbsolutePath();
        }
    }

    // Pretty printed version of getFileNameRelativeToUploadDir(File file).
    // This name is uniform on all systems where the server runs (*nix or Windows).
    private String getFileNameRelativeToRootDirPP(File file) {
        String name = getFileNameRelativeToRootDir(file);
        if (name == null) {
            return null;
        } else {
            return name.replace(File.separator, PRETTY_DIR_SEPARATOR);
        }
    }

    private String getFileNameRelativeToRootDir(File file) {
        String absName = file.getAbsolutePath();
        String uploadDir = getRootDirectory();
        if (uploadDir == null || !absName.startsWith(uploadDir)) {
            return null;
        } else {
            return absName.substring(getRootDirectory().length());
        }
    }

    private String getRootDirectory() {
        return getRootDirectoryIOFile().getAbsolutePath();
    }

    /**
     * Nu nog maar ondersteuning voor één afzonderlijke root.
     * @return
     */
    private File getRootDirectoryIOFile() {
        String catalogRoots = getContext().getServletContext().getInitParameter("CatalogRoots");
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
        return new File(roots.get(0).getPath());
    }

    public DirContent getDirContent() {
        return dirContent;
    }

    public void setDirContent(DirContent dirContent) {
        this.dirContent = dirContent;
    }

    public String getExpandTo() {
        return expandTo;
    }

    public void setExpandTo(String expandTo) {
        this.expandTo = expandTo;
    }

    public String getDir() {
        return dir;
    }

    public void setDir(String dir) {
        this.dir = dir;
    }

    public String getSelectedFilePath() {
        return selectedFilePath;
    }

    public void setSelectedFilePath(String selectedFilePath) {
        this.selectedFilePath = selectedFilePath;
    }

    // <editor-fold defaultstate="collapsed" desc="Comparison methods for file/dir sorting">
    private int compareExtensions(String s1, String s2) {
        // the +1 is to avoid including the '.' in the extension and to avoid exceptions
        // EDIT:
        // We first need to make sure that either both files or neither file
        // has an extension (otherwise we'll end up comparing the extension of one
        // to the start of the other, or else throwing an exception)
        final int s1Dot = s1.lastIndexOf('.');
        final int s2Dot = s2.lastIndexOf('.');
        if ((s1Dot == -1) == (s2Dot == -1)) { // both or neither
            s1 = s1.substring(s1Dot + 1);
            s2 = s2.substring(s2Dot + 1);
            return s1.compareTo(s2);
        } else if (s1Dot == -1) { // only s2 has an extension, so s1 goes first
            return -1;
        } else { // only s1 has an extension, so s1 goes second
            return 1;
        }
    }

    private class DirExtensionComparator implements Comparator<Dir> {
        @Override
        public int compare(Dir d1, Dir d2) {
            String s1 = d1.getName();
            String s2 = d2.getName();
            return compareExtensions(s1, s2);
        }
    }

    private class FileExtensionComparator implements Comparator<nl.b3p.catalog.filetree.File> {
        @Override
        public int compare(nl.b3p.catalog.filetree.File f1, nl.b3p.catalog.filetree.File f2) {
            String s1 = f1.getName();
            String s2 = f2.getName();
            return compareExtensions(s1, s2);
        }
    }

    private class FilenameComparator implements Comparator<nl.b3p.catalog.filetree.File> {
        @Override
        public int compare(nl.b3p.catalog.filetree.File f1, nl.b3p.catalog.filetree.File f2) {
            String s1 = f1.getName();
            String s2 = f2.getName();
            return s1.compareTo(s2);
        }
    }
// </editor-fold>
}
