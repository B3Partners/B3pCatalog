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

import nl.b3p.catalog.filetree.DirContent;
import nl.b3p.catalog.kaartenbalie.KbJDBCHelper;

/**
 *
 * @author Chris van Lith
 */
public class KBRoot extends Root {
    private String jndiDataSource;
    
    private KbJDBCHelper JDBCHelper = null;
    
    public String getJndiDataSource() {
        return jndiDataSource;
    }

    public void setJndiDataSource(String jndiDataSource) {
        this.jndiDataSource = jndiDataSource;
    }

    @Override
    public DirContent getDirContent(String fullPath) throws Exception {
        return getJDBCHelper().getDirContent(fullPath);
    }
    
    public KbJDBCHelper getJDBCHelper() {
        if(JDBCHelper == null) {
            JDBCHelper =  new KbJDBCHelper(this);
        }
        return JDBCHelper;
    }
}
