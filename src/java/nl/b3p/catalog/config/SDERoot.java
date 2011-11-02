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

import java.io.IOException;
import nl.b3p.catalog.B3PCatalogException;
import nl.b3p.catalog.arcgis.ArcSDEHelperProxy;
import nl.b3p.catalog.filetree.DirContent;

/**
 *
 * @author Matthijs Laan
 */
public class SDERoot extends Root {
    
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
    public DirContent getDirContent(String prefix, String path) throws IOException, B3PCatalogException {
        return ArcSDEHelperProxy.getDirContent(this, prefix, path);
    }
}
