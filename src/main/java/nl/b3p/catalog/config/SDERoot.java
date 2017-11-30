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
package nl.b3p.catalog.config;

import javax.xml.bind.annotation.XmlAttribute;
import javax.xml.bind.annotation.XmlTransient;
import nl.b3p.catalog.arcgis.ArcSDE10JDBCHelper;
import nl.b3p.catalog.arcgis.ArcSDE10OracleHelper;
import nl.b3p.catalog.arcgis.ArcSDE9xJDBCHelper;
import nl.b3p.catalog.arcgis.ArcSDEHelperProxy;
import nl.b3p.catalog.arcgis.ArcSDEJDBCHelper;
import nl.b3p.catalog.filetree.DirContent;
import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;

/**
 *
 * @author Matthijs Laan
 */
public class SDERoot extends Root {
    private static final Log log = LogFactory.getLog(SDERoot.class);
    
    public static final String SCHEMA_VERSION_9X = "9.x";
    public static final String SCHEMA_VERSION_10 = "10";
    
    private String jndiDataSource;
    
    private String arcobjectsConnection;
    
    @XmlAttribute
    private String tablePrefix;
    
    @XmlAttribute
    private String schemaVersion = SCHEMA_VERSION_9X;
    
    private ArcSDEJDBCHelper JDBCHelper = null;
    
    public String getJndiDataSource() {
        return jndiDataSource;
    }

    public void setJndiDataSource(String jndiDataSource) {
        this.jndiDataSource = jndiDataSource;
    }

    public String getArcobjectsConnection() {
        return arcobjectsConnection;
    }

    public void setArcobjectsConnection(String arcobjectsConnection) {
        this.arcobjectsConnection = arcobjectsConnection;
    }

    @XmlTransient
    public String getTablePrefix() {
        return tablePrefix;
    }

    public void setTablePrefix(String tablePrefix) {
        this.tablePrefix = tablePrefix;
    }

    @XmlTransient
    public String getSchemaVersion() {
        return schemaVersion;
    }

    public void setSchemaVersion(String schemaVersion) {
        this.schemaVersion = schemaVersion;
    }

    @Override
    public DirContent getDirContent(String fullPath) throws Exception {
        return ArcSDEHelperProxy.getDirContent(this, fullPath);
    }
    
    public ArcSDEJDBCHelper getJDBCHelper() {
        if(JDBCHelper == null) {
            JDBCHelper =  SCHEMA_VERSION_9X.equals(schemaVersion) 
                    ? new ArcSDE9xJDBCHelper(this)
                    : new ArcSDE10JDBCHelper(this);
            if (JDBCHelper instanceof ArcSDE10JDBCHelper &&
                ((ArcSDE10JDBCHelper)JDBCHelper).isOracle() ) {
                JDBCHelper =  new ArcSDE10OracleHelper(this);
            }
        }
        log.debug("gevonden JDBC helper implementatie: " + JDBCHelper.getName());
        return JDBCHelper;
    }
}
