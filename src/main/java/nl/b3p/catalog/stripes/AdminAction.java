/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package nl.b3p.catalog.stripes;

import java.io.IOException;
import net.sourceforge.stripes.action.DefaultHandler;
import net.sourceforge.stripes.action.ForwardResolution;
import net.sourceforge.stripes.action.Resolution;
import net.sourceforge.stripes.action.StreamingResolution;
import nl.b3p.catalog.B3PCatalogException;
import nl.b3p.catalog.Roles;
import nl.b3p.catalog.resolution.HtmlErrorResolution;
import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.json.JSONException;

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
            if (!Roles.isAdmin(getContext().getServletContext(), getContext().getRequest())) {
                throw new B3PCatalogException("User is not an admin");
            }

            organisations = OrganisationsAction.getOrganisations();
        } catch (B3PCatalogException ex) {
            log.error("Cannot read organisations config file", ex);
            organisations = "";
        }
        return new ForwardResolution("/WEB-INF/jsp/main/organisations.jsp");
    }
    
    public Resolution saveOrganisations() {
        try {
            if (!Roles.isAdmin(getContext().getServletContext(), getContext().getRequest())) {
                throw new B3PCatalogException("User is not an admin");
            }
            log.debug("Opslaan organisaties: " + organisations);
            OrganisationsAction.setOrganisations(organisations);
            return new StreamingResolution("text/plain", "success");
        } catch (IOException | B3PCatalogException | JSONException ex) {
            final String message = "Fout bij opslaan organisaties";
            log.error(message, ex);
            return new HtmlErrorResolution(message, ex);
        }
    }

    public String getOrganisations() {
        return organisations;
    }

    public void setOrganisations(String organisations) {
        this.organisations = organisations;
    }
}
