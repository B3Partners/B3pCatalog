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

import java.io.IOException;
import java.sql.Connection;
import java.sql.SQLException;
import java.util.List;
import javax.naming.Context;
import javax.naming.InitialContext;
import javax.naming.NamingException;
import javax.sql.DataSource;
import nl.b3p.catalog.config.Root;
import nl.b3p.catalog.config.SDERoot;
import nl.b3p.catalog.filetree.Dir;
import nl.b3p.catalog.filetree.DirContent;
import nl.b3p.catalog.filetree.DirEntry;

/**
 *
 * @author Matthijs Laan
 */
public abstract class ArcSDEJDBCHelper {
    
    protected SDERoot root;
    
    public ArcSDEJDBCHelper(SDERoot root) {
        this.root = root;
    }
    
    protected Connection getConnection() throws NamingException, SQLException {
        Context initCtx = new InitialContext();
        DataSource ds = (DataSource)initCtx.lookup(root.getJndiDataSource());

        return ds.getConnection();        
    }
    
    protected String getTableName(String name) {
        String prefix = root.getTablePrefix();
        if(prefix == null || prefix.trim().length() == 0) {
            return name;
        } else {
            return prefix.trim() + "." + name;
        }
    }    
    public DirContent getDirContent(String fullPath) throws NamingException, SQLException {
        DirContent dc = new DirContent();
        String path = Root.getPathPart(fullPath);        
        if("".equals(path)) { 
            dc.setDirs(getFeatureDatasets(fullPath));
            dc.setFiles(getFeatureClasses(fullPath, null));
        } else {            
            dc.setFiles(getFeatureClasses(fullPath + DirContent.SEPARATOR, new ArcSDEJDBCDataset(root,path)));
        }
        return dc;
    }
    
    public ArcSDEJDBCDataset getDataset(String fullPath) {
        return new ArcSDEJDBCDataset(root, fullPath);
    }
    
    public static String getMetadata(SDERoot root, String fullPath) throws NamingException, SQLException, IOException {
        return root.getJDBCHelper().getMetadata(fullPath);
    }
    
    public String getMetadata(String fullPath) throws NamingException, SQLException, IOException {
        return getMetadata(getDataset(fullPath));
    }
    
    public abstract List<Dir> getFeatureDatasets(final String currentPath) throws NamingException, SQLException;
    public abstract List<DirEntry> getFeatureClasses(final String currentPath, final ArcSDEJDBCDataset parent) throws NamingException, SQLException;
    public abstract String getMetadata(ArcSDEJDBCDataset dataset) throws NamingException, SQLException, IOException; 
    public abstract void saveMetadata(ArcSDEJDBCDataset dataset, String metadata) throws Exception;
}
