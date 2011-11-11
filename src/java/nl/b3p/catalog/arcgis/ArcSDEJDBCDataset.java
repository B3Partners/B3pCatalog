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
    private ArcSDEJDBCDataset parent;
    private String fullName;
    
    private String databaseName;
    private String owner;
    private String name;
    
    public ArcSDEJDBCDataset(SDERoot root, String fullPath) {
        this.root = root;
        String path = Root.getPathPart(fullPath);
        String paths[] = path.split(Pattern.quote(DirContent.SEPARATOR + ""), 2);
        
        fullName = paths[0];
        String[] nameParts = fullName.split(Pattern.quote("."));
        if(nameParts.length == 2) {
            owner = nameParts[0];
            name = nameParts[1];
        } else if(nameParts.length == 3) {
            databaseName = nameParts[0];
            owner = nameParts[1];
            name = nameParts[2];
        } else {
            throw new IllegalStateException("Full dataset name \"" + fullName + "\" must contain one or two dots");
        }    
        
        if(paths.length > 1) {
            parent = new ArcSDEJDBCDataset(root, paths[1]);
        }        
    }

    public String getFullName() {
        return fullName;
    }

    public String getDatabaseName() {
        return databaseName;
    }

    public String getName() {
        return name;
    }

    public String getOwner() {
        return owner;
    }

    static String constructFullName(String databaseName, String owner, String name) {
        if(databaseName == null) {
            return owner + "." + name;
        } else {
            return databaseName + "." + owner + "." + name;
        }
    }    
    
    public ArcSDEJDBCDataset getParent() {
        return parent;
    }

    public SDERoot getRoot() {
        return root;
    }

    public void setRoot(SDERoot root) {
        this.root = root;
    }

}
