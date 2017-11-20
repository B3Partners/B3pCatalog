/*
 * Copyright (C) 2011 B3Partners B.V.
 *
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program.  If not, see <http://www.gnu.org/licenses/>.
 */
package nl.b3p.catalog.filetree;

import java.io.File;
import java.io.FileNotFoundException;
import java.io.IOException;
import java.util.ArrayList;
import java.util.List;
import java.util.Locale;
import java.util.Set;
import nl.b3p.catalog.arcgis.FGDBHelperProxy;
import nl.b3p.catalog.config.CatalogAppConfig;
import nl.b3p.catalog.config.FileRoot;
import nl.b3p.catalog.config.Root;
import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;

/**
 *
 * @author Matthijs Laan
 */
public class FileListHelper {
    private static final Log log = LogFactory.getLog(FileListHelper.class);

    public static File getFileForPath(Root r, String path) throws FileNotFoundException {
        FileRoot root = (FileRoot)r;
        path = Root.getPathPart(path);
        if(path.indexOf("..") != -1) {
            throw new IllegalArgumentException("Illegal path");
        }
        String osPath = path.replace(Root.SEPARATOR.charAt(0), File.separatorChar);

        File p = new File(osPath);
        if(p.isAbsolute()) {
            throw new IllegalArgumentException("Illegal path");
        }

        File f = new File(root.getPath(), osPath);

        //TODO CvL: file does not need to exists? use empty md then
//        if(!FGDBHelperProxy.isFGDBDirOrInsideFGDBDir(f) && !f.exists()) {
//            throw new FileNotFoundException("Path does not exist");
//        }
        return f;
    }

    public static DirContent getDirContent(FileRoot root, String fullPath) throws Exception {

        File dir = getFileForPath(root, fullPath);
        String pathPart = Root.getPathPart(fullPath);
        return getDirContent(dir, fullPath + (pathPart.equals("") ? "" : Root.SEPARATOR));
    }

    private static DirContent getDirContent(File directory, String currentPath) throws Exception {
        if (FGDBHelperProxy.isFGDBDirOrInsideFGDBDir(directory)) {
            try {
                FGDBHelperProxy.cleanerTrackObjectsInCurrentThread();
                return getFGDBDirContent(directory, currentPath);
            } finally {
                FGDBHelperProxy.cleanerReleaseAllInCurrentThread();
            }
        } else {
            return getNormalDirContent(directory, currentPath);
        }
    }

    private static DirContent getNormalDirContent(File directory, String currentPath) throws IOException {
        DirContent dc = new DirContent();

        File[] dirs = directory.listFiles((File file) -> file.isDirectory());
        File[] files = directory.listFiles((File file) -> !file.isDirectory());

        if (dirs != null) {
            for (File dir: dirs) {
                Dir newDir = new Dir();
                newDir.setName(dir.getName());
                newDir.setPath(currentPath + dir.getName());
                // can be used to attach a different dir icon to it.
                newDir.setIsFGDB(FGDBHelperProxy.isFGDBDirOrInsideFGDBDir(dir));
                dc.getDirs().add(newDir);
            }
        }

        if (files != null) {
            for (File file : files) {
                DirEntry newFile = new DirEntry();
                newFile.setName(file.getName());
                newFile.setPath(currentPath + file.getName());

                boolean isGeo = true;
                Set<String> geoFileExtensions =
                        CatalogAppConfig.getConfig().getGeoFileExtensions();
                if (!geoFileExtensions.isEmpty()
                        && !geoFileExtensions.contains(newFile.getExtension())) {
                    isGeo = false;
                }

                newFile.setIsGeo(isGeo);
                dc.getFiles().add(newFile);
            }
        }

        // add stub for directory metadata
        DirEntry newFile = new DirEntry();
        newFile.setName(".metadata");
        newFile.setPath(currentPath + "metadata");
        newFile.setIsGeo(true);
        dc.getFiles().add(newFile);

        filterOutFilesToHide(dc);

        return dc;
    }

    private static DirContent getFGDBDirContent(File directory, String currentPath) throws Exception {
        log.debug(String.format(Locale.ENGLISH, "Get FGDB content from %s (currentPath %s)", directory, currentPath));
        DirContent dc = new DirContent();

        List<Dir> dirsList =
                FGDBHelperProxy.getAllDirDatasets(directory, currentPath);
        List<DirEntry> filesList =
                FGDBHelperProxy.getAllFileDatasets(directory, currentPath);

        dc.setDirs(dirsList);
        dc.setFiles(filesList);

        return dc;
    }


    private static void filterOutFilesToHide(DirContent dc) {
        filterOutMetadataFiles(dc);
        filterOutShapeExtraFiles(dc);
    }

    private static void filterOutMetadataFiles(DirContent dc) {
        List<DirEntry> toBeIgnoredFiles = new ArrayList<>();

        dc.sort();

        List<DirEntry> filesList = dc.getFiles();

        String lastFilename = null;
        for(DirEntry file: filesList) {
            String filename = file.getName();

            if (filename.equalsIgnoreCase("metadata.xml")) {
                //metadata belonging to folder, editted via .metadata stub
                toBeIgnoredFiles.add(file);
            } else if (lastFilename == null || !filename.startsWith(lastFilename)) {
                lastFilename = filename;
            } else if (filename.length() == (lastFilename.length() + 4) && filename.endsWith(".xml")) {
                toBeIgnoredFiles.add(file);
            }
        }

        filesList.removeAll(toBeIgnoredFiles);
    }

    private static void filterOutShapeExtraFiles(DirContent dc) {
        List<String> shapeNames = new ArrayList<>();
        for(DirEntry file: dc.getFiles()) {
            if (file.getName().endsWith(Extensions.SHAPE)) {
                shapeNames.add(file.getName().substring(0, file.getName().length() - Extensions.SHAPE.length()));
            }
        }

        for(String shapeName: shapeNames) {
            List<DirEntry> toBeIgnoredFiles = new ArrayList<>();
            for(DirEntry file: dc.getFiles()) {
                if (file.getName().startsWith(shapeName) && !file.getName().endsWith(Extensions.SHAPE)) {
                    toBeIgnoredFiles.add(file);
                }
            }
            dc.getFiles().removeAll(toBeIgnoredFiles);
        }
    }
}
