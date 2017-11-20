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

import java.util.Locale;

/**
 *
 * @author Matthijs Laan
 */
public class RoleAccess implements Comparable {
    private final String role;
    private final AclAccess access;

    RoleAccess(String role, AclAccess access) {
        this.role = role;
        this.access = access;
    }

    public AclAccess getAccess() {
        return access;
    }

    public String getRole() {
        return role;
    }

    @Override
    public int compareTo(Object o) {
        RoleAccess rhs = (RoleAccess)o;
        return new Integer(rhs.access.getSecurityLevel()).compareTo(access.getSecurityLevel());
    }
    
    @Override
    public String toString() {
        return String.format(Locale.ROOT, "(%s=%s)", role, access.name());
    }
}
