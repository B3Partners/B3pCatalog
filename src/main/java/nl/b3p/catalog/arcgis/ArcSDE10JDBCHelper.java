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
import java.sql.Clob;
import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import java.util.Locale;
import javax.naming.NamingException;
import nl.b3p.catalog.config.Root;
import nl.b3p.catalog.config.SDERoot;
import nl.b3p.catalog.filetree.Dir;
import nl.b3p.catalog.filetree.DirEntry;
import nl.b3p.catalog.xml.DocumentHelper;
import org.apache.commons.dbutils.DbUtils;
import org.apache.commons.dbutils.QueryRunner;
import org.apache.commons.dbutils.ResultSetHandler;
import org.apache.commons.dbutils.handlers.ScalarHandler;
import org.apache.commons.io.IOUtils;
import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.jdom2.Document;
import org.jdom2.output.Format;
import org.jdom2.output.XMLOutputter;

/**
 *
 * @author Matthijs Laan
 */
public class ArcSDE10JDBCHelper extends ArcSDEJDBCHelper {
    private static final Log LOG = LogFactory.getLog(ArcSDE10JDBCHelper.class);
    protected String TABLE_ITEMS;
    protected String TABLE_ITEMRELATIONSHIPS;
    
    protected static final String TYPE_FEATURE_DATASET = "74737149-DCB5-4257-8904-B9724E32A530";
    protected static final String TYPE_FEATURE_CLASS   = "70737809-852C-4A03-9E22-2CECEA5B9BFA";
    protected static final String TYPE_RASTER          = "5ED667A3-9CA9-44A2-8029-D95BF23704B9";
    protected static final String TYPE_RASTER_2        = "C29DA988-8C3E-45F7-8B5C-18E51EE7BEB4";
        
    public ArcSDE10JDBCHelper(SDERoot root) {
        super(root);
        TABLE_ITEMS = "gdb_items";
        TABLE_ITEMRELATIONSHIPS = "gdb_itemrelationships";
    }
    
    @Override
    public List<Dir> getFeatureDatasets(final String currentPath) throws NamingException, SQLException {
        Connection c = getConnection();
        try {
            // Nested featuredatasets are not possible to create with ArcCatalog,
            // so no need to check relationships 
            String sql = "select i.objectid, i.name from " + getTableName(TABLE_ITEMS) + " i where type = ?";

            ResultSetHandler<List<Dir>> h = new ResultSetHandler<List<Dir>>() {
                @Override
                public List<Dir> handle(ResultSet rs) throws SQLException {
                    List<Dir> l = new ArrayList<>();
                    while(rs.next()) {
                        l.add(new Dir(rs.getString(2) + "", currentPath + rs.getInt(1)));
                    }                    
                    return l;
                }
            };
            LOG.debug("Zoeken naar feature data sets met SQL: " + sql + ", param: " + TYPE_FEATURE_DATASET);
            return new QueryRunner().query(c, sql, h, TYPE_FEATURE_DATASET);
        } finally {
            DbUtils.closeQuietly(c);
        }
    }

    @Override
    public List<DirEntry> getFeatureClasses(final String currentPath, ArcSDEJDBCDataset parent) throws NamingException, SQLException {
        Connection c = getConnection();
        try {
            String sql = "select i.objectid, i.name from " + getTableName(TABLE_ITEMS) + " i " + 
                      "join " + getTableName(TABLE_ITEMRELATIONSHIPS) + " r on (r.destid = i.uuid) " +
                      "join " + getTableName(TABLE_ITEMS) + " parent_i on (parent_i.uuid = r.originid) " +
                      "where i.type in (?,?,?) ";

            if(parent == null) {
                sql += "and parent_i.path = '\\'";
            } else {
                sql += "and parent_i.objectid = ?"; 
            }
            
            ResultSetHandler<List<DirEntry>> h = new ResultSetHandler<List<DirEntry>>() {
                @Override
                public List<DirEntry> handle(ResultSet rs) throws SQLException {
                    List<DirEntry> l = new ArrayList<>();
                    while(rs.next()) {
                        l.add(new DirEntry(rs.getString(2) + "", currentPath + rs.getInt(1)));
                    }                    
                    return l;
                }
            };
            if (parent == null) {
                LOG.debug(String.format(Locale.ROOT, "Zoeken voor feature classes met SQL: %s , param: [%s,%s,%s]", sql, TYPE_FEATURE_CLASS, TYPE_RASTER, TYPE_RASTER_2));
                return new QueryRunner().query(c, sql, h, TYPE_FEATURE_CLASS, TYPE_RASTER, TYPE_RASTER_2);
            } else {
                LOG.debug(String.format(Locale.ROOT, "Zoeken voor feature classes met SQL: %s , param: [%s,%s,%s,%s]", sql, TYPE_FEATURE_CLASS, TYPE_RASTER, TYPE_RASTER_2, parent.getObjectID()));
                return new QueryRunner().query(c, sql, h, TYPE_FEATURE_CLASS, TYPE_RASTER, TYPE_RASTER_2, parent.getObjectID());
            }
        } finally {
            DbUtils.closeQuietly(c);
        }
    }


