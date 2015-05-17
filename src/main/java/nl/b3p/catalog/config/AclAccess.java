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

import javax.xml.bind.annotation.XmlEnum;
import javax.xml.bind.annotation.XmlEnumValue;

/**
 *
 * @author Matthijs Laan
 */
@XmlEnum(String.class)
public enum AclAccess {
    @XmlEnumValue("write") WRITE(4), 
    @XmlEnumValue("add") ADD(3), 
    @XmlEnumValue("comment") COMMENT(2), 
    @XmlEnumValue("read") READ(1), 
    @XmlEnumValue("none") NONE(0);    
    
    private int securityLevel;
    
    AclAccess(int securityLevel) {
        this.securityLevel = securityLevel;
    }
    
    public int getSecurityLevel() {
        return securityLevel;
    }        
}
