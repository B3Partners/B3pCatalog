/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package nl.b3p.catalog.stripes;

import java.io.File;
import net.sourceforge.stripes.action.ActionBeanContext;
import net.sourceforge.stripes.action.DefaultHandler;
import net.sourceforge.stripes.action.Resolution;
import net.sourceforge.stripes.action.StreamingResolution;
import nl.b3p.catalog.config.CatalogAppConfig;
import org.apache.commons.io.FileUtils;
import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;

/**
 *
 * @author Erik van de Pol
 */
public class OrganisationsAction extends DefaultAction {
    private final static Log log = LogFactory.getLog(OrganisationsAction.class);
    
    @DefaultHandler
    public Resolution main() {
        String organisations = getOrganisations(getContext());
        
        // TODO ipv JavaScript code JSON teruggeven en dit eerst valideren
        // met org.json.JSONObject
        // In MDE niet met <script> tag maar met XHR laden (mogelijk probleem 
        // met XHR in ArcCatalog plugin?)
        
        return new StreamingResolution("text/javascript", organisations);
    }
    
    public static String getOrganisations(ActionBeanContext context) {
        try {
            return FileUtils.readFileToString(getOrganisationsConfigFile(context), "UTF-8");
        } catch (Exception ex) {
            log.error("Cannot read organisations config file: " + ex.getMessage());
            
            return "organisations = {}";
        }
    }
    
    public static void setOrganisations(ActionBeanContext context, String organisations) {
        try {
            FileUtils.writeStringToFile(getOrganisationsConfigFile(context), organisations, "utf-8");
        } catch (Exception ex) {
            log.error("Cannot store organisations in config file", ex);
        }
    }
    
    protected static File getOrganisationsConfigFile(ActionBeanContext context) {
        CatalogAppConfig cfg = CatalogAppConfig.getConfig();
        File f = new File(cfg.getOrganizationsJsonFile());
        if(!f.isAbsolute()) {
            f = new File(cfg.getConfigFilePath(), cfg.getOrganizationsJsonFile());
        }
        return f;
    }
}