    @Override
    public String getMetadata(ArcSDEJDBCDataset dataset) throws NamingException, SQLException, IOException {        
        Connection c = getConnection();
        try {
            String sql = "select documentation from " + getTableName(TABLE_ITEMS) + " where objectid = ?";
            LOG.debug(String.format(Locale.ROOT, "Zoeken naar metadata met SQL: %s , param: [%s]", sql, dataset.getObjectID()));
            Clob xml = (Clob)new QueryRunner().query(c, sql, new ScalarHandler(), dataset.getObjectID());
            if (xml == null) {
                LOG.debug("Geen metadata document gevonden.");
                return DocumentHelper.EMPTY_METADATA;
            }
            return IOUtils.toString(xml.getCharacterStream());
        } finally {
            DbUtils.closeQuietly(c);
        }        
    }

    @Override
    public void saveMetadata(ArcSDEJDBCDataset dataset, String metadata) throws Exception {
        Connection c = getConnection();
//        PreparedStatement ps = null;
        try {
            // Sloop encoding uit XML declaratie, anders geeft MSSQL error 
            // "unable to switch the encoding" op column type xml
            Document doc = DocumentHelper.getMetadataDocument(metadata);
            metadata = new XMLOutputter(Format.getPrettyFormat().setOmitEncoding(true)).outputString(doc);
            
            String sql = "update " + getTableName(TABLE_ITEMS) + " set documentation = ? where objectid = ?";
//            ps = c.prepareStatement(sql);
//            ps.setCharacterStream(1, new StringReader(metadata), metadata.length());
//            ps.setObject(2, dataset.getObjectID());
//            int rowsAffected = ps.executeUpdate();
            LOG.debug(String.format(Locale.ROOT, "Update metadata met SQL: %s , param: [%s,%s]", sql, metadata, dataset.getObjectID()));
            int rowsAffected = new QueryRunner().update(c, sql, metadata, dataset.getObjectID());
            if(rowsAffected != 1) {
                throw new Exception("Updating metadata should affect maximum one row; got rows affected count of: " + rowsAffected);
            }
        } finally {
//            DbUtils.closeQuietly(ps);
            DbUtils.closeQuietly(c);
        }         
    }
    
    @Override
    public String getAbsoluteDatasetName(ArcSDEJDBCDataset dataset) throws Exception {
        Connection c = getConnection();
        try {
            String sql = "select name from " + getTableName(TABLE_ITEMS) + " where objectid = ?";
            LOG.debug(String.format(Locale.ROOT, "Uitlezen dataset naam met SQL: %s , param: [%s]", sql, dataset.getObjectID()));
            String name = (String)new QueryRunner().query(c, sql, new ScalarHandler(), dataset.getObjectID());
            
            if(dataset.getParent() != null) {
                String parentName = (String)new QueryRunner().query(c, sql, new ScalarHandler(), dataset.getParent().getObjectID());
                name = parentName + Root.SEPARATOR + name;
            }
            return name;
        } finally {
             DbUtils.closeQuietly(c);
        }              
    }  

    @Override
    public String getName() {
        return "ArcSDE10JDBCHelper";
    }
}
