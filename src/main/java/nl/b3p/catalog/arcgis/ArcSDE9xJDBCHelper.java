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

import com.esri.arcgis.geodatabase.esriDatasetType;
import com.esri.arcgis.geodatabase.esriFeatureType;
import java.io.ByteArrayInputStream;
import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.Arrays;
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

/**
 *
 * @author Matthijs Laan
 */
public class ArcSDE9xJDBCHelper extends ArcSDEJDBCHelper {

    private static final Log LOG = LogFactory.getLog(ArcSDE9xJDBCHelper.class);
    private static final String ENCODING = "UTF-8";

    private static final String TABLE_FEATUREDATASET = "gdb_featuredataset";
    private static final String TABLE_OBJECTCLASSES = "gdb_objectclasses";
    private static final String TABLE_USERMETADATA = "gdb_usermetadata";
    private static final String TABLE_FEATURECLASSES = "gdb_featureclasses";
    private static final String TABLE_RASTERCATALOGS = "gdb_rastercatalogs";

    public ArcSDE9xJDBCHelper(SDERoot root) {
        super(root);
    }

    @Override
    public List<Dir> getFeatureDatasets(final String currentPath) throws NamingException, SQLException {
        Connection c = getConnection();
        try {
            final String sql = "select databasename, owner, name from " + getTableName(TABLE_FEATUREDATASET);
            LOG.debug("Zoeken naar feature data sets met SQL: " + sql);
            return new QueryRunner().query(c, sql, new ResultSetHandler<List<Dir>>() {
                @Override
                public List<Dir> handle(ResultSet rs) throws SQLException {
                    List<Dir> l = new ArrayList<>();
                    while (rs.next()) {
                        String fullName = ArcSDEJDBCDataset.constructFullName(rs.getString(1), rs.getString(2), rs.getString(3));
                        l.add(new Dir(fullName, currentPath + fullName));
                    }
                    return l;
                }
            });
        } finally {
            DbUtils.closeQuietly(c);
        }
    }

    private static String databaseNameSQL(ArcSDEJDBCDataset dataset) {
        return databaseNameSQL(dataset, null);
    }

    private static String databaseNameSQL(ArcSDEJDBCDataset dataset, String alias) {
        alias = alias != null ? alias + "." : "";
        if (dataset.getDatabaseName() != null) {
            return " and " + alias + "databasename = ?";
        } else {
            return " and " + alias + "databasename is null";
        }
    }

    @Override
    public List<DirEntry> getFeatureClasses(final String currentPath, final ArcSDEJDBCDataset parent) throws NamingException, SQLException {

        Connection c = getConnection();
        try {
            ResultSetHandler<List<DirEntry>> h = new ResultSetHandler<List<DirEntry>>() {
                public List<DirEntry> handle(ResultSet rs) throws SQLException {
                    List<DirEntry> l = new ArrayList<DirEntry>();
                    while (rs.next()) {
                        String fullName = ArcSDEJDBCDataset.constructFullName(rs.getString(1), rs.getString(2), rs.getString(3));
                        l.add(new DirEntry(fullName, currentPath + fullName));
                    }
                    return l;
                }
            };

            String sql = "select oc.databasename, oc.owner, oc.name from " + getTableName(TABLE_OBJECTCLASSES) + " oc ";
            if (parent == null) {
                sql += "where datasetid is null or datasetid not in (select id from " + getTableName(TABLE_FEATUREDATASET) + ")";
            } else {
                sql += "join " + getTableName(TABLE_FEATUREDATASET) + " ds on (ds.id = oc.datasetid) where ds.owner = ? and ds.name = ?";
                sql += databaseNameSQL(parent, "ds");
            }

            List<DirEntry> l;
            if (parent != null) {
                if (parent.getDatabaseName() != null) {
                    LOG.debug(String.format(Locale.ROOT, "Opzoeken feature classes met SQL: %s, param: [%s,%s,%s]", sql, parent.getOwner(), parent.getName(), parent.getDatabaseName()));
                    l = new QueryRunner().query(c, sql, h, parent.getOwner(), parent.getName(), parent.getDatabaseName());
                } else {
                    LOG.debug(String.format(Locale.ROOT, "Opzoeken feature classes met SQL: %s, param: [%s,%s]", sql, parent.getOwner(), parent.getName()));
                    l = new QueryRunner().query(c, sql, h, parent.getOwner(), parent.getName());
                }
            } else {
                LOG.debug(String.format(Locale.ROOT, "Opzoeken feature classes met SQL: %s", sql));
                l = new QueryRunner().query(c, sql, h);
            }

            return l;
        } finally {
            DbUtils.closeQuietly(c);
        }
    }

