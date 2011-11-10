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
package nl.b3p.catalog.arcgis;

import java.util.regex.Pattern;
import nl.b3p.catalog.config.Root;
import nl.b3p.catalog.config.SDERoot;
import nl.b3p.catalog.filetree.DirContent;

/**
 *
 * @author Matthijs Laan
 */
public class ArcSDEJDBCDataset {
    private SDERoot root;
    private String containingDatasetFullName;
    private String fullName;
    
    public ArcSDEJDBCDataset(SDERoot root, String fullPath) {
        this.root = root;
        String path = Root.getPathPart(fullPath);
        String paths[] = path.split(Pattern.quote(DirContent.SEPARATOR + ""), 2);
        
        if(paths.length == 1) {
            fullName = paths[0];
        } else {
            containingDatasetFullName = paths[0];
            fullName = paths[1];
        }        
    }

    public String getOwner() {
        return fullName.substring(0,fullName.lastIndexOf('.'));
    }
    
    public String getName() {
        return fullName.substring(fullName.lastIndexOf('.')+1);
    }

    public String getContainingDataset() {
        return containingDatasetFullName.substring(containingDatasetFullName.lastIndexOf('.')+1);
    }

    public String getFullName() {
        return fullName;
    }

    public void setFullName(String fullName) {
        this.fullName = fullName;
    }

    public String getContainingDatasetFullName() {
        return containingDatasetFullName;
    }

    public void setContainingDatasetFullName(String containingDatasetFullName) {
        this.containingDatasetFullName = containingDatasetFullName;
    }

    public SDERoot getRoot() {
        return root;
    }

    public void setRoot(SDERoot root) {
        this.root = root;
    }

}
