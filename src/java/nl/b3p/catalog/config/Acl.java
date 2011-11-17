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

import java.util.Arrays;
import java.util.HashSet;
import java.util.Set;
import javax.xml.bind.annotation.XmlAttribute;
import javax.xml.bind.annotation.XmlElement;
import javax.xml.bind.annotation.XmlTransient;

/**
 *
 * @author Matthijs Laan
 */
public class Acl {
    @XmlElement(name="role")
    private Set<String> roles = new HashSet<String>();
    
    @XmlAttribute
    private AclAccess access;
    
    public Acl() {
    }
    
    public Acl(String roles, AclAccess access) {
        this.roles.addAll(Arrays.asList(roles.split("\\s")));
        this.access = access;        
    }

    @XmlTransient
    public AclAccess getAccess() {
        return access;
    }

    public void setAccess(AclAccess access) {
        this.access = access;
    }

    @XmlTransient
    public Set<String> getRoles() {
        return roles;
    }

    public void setRoles(Set<String> roles) {
        this.roles = roles;
    }
}
