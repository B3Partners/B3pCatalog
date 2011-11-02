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
import java.io.FileFilter;
import java.io.FileNotFoundException;
import java.io.IOException;
import java.util.ArrayList;
import java.util.List;
import nl.b3p.catalog.B3PCatalogException;
import nl.b3p.catalog.arcgis.FGDBHelperProxy;
import nl.b3p.catalog.config.CatalogAppConfig;
import nl.b3p.catalog.config.FileRoot;

/**
 *
 * @author Matthijs Laan
 */
public class FileListHelper {
    
    public static File getFileForPath(FileRoot root, String path) throws FileNotFoundException {
        if(path.indexOf("..") != -1) {
            throw new IllegalArgumentException("Illegal path");
        }
        String osPath = path.replace(DirContent.SEPARATOR, File.separatorChar);
        
        File p = new File(osPath);
        if(p.isAbsolute()) {
            throw new IllegalArgumentException("Illegal path");
        }
        
        File f = new File(root.getPath(), osPath);
        
        if(!FGDBHelperProxy.isFGDBDirOrInsideFGDBDir(f) && !f.exists()) {
            throw new FileNotFoundException("Path does not exist");
        }
        return f;
    }
    
    public static DirContent getDirContent(FileRoot root, String prefix, String path) throws IOException, B3PCatalogException {

        File dir = getFileForPath(root, path);
        
        return getDirContent(dir, prefix + path + (path.equals("") ? "" : DirContent.SEPARATOR));
    }
    
    private static DirContent getDirContent(File directory, String currentPath) throws IOException, B3PCatalogException {
        if (FGDBHelperProxy.isFGDBDirOrInsideFGDBDir(directory)) {
            return getFGDBDirContent(directory, currentPath);
        } else {
            return getNormalDirContent(directory, currentPath);
        }
    }

    private static DirContent getNormalDirContent(File directory, String currentPath) throws IOException {
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
                newFile.setIsGeo(CatalogAppConfig.getConfig().getGeoFileExtensions().contains(newFile.getExtension()));
                dc.getFiles().add(newFile);
            }
        }

        filterOutFilesToHide(dc);

        return dc;
    }

    private static DirContent getFGDBDirContent(File directory, String currentPath) throws IOException, B3PCatalogException {
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
        List<DirEntry> toBeIgnoredFiles = new ArrayList<DirEntry>();

        dc.sort();
        
        List<DirEntry> filesList = dc.getFiles();
        
        String lastFilename = null;
        for(DirEntry file: filesList) {
            String filename = file.getName();

            if (lastFilename == null || !filename.startsWith(lastFilename)) {
                lastFilename = filename;
            } else if (filename.length() == (lastFilename.length() + 4) && filename.endsWith(".xml")) {
                toBeIgnoredFiles.add(file);
            }
        }

        filesList.removeAll(toBeIgnoredFiles);
    }

    private static void filterOutShapeExtraFiles(DirContent dc) {
        List<String> shapeNames = new ArrayList<String>();
        for(DirEntry file: dc.getFiles()) {
            if (file.getName().endsWith(Extensions.SHAPE)) {
                shapeNames.add(file.getName().substring(0, file.getName().length() - Extensions.SHAPE.length()));
            }
        }

        for(String shapeName: shapeNames) {
            List<DirEntry> toBeIgnoredFiles = new ArrayList<DirEntry>();
            for(DirEntry file: dc.getFiles()) {
                if (file.getName().startsWith(shapeName) && !file.getName().endsWith(Extensions.SHAPE)) {
                    toBeIgnoredFiles.add(file);
                }
            }
            dc.getFiles().removeAll(toBeIgnoredFiles);
        }
    }
}