    @Override
    public String getMetadata(ArcSDEJDBCDataset dataset) throws NamingException, SQLException, IOException {
        Connection c = getConnection();
        try {
            String sql = "select xml from " + getTableName(TABLE_USERMETADATA) + " where name = ? and owner = ?";
            sql += databaseNameSQL(dataset);

            ResultSetHandler<String> h = new ResultSetHandler<String>() {
                @Override
                public String handle(ResultSet rs) throws SQLException {
                    String xml = DocumentHelper.EMPTY_METADATA;
                    if (rs.next()) {
                        try {
                            xml = IOUtils.toString(rs.getBinaryStream(1), ENCODING);
                        } catch (IOException ex) {
                            throw new RuntimeException(ex);
                        }
                    }
                    return xml;
                }
            };
            if (dataset.getDatabaseName() != null) {
                LOG.debug(String.format(Locale.ROOT, "Opzoeken metatada met SQL: %s, param: [%s,%s,%s]", sql, dataset.getName(), dataset.getOwner(), dataset.getDatabaseName()));
                return new QueryRunner().query(c, sql, h, dataset.getName(), dataset.getOwner(), dataset.getDatabaseName());
            } else {
                LOG.debug(String.format(Locale.ROOT, "Opzoeken metatada met SQL: %s, param: [%s,%s]", sql, dataset.getName(), dataset.getOwner()));
                return new QueryRunner().query(c, sql, h, dataset.getName(), dataset.getOwner());
            }
        } finally {
            DbUtils.closeQuietly(c);
        }

    }

    @Override
    public void saveMetadata(ArcSDEJDBCDataset dataset, String metadata) throws Exception {
        Connection c = getConnection();
        PreparedStatement ps = null;
        try {
            c.setAutoCommit(false);

            // gebruik geen DbUtils; setBinaryStream() werkt niet met setObject()
            // welke DbUtils gebruikt
            String sql = "update " + getTableName(TABLE_USERMETADATA) + " set xml = ? where name = ? and owner = ?";
            sql += databaseNameSQL(dataset);
            ps = c.prepareStatement(sql);
            byte[] xml = metadata.getBytes(ENCODING);
            ps.setBinaryStream(1, new ByteArrayInputStream(xml), xml.length);
            ps.setString(2, dataset.getName());
            ps.setString(3, dataset.getOwner());
            if (dataset.getDatabaseName() != null) {
                ps.setString(4, dataset.getDatabaseName());
            }
            LOG.debug(String.format(Locale.ROOT, "Opslaan metadata met SQL: %s, params:[%s,%s,%s]", sql, "binary XML", dataset.getName(), dataset.getOwner()));
            int rowsAffected = ps.executeUpdate();
            ps.close();
            ps = null;

            if (rowsAffected > 1) {
                throw new Exception("Updating metadata should affect maximum one row; got rows affected count of " + rowsAffected);
            }

            if (rowsAffected == 0) {
                // try to insert new row

                QueryRunner runner = new QueryRunner();

                // determine highest id
                Object id = runner.query(c, "select coalesce(max(id)+1,1) from " + getTableName(TABLE_USERMETADATA), new ScalarHandler());

                Integer datasetType = determineDatasetType(c, dataset);

                // weer setBinaryStream nodig
                sql = "insert into " + getTableName(TABLE_USERMETADATA) + " (id, databasename, owner, name, datasettype, xml) values(?,?,?,?,?,?)";
                ps = c.prepareStatement(sql);
                ps.setObject(1, id);
                ps.setObject(2, dataset.getDatabaseName());
                ps.setString(3, dataset.getOwner());
                ps.setString(4, dataset.getName());
                ps.setObject(5, datasetType);
                ps.setBinaryStream(6, new ByteArrayInputStream(xml), xml.length);
                LOG.debug(String.format(Locale.ROOT, "Opslaan metadata met SQL: %s, params:[%s,%s,%s,%s,%s,%s]",
                        sql, id, dataset.getDatabaseName(), dataset.getOwner(), dataset.getName(), datasetType, "binary XML"));
                ps.executeUpdate();
                ps.close();
                ps = null;
            }

            DbUtils.commitAndClose(c);
        } catch (Exception e) {
            DbUtils.rollbackAndCloseQuietly(c);
            throw e;
        } finally {
            DbUtils.closeQuietly(ps);
        }
    }

