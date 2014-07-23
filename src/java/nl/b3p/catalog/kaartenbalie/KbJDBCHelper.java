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
package nl.b3p.catalog.kaartenbalie;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import java.util.regex.Pattern;
import javax.naming.Context;
import javax.naming.InitialContext;
import javax.naming.NamingException;
import javax.sql.DataSource;
import nl.b3p.catalog.config.KBRoot;
import nl.b3p.catalog.config.Root;
import nl.b3p.catalog.filetree.Dir;
import nl.b3p.catalog.filetree.DirContent;
import nl.b3p.catalog.filetree.DirEntry;
import nl.b3p.catalog.xml.DocumentHelper;
import org.apache.commons.dbutils.DbUtils;
import org.apache.commons.dbutils.QueryRunner;
import org.apache.commons.dbutils.ResultSetHandler;
import org.apache.commons.dbutils.handlers.ScalarHandler;
import org.jdom.Document;
import org.jdom.output.Format;
import org.jdom.output.XMLOutputter;

/**
 *
 * @author Chris van Lith
 */
public class KbJDBCHelper {
    
    protected KBRoot root;
    
    public KbJDBCHelper(KBRoot root) {
        this.root = root;
    }
    
    protected Connection getConnection() throws NamingException, SQLException {
        Context initCtx = new InitialContext();
        DataSource ds = (DataSource)initCtx.lookup(root.getJndiDataSource());

        return ds.getConnection();        
    }
    
    protected String getTableName(String name) {
            return name;
    } 
    
    public DirContent getDirContent(String fullPath) throws Exception {
        DirContent dc = new DirContent();
        String path = Root.getPathPart(fullPath);
        if ("".equals(path)) {
            List<Dir> dirs = new ArrayList<Dir>();
            Dir d = new Dir("WMS", fullPath + "WMS");
            dirs.add(d);
            d = new Dir("WFS", fullPath + "WFS");
            dirs.add(d);
            dc.setDirs(dirs);
        } else if ("WMS".equals(path)) {
            dc.setDirs(getFeatureDatasets(fullPath + Root.SEPARATOR, "WMS"));
        } else if ("WFS".equals(path)) {
            dc.setDirs(getFeatureDatasets(fullPath + Root.SEPARATOR, "WFS"));
        } else {
            dc.setFiles(getFeatureClasses(fullPath + Root.SEPARATOR));
        }
        
        return dc;
    }
    
    public List<Dir> getFeatureDatasets(final String currentPath, String type) throws Exception {
        Connection c = getConnection();
        try {
            String sql = "";
            if ("WMS".equals(type)) {
                sql = "select id, abbr from service_provider ";
            } else if ("WFS".equals(type)) {
                sql = "select id, abbr from wfs_service_provider ";
            } else {
                List<Dir> dirs = new ArrayList<Dir>();
                Dir d = new Dir("", currentPath +  "?");
                dirs.add(d);
                return dirs;
            }
 
            ResultSetHandler<List<Dir>> h = new ResultSetHandler<List<Dir>>() {
                public List<Dir> handle(ResultSet rs) throws SQLException {
                    List<Dir> dirs = new ArrayList<Dir>();
                    while(rs.next()) {
                        Dir d = new Dir(rs.getString(2), currentPath +  rs.getInt(1));
                        dirs.add(d);
                    }                    
                    return dirs;
                }
            };
            return new QueryRunner().query(c, sql, h);
        } finally {
            DbUtils.closeQuietly(c);
        }
    }
    
    public List<DirEntry> getFeatureClasses(final String fullPath) throws Exception {
        String path = Root.getPathPart(fullPath);
        // path = WMS/391
        String paths[] = path.split(Pattern.quote(Root.SEPARATOR + ""));
        String service = "";
        String sp_id = "";
        if(paths.length == 2) {
           service = paths[0];
           sp_id = paths[1];
        } else {
            List<DirEntry> l = new ArrayList<DirEntry>();
            DirEntry de = new DirEntry("", fullPath + "?");
            l.add(de);
            return l;
        }
        
        Connection c = getConnection();
        try {
            String sql = "";
            if ("WMS".equals(service)) {
                sql = "select layer.id, layer.name, service_provider.abbr from layer " +
                    "join service_provider on (layer.service_provider = service_provider.id) " +
                    "where layer.name is not null and service_provider.id = ? ";
            } else if ("WFS".equals(service)) {
                sql = "select wfs_layer.id, wfs_layer.name, wfs_service_provider.abbr from wfs_layer " +
                    "join wfs_service_provider on (wfs_layer.wfs_service_provider = wfs_service_provider.id) " +
                    "where wfs_layer.name is not null and wfs_service_provider.id = ? ";
            } else {
                List<DirEntry> l = new ArrayList<DirEntry>();
                DirEntry de = new DirEntry("", fullPath + "?");
                l.add(de);
                return l;
            }
 
            ResultSetHandler<List<DirEntry>> h = new ResultSetHandler<List<DirEntry>>() {
                public List<DirEntry> handle(ResultSet rs) throws SQLException {
                    List<DirEntry> l = new ArrayList<DirEntry>();
                    while(rs.next()) {
                        DirEntry de = new DirEntry(rs.getString(2), fullPath + rs.getInt(1));
                        de.setIsGeo(true);
                        l.add(de);
                    }                    
                    return l;
                }
            };
            return new QueryRunner().query(c, sql, h, new Integer(sp_id));
        } finally {
            DbUtils.closeQuietly(c);
        }
    }
    
