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

import java.sql.Connection;
import java.sql.SQLException;
import javax.naming.Context;
import javax.naming.InitialContext;
import javax.naming.NamingException;
import javax.sql.DataSource;
import nl.b3p.catalog.arcgis.ArcSDEHelperProxy;
import nl.b3p.catalog.filetree.DirContent;
import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;

/**
 *
 * @author Matthijs Laan
 */
public class SDERoot extends Root {
    private static final Log log = LogFactory.getLog(SDERoot.class);
    
    private String jndiDataSource;
    
    private String arcobjectsConnection;

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

    @Override
    public DirContent getDirContent(String fullPath) throws Exception {
        return ArcSDEHelperProxy.getDirContent(this, fullPath);
    }
    
    public Connection openJDBCConnection() throws NamingException, SQLException {
        Context initCtx = new InitialContext();
        DataSource ds = (DataSource)initCtx.lookup(getJndiDataSource());

        return ds.getConnection();        
    }
}
