/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package nl.b3p.catalog;

import javax.servlet.ServletContext;
import javax.servlet.http.HttpServletRequest;

/**
 *
 * @author Erik van de Pol
 */
public class Roles {
    public static boolean isAdmin(ServletContext context, HttpServletRequest request) {
        return request.isUserInRole(context.getInitParameter("adminRole"));
        
    }
}
