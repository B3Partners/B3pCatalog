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
package nl.b3p.catalog.stripes;

import net.sourceforge.stripes.action.Resolution;
import nl.b3p.catalog.Roles;
import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;

/**
 *
 * @author Matthijs Laan
 */
public class AdminCheckActionBean extends DefaultAction {
    private static final Log log = LogFactory.getLog(AdminCheckActionBean.class);
    
    private boolean admin;

    public boolean isAdmin() {
        return admin;
    }

    public void setAdmin(boolean admin) {
        this.admin = admin;
    }
    
    public Resolution init() {
        admin = Roles.isAdmin(getContext().getServletContext(), getContext().getRequest());
        log.info("Checking for admin role " + getContext().getServletContext().getInitParameter("adminRole") + ": " + admin);
        return null;
    }
    
}
