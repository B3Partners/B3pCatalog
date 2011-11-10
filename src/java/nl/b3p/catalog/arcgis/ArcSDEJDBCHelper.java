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

import java.io.ByteArrayInputStream;
import java.io.IOException;
import java.sql.Blob;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import javax.naming.NamingException;
import nl.b3p.catalog.config.Root;
import nl.b3p.catalog.config.SDERoot;
import nl.b3p.catalog.filetree.Dir;
import nl.b3p.catalog.filetree.DirContent;
import nl.b3p.catalog.filetree.DirEntry;
import nl.b3p.catalog.xml.DocumentHelper;
import org.apache.commons.io.IOUtils;

/**
 *
 * @author Matthijs Laan
 */
public class ArcSDEJDBCHelper {
    private static final String ENCODING = "UTF-8";
    
    public static DirContent getDirContent(SDERoot root, String fullPath) throws NamingException, SQLException {
        DirContent dc = new DirContent();
        String path = Root.getPathPart(fullPath);        
        if("".equals(path)) { 
            dc.setDirs(getFeatureDatasets(root, fullPath));
            dc.setFiles(getFeatureClasses(root, fullPath, null));
        } else {
            dc.setFiles(getFeatureClasses(root, fullPath + DirContent.SEPARATOR, path));
        }
        return dc;
    }
    
    public static List<Dir> getFeatureDatasets(SDERoot root, String currentPath) throws NamingException, SQLException {
    
        List<Dir> l = new ArrayList<Dir>();
        
        Connection c = root.openJDBCConnection();
        try {
            ResultSet rs = c.prepareStatement("select Owner,Name from gdb_featuredataset").executeQuery();
            while(rs.next()) {
                String owner = rs.getString(1);
                String name = rs.getString(2);
                l.add(new Dir(name, currentPath + owner + "." + name));
            }
            rs.close();
            
            return l;
        } finally {
            c.close();
        }
    }
    
    public static List<DirEntry> getFeatureClasses(SDERoot root, String currentPath, String containingDatasetName) throws NamingException, SQLException {
    
        List<DirEntry> l = new ArrayList<DirEntry>();
        
        Connection c = root.openJDBCConnection();
        try {
            String sql ="select oc.Owner,oc.Name from gdb_objectclasses oc ";
            if(containingDatasetName == null) {
                sql += "where DatasetID is null or DatasetID not in (select ID from gdb_featuredataset)";
            } else {
                sql += "join gdb_featuredataset ds on (ds.ID = oc.DatasetID) where ds.Name = ?";
            }
            PreparedStatement s = c.prepareStatement(sql);
            if(containingDatasetName != null) {
                s.setString(1, containingDatasetName.substring(containingDatasetName.lastIndexOf('.')+1));
            }
            ResultSet rs = s.executeQuery();
            while(rs.next()) {
                String owner = rs.getString(1);
                String name = rs.getString(2);
                l.add(new DirEntry(name, currentPath + owner + "." + name));
            }
            rs.close();
            s.close();      
            
            return l;        
        } finally {
            c.close();
        }

    }    

    static ArcSDEJDBCDataset getDataset(SDERoot root, String path) {
        return new ArcSDEJDBCDataset(root, path);
    }

    static String getMetadata(ArcSDEJDBCDataset dataset) throws NamingException, SQLException, IOException {        
        Connection c = dataset.getRoot().openJDBCConnection();
        try {
            String sql ="select xml from gdb_usermetadata where name = ? and owner = ?";
            PreparedStatement s = c.prepareStatement(sql);
            s.setString(1, dataset.getName());
            s.setString(2, dataset.getOwner());
            ResultSet rs = s.executeQuery();
            String xml = DocumentHelper.EMPTY_METADATA;
            if(rs.next()) {
                xml = IOUtils.toString(rs.getBinaryStream(1), ENCODING);
            }
            rs.close();
            s.close();
            return xml;                       
        } finally {
            c.close();
        }
        
    }

    static String getMetadata(SDERoot root, String path) throws NamingException, SQLException, IOException {
        return getMetadata(getDataset(root, path));
    }

    static void saveMetadata(ArcSDEJDBCDataset dataset, String metadata) throws Exception {
        Connection c = dataset.getRoot().openJDBCConnection();
        try {
            c.setAutoCommit(false);
            
            String sql = "update gdb_usermetadata set xml = ? where name = ? and owner = ?";
            PreparedStatement s = c.prepareStatement(sql);
            byte[] xml = metadata.getBytes(ENCODING);
            s.setBinaryStream(1, new ByteArrayInputStream(xml), xml.length);
            s.setString(2, dataset.getName());
            s.setString(3, dataset.getOwner());
            int rowsAffected = s.executeUpdate();
            if(rowsAffected != 1) {
                throw new Exception("Updating metadata should affect one row; got rows affected count of " + rowsAffected);
            }
            s.close();
            c.commit();
        } catch(Exception e) {
            c.rollback();
            throw e;
        } finally {
            c.close();
        }        
    }
}
