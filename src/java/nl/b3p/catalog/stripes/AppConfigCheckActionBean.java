/*
 * Copyright (C) 2012 B3Partners B.V.
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
package nl.b3p.catalog.stripes;

import net.sourceforge.stripes.action.Resolution;
import nl.b3p.catalog.config.CatalogAppConfig;

/**
 *
 * @author Matthijs Laan
 */
public class AppConfigCheckActionBean extends DefaultAction {
    
    private CatalogAppConfig config;

    public CatalogAppConfig getConfig() {
        return config;
    }

    public void setConfig(CatalogAppConfig config) {
        this.config = config;
    }
    
    public Resolution init() {
        config = CatalogAppConfig.getConfig();
        return null;
    }    
    
    public boolean isNoWritableRoots() {
        return config.isNoWritableRoots(getContext().getRequest());
    }
}