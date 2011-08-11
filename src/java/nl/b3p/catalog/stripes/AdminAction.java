/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package nl.b3p.catalog.stripes;

import net.sourceforge.stripes.action.DefaultHandler;
import net.sourceforge.stripes.action.ForwardResolution;
import net.sourceforge.stripes.action.Resolution;
import net.sourceforge.stripes.action.StreamingResolution;
import nl.b3p.catalog.B3PCatalogException;
import nl.b3p.catalog.Roles;
import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;

/**
 *
 * @author Erik van de Pol
 */
public class AdminAction extends DefaultAction {
    private final static Log log = LogFactory.getLog(AdminAction.class);
    
    private String organisations;
    
    @DefaultHandler
    public Resolution loadOrganisations() {
        try {
            if (!getContext().getRequest().isUserInRole(Roles.ADMIN))
                throw new B3PCatalogException("User is not an admin");
            organisations = OrganisationsAction.getOrganisations(getContext());
        } catch (Exception ex) {
            log.error("Cannot read organisations config file", ex);
            organisations = "";
        }
        return new ForwardResolution("/WEB-INF/jsp/main/organisations.jsp");
    }
    
    public Resolution saveOrganisations() {
        try {
            if (!getContext().getRequest().isUserInRole(Roles.ADMIN))
                throw new B3PCatalogException("User is not an admin");
            OrganisationsAction.setOrganisations(getContext(), organisations);
            return new StreamingResolution("text/plain", "success");
        } catch (Exception ex) {
            log.error("Cannot read organisations config file", ex);
            return new StreamingResolution("text/plain", "fail");
        }
    }

    public String getOrganisations() {
        return organisations;
    }

    public void setOrganisations(String organisations) {
        this.organisations = organisations;
    }
}