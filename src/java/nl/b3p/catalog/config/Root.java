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
import java.util.ArrayList;
import java.util.Arrays;
import java.util.Collections;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import javax.servlet.http.HttpServletRequest;
import javax.xml.bind.annotation.XmlAttribute;
import javax.xml.bind.annotation.XmlTransient;
import nl.b3p.catalog.B3PCatalogException;
import nl.b3p.catalog.filetree.DirContent;

/**
 *
 * @author Matthijs Laan
 */
public abstract class Root {
    @XmlAttribute
    private String name;
      
    private List<Acl> acl = new ArrayList<Acl>();
    
    public Root() {
    }
    
    @XmlTransient
    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public List<Acl> getAcl() {
        return acl;
    }

    public void setAcl(List<Acl> acl) {
        this.acl = acl;
    }
        
    private List<RoleAccess> getDefaultAccessList() {
        return Arrays.asList(new RoleAccess[] {
            new RoleAccess("*", AclAccess.WRITE)
        });
    }
    
    /**
     * Geeft een List van roles met bijbehorende hoogste access level om te 
     * gebruiken met HttpServletRequest om het hoogste access level van een
     * ingelogde gebruiker te bepalen als volgt:
     * 
     * <pre>AclAccess highestAccess = AclAccess.NONE;
     * if(request.getUserPrincipal() != null) {
     *     for(RoleAccess ra: root.getRoleAccessList()) {
     *         if("*".equals(ra.getRole() || request.isUserInRole(ra.getRole()) {
     *             highestAccess = ra.getAccess();
     *             break;
     *         }
     *     } 
     * }
     * </pre>
     * 
     * @return Lijst met rollen en bijbehorend hoogste access level, hoogste
     *   access levels eerst
     */
    @XmlTransient
    public List<RoleAccess> getRoleAccessList() {
        
        if(acl.isEmpty()) {
            return getDefaultAccessList();
        }
        
        // TODO cache resultaat, invalidate cache wanneer achterliggende acl gewijzigd wordt
        
        /* maak een map met per role het hoogste access level */
        Map<String,AclAccess> m = new HashMap<String,AclAccess>();
        
        for(Acl thisAcl: acl) {
            for(String role: thisAcl.getRoles()) {
                AclAccess a = m.get(role);
                
                if(a == null || thisAcl.getAccess().getSecurityLevel() > a.getSecurityLevel()) {
                    m.put(role, thisAcl.getAccess());
                }
            }
        }
        /* maak een lijst van role->hoogste access level, met hoogste access 
         * levels eerst
         */
        List<RoleAccess> l = new ArrayList<RoleAccess>();
        for(Map.Entry<String,AclAccess> e: m.entrySet()) {
            l.add(new RoleAccess(e.getKey(), e.getValue()));
        }
        Collections.sort(l);
        return Collections.unmodifiableList(l);       
    }
       
    public boolean isRequestUserAuthorizedFor(HttpServletRequest request, AclAccess minimumAccessLevel) {

        if(minimumAccessLevel == AclAccess.NONE) {
            return true;
        }
        
        if(request.getUserPrincipal() == null) {
            return false;
        }
        
        for(RoleAccess ra: getRoleAccessList()) {
            if("*".equals(ra.getRole()) || request.isUserInRole(ra.getRole())) {
                if(ra.getAccess().getSecurityLevel() >= minimumAccessLevel.getSecurityLevel()) {
                    return true;
                }
            }
        } 
        return false;
    }
    
    public abstract DirContent getDirContent(String prefix, String path) throws IOException, B3PCatalogException;
}