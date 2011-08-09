/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package nl.b3p.catalog.stripes;

import net.sourceforge.stripes.action.DefaultHandler;
import net.sourceforge.stripes.action.ForwardResolution;
import net.sourceforge.stripes.action.Resolution;
import net.sourceforge.stripes.action.StreamingResolution;
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
        organisations = OrganisationsAction.getOrganisations(getContext());
        return new ForwardResolution("/WEB-INF/jsp/main/organisations.jsp");
    }
    
    public Resolution saveOrganisations() {
        OrganisationsAction.setOrganisations(getContext(), organisations);
        return new StreamingResolution("text/plain", "success");
    }

    public String getOrganisations() {
        return organisations;
    }

    public void setOrganisations(String organisations) {
        this.organisations = organisations;
    }
}