    private String getMetadataOrNull(String currentPath) throws Exception { 
        String path = Root.getPathPart(currentPath);
        // path = WMS/391/6356
        String paths[] = path.split(Pattern.quote(Root.SEPARATOR + ""));
        String service = "";
        String sp_id = "";
        String layer_id = "";
        if(paths.length == 3) {
           service = paths[0];
           sp_id = paths[1];
           layer_id = paths[2];
        } else {
            return null;
        }
        
        Connection c = getConnection();
        try {
            if ("WMS".equals(service)) {
                String sql = "select metadata from layer_metadata where layer = ?";
                return (String) new QueryRunner().query(c, sql, new ScalarHandler(), new Integer(layer_id));
            } else if ("WFS".equals(service)) {
                // nothing for now
                String sql = "select metadata from wfs_layer_metadata where layer = ?";
                throw new Exception ("WFS get metadata not supported!");
//                return (String) new QueryRunner().query(c, sql, new ScalarHandler(), new Integer(layer_id));
            }
        } finally {
            DbUtils.closeQuietly(c);
        }
        return null;
    }

    public String getMetadata(String currentPath) throws Exception {        
        String xml = getMetadataOrNull(currentPath);
        if(xml == null) {
            return DocumentHelper.EMPTY_METADATA;
        }
        return xml;
    }

    public void saveMetadata(String currentPath, String metadata) throws Exception {
        String path = Root.getPathPart(currentPath);
        // path = WMS/391/6356
        String paths[] = path.split(Pattern.quote(Root.SEPARATOR + ""));
        String service = "";
        String sp_id = "";
        String layer_id = "";
        if(paths.length == 3) {
           service = paths[0];
           sp_id = paths[1];
           layer_id = paths[2];
        } else {
            throw new Exception("Invalid save path!");
        }
        
        String oldXml = getMetadataOrNull(currentPath);
        if (oldXml==null) {
            insertMetadata(service, layer_id, metadata);
        } else {
            updateMetadata(service, layer_id, metadata);
        }
    }
    
    private void updateMetadata(String service, String layer_id, String metadata) throws Exception {
        Connection c = getConnection();
        PreparedStatement ps = null;
        try {
            
            // Sloop encoding uit XML declaratie, anders geeft MSSQL error 
            // "unable to switch the encoding" op column type xml
            
            Document doc = DocumentHelper.getMetadataDocument(metadata);
            metadata = new XMLOutputter(Format.getPrettyFormat().setOmitEncoding(true)).outputString(doc);
            
            String sql = "";
            if ("WMS".equals(service)) {
                sql = "update layer_metadata set metadata = ? where layer = ?";
            } else if ("WFS".equals(service)) {
                // nothing for now
                sql = "update wfs_layer_metadata set metadata = ? where layer = ?";
                throw new Exception ("WFS metadata update not supported!");
            }

            ps = c.prepareStatement(sql);
            ps.setString(1, metadata);
            ps.setInt(2, new Integer(layer_id));
            int rowsAffected = ps.executeUpdate();
            if(rowsAffected != 1) {
                throw new Exception("Updating metadata should affect maximum one row; got rows affected count of " + rowsAffected);
            }
        } finally {
            DbUtils.closeQuietly(ps);
            DbUtils.closeQuietly(c);
        }         
    }
    
    private void insertMetadata(String service, String layer_id, String metadata) throws Exception {
        Connection c = getConnection();
        PreparedStatement ps = null;
        try {
            
            // Sloop encoding uit XML declaratie, anders geeft MSSQL error 
            // "unable to switch the encoding" op column type xml
            
            Document doc = DocumentHelper.getMetadataDocument(metadata);
            metadata = new XMLOutputter(Format.getPrettyFormat().setOmitEncoding(true)).outputString(doc);
            
            String sql = "";
            if ("WMS".equals(service)) {
                sql = "insert into layer_metadata (layer, metadata) values (?, ?) ";
            } else if ("WFS".equals(service)) {
                // nothing for now
                sql = "insert into wfs_layer_metadata (layer, metadata) values (?, ?) ";
                throw new Exception ("WFS metadata insert not supported!");
            }

            ps = c.prepareStatement(sql);
            ps.setString(2, metadata);
            ps.setInt(1, new Integer(layer_id));
            int rowsAffected = ps.executeUpdate();
            if(rowsAffected != 1) {
                throw new Exception("Inserting metadata should affect maximum one row; got rows affected count of " + rowsAffected);
            }
        } finally {
            DbUtils.closeQuietly(ps);
            DbUtils.closeQuietly(c);
        }         
    }
    
    public String syncMetadata(String fullPath, String metadata) throws Exception {
       String path = Root.getPathPart(fullPath);
        // path = WMS/391/6356
        String paths[] = path.split(Pattern.quote(Root.SEPARATOR + ""));
        String service = "";
        String sp_id = "";
        String layer_id = "";
        if(paths.length == 3) {
           service = paths[0];
           sp_id = paths[1];
           layer_id = paths[2];
        } else {
            throw new Exception("Invalid sync path!");
        }
        // nothing to synchronise for now
        // later kb url and other stuff may be added
        return metadata;
    }

    
}