    @Override
    public String getAbsoluteDatasetName(ArcSDEJDBCDataset dataset) throws Exception {
        String name = dataset.getFullName();
        if (dataset.getParent() != null) {
            name = dataset.getParent().getFullName() + Root.SEPARATOR + name;
        }
        return name;
    }

    private Integer determineDatasetType(Connection c, ArcSDEJDBCDataset dataset) throws Exception {
        // determine dataset type (esriDatasetType) required for new row
        // in GDB_USERMETADATA.
        // I guess there is a dataset type for each OBJECTCLASSES.CLSID 
        // value. Don't hardcode those here but make some effort try to find 
        // rows in tables for feature datasets, feature classes and raster 
        // catalogs

        // will not work for all datasets
        QueryRunner runner = new QueryRunner();

        Integer datasetType = null;

        Object[] datasetParams = dataset.getDatabaseName() != null
                ? new Object[]{dataset.getOwner(), dataset.getName(), dataset.getDatabaseName()}
                : new Object[]{dataset.getOwner(), dataset.getName()};

        // is it a feature dataset?
        String sql = "select 1 from " + getTableName(TABLE_FEATUREDATASET) + " where owner = ? and name = ?" + databaseNameSQL(dataset);
        LOG.debug(String.format(Locale.ROOT, "Bepaal dataset type met SQL: %s, params:[%s]", sql, Arrays.toString(datasetParams)));
        Object isDataset = runner.query(c, sql, new ScalarHandler(), datasetParams);

        if (isDataset != null) {
            return esriDatasetType.esriDTFeatureDataset;
        }

        // check the feature type
        sql = "select fc.FeatureType from " + getTableName(TABLE_OBJECTCLASSES) + " oc "
                + "join " + getTableName(TABLE_FEATURECLASSES) + " fc on (fc.ObjectClassId = oc.ID) "
                + "where oc.Owner = ? and oc.Name = ?" + databaseNameSQL(dataset, "oc");
        LOG.debug(String.format(Locale.ROOT, "Bepaal featureType met SQL: %s, params:[%s]", sql, Arrays.toString(datasetParams)));
        Integer featureType = (Integer) runner.query(c, sql, new ScalarHandler(), datasetParams);

        if (featureType == null) {
            throw new Exception("Cannot find row in " + TABLE_FEATURECLASSES + " table for dataset " + dataset.getFullName());
        }

        if (featureType == esriFeatureType.esriFTSimple) {
            // XXX maybe other feature types beside esriFTSimple are feature classes as well?
            datasetType = esriDatasetType.esriDTFeatureClass;
        } else if (featureType == esriFeatureType.esriFTRasterCatalogItem) {

            sql = "select rc.isRasterDataset from " + getTableName(TABLE_RASTERCATALOGS) + " rc "
                    + "join " + getTableName(TABLE_OBJECTCLASSES) + " oc on (rc.ObjectClassID = oc.ID) "
                    + "where oc.Owner = ? and oc.Name = ?" + databaseNameSQL(dataset, "oc");
            LOG.debug(String.format(Locale.ROOT, "Bepaal featureType met SQL: %s, params:[%s]", sql, Arrays.toString(datasetParams)));
            Integer isRasterDataset = (Integer) runner.query(c, sql, new ScalarHandler(), datasetParams);

            if (isRasterDataset == null) {
                throw new Exception("Cannot find row in " + TABLE_RASTERCATALOGS + " table for dataset " + dataset.getFullName());
            }

            datasetType = isRasterDataset == 1 ? esriDatasetType.esriDTRasterDataset : esriDatasetType.esriDTRasterCatalog;
        } else {
            // give up
            throw new Exception("Geen dataset type kunnen achterhalen voor feature type " + featureType + " van dataset " + dataset.getFullName());
        }
        return datasetType;
    }

    @Override
    public String getName() {
        return "ArcSDE9xJDBCHelper";
    }
}
