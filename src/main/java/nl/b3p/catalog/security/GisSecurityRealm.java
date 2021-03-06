/*
 * B3P Gisviewer is an extension to Flamingo MapComponents making
 * it a complete webbased GIS viewer and configuration tool that
 * works in cooperation with B3P Kaartenbalie.
 *
 * Copyright 2006, 2007, 2008 B3Partners BV
 * 
 * This file is part of B3P Gisviewer.
 * 
 * B3P Gisviewer is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 * 
 * B3P Gisviewer is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 * 
 * You should have received a copy of the GNU General Public License
 * along with B3P Gisviewer.  If not, see <http://www.gnu.org/licenses/>.
 */
package nl.b3p.catalog.security;

import java.security.Principal;
import java.util.ArrayList;
import java.util.List;
import nl.b3p.commons.security.XmlSecurityDatabase;
import nl.b3p.commons.services.FormUtils;
import nl.b3p.wms.capabilities.ServiceProvider;
import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.securityfilter.filter.SecurityRequestWrapper;
import org.securityfilter.realm.ExternalAuthenticatedRealm;
import org.securityfilter.realm.FlexibleRealmInterface;

public class GisSecurityRealm implements FlexibleRealmInterface, ExternalAuthenticatedRealm {

    private static final Log log = LogFactory.getLog(GisSecurityRealm.class);
    private static final String FORM_USERNAME = "j_username";
    private static final String FORM_PASSWORD = "j_password";
    private static final String FORM_CODE = "j_code";
    private static final String CAPABILITIES_QUERYSTRING = "REQUEST=GetCapabilities&VERSION=1.1.1&SERVICE=WMS";

    public Principal authenticate(SecurityRequestWrapper request) {
        String username = FormUtils.nullIfEmpty(request.getParameter(FORM_USERNAME));
        String password = FormUtils.nullIfEmpty(request.getParameter(FORM_PASSWORD));
        String code = FormUtils.nullIfEmpty(request.getParameter(FORM_CODE));

        String url = createCapabilitiesURL(code);
        return authenticateHttp(url, username, password, code);
    }

    public Principal getAuthenticatedPrincipal(String username, String password) {
        return authenticate(username, password);
    }

    public boolean isUserInRole(Principal principal, String rolename) {
        if (principal == null) {
            return false;
        }
        boolean inRole = ((GisPrincipal) principal).isInRole(rolename);
        if (!inRole) {
            inRole = XmlSecurityDatabase.isUserInRole(principal.getName(), rolename);
        }
        return inRole;
    }

    public static String createCapabilitiesURL(String code) {
        String url = ConfigServlet.createPersonalKbUrl(code);
            if (url!=null){
            if (url.indexOf('?') == -1) {
                url += "?";
            }
            if (url.indexOf('?') == url.length() - 1) {
                url += CAPABILITIES_QUERYSTRING;
            } else if (url.lastIndexOf('&') == url.length() - 1) {
                url += CAPABILITIES_QUERYSTRING;
            } else {
                url += "&" + CAPABILITIES_QUERYSTRING;
            }
        }
        return url;
    }

    protected static GisPrincipal authenticateFake(String username) {

        List roles = new ArrayList();
        roles.add(ConfigServlet.GEBRUIKERS_ROL);
        roles.add(ConfigServlet.THEMABEHEERDERS_ROL);

        return new GisPrincipal(username, roles);
    }

    public static GisPrincipal authenticateHttp(String location, String username, String password, String code) {
        // Do not try to log in to Kaartenbalie
        //WMSCapabilitiesReader wmscr = new WMSCapabilitiesReader();
        ServiceProvider sp = null;
        Exception kbException=null;
        /*if (location!=null){
            try {
                sp = wmscr.getProvider(location, username, password);
            } catch (Exception ex) {
                kbException=ex;
                //log.error("Error reading GetCapabilities: " + ex.getLocalizedMessage());
            }
        }*/
        if (sp == null || sp.getAllRoles() == null || sp.getAllRoles().isEmpty()) {
            log.info("No ServiceProvider found, getting roles with XmlSecurityDatabase realm!");
            if (!XmlSecurityDatabase.booleanAuthenticate(username, password)) {
                log.warn("Can't log in with XmlSecurityDatabase realm nor with WMSurl! Wrong username/password combo?");
                if (kbException!=null){
                     log.error("Can't log in with WMS url/Kb url",kbException);
                }
                return null;
            }
        }
        if (username==null || username.length()==0) {
            username = ConfigServlet.ANONYMOUS_USER;
        }
        log.debug("login: " + username);
        return new GisPrincipal(username, password, code, sp);
    }

    @Override
    public Principal authenticate(String username, String password) {
        // Eventueel fake Principal aanmaken
        String url = createCapabilitiesURL(null);
        return authenticateHttp(url, username, password, null);
    }

    public Principal getAuthenticatedPrincipal(String username) {
        return null;
    }
}
