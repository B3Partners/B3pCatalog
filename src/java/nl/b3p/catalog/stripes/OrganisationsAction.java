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
import org.json.JSONException;
import org.json.JSONObject;

/**
 *
 * @author Erik van de Pol
 */
public class OrganisationsAction extends DefaultAction {
    private final static Log log = LogFactory.getLog(OrganisationsAction.class);
    
    private static final String ENCODING = "UTF-8";
    
    private static final String DEFAULT_ORGANISATIONS_FILE = "organisations.json";
    
    @DefaultHandler
    public Resolution main() {
        String organisations = getOrganisations();
        
        // TODO ipv JavaScript code JSON teruggeven en dit eerst valideren
        // met org.json.JSONObject
        // In MDE niet met <script> tag maar met XHR laden (mogelijk probleem 
        // met XHR in ArcCatalog plugin?)
        
        return new StreamingResolution("text/javascript; charset=" + ENCODING, organisations);
    }
    
    public static String getOrganisations() {
        try {
            return FileUtils.readFileToString(getOrganisationsConfigFile(), ENCODING);
        } catch (Exception ex) {
            log.error("Cannot read organisations config file: " + ex.getMessage());
            
            return "organisations = {}";
        }
    }
    
    public static void setOrganisations(String organisations) {
        // XXX enorme hack
        String search = "/* DEZE REGEL NIET WIJZIGEN */ organisations = ";
        int i = organisations.lastIndexOf(search);
        if(i == -1) {
            throw new IllegalArgumentException("JavaScript syntax ongeldig: geen beginmarkering gevonden");
        }
               
        String jsonPart = organisations.substring(i + search.length());
        try {
            new JSONObject(jsonPart);
        } catch(JSONException e) {
            throw new IllegalArgumentException("JSON syntax ongeldig: " + e.getMessage());
        }
        try {
            FileUtils.writeStringToFile(getOrganisationsConfigFile(), organisations,ENCODING);
        } catch (Exception ex) {
            log.error("Cannot store organisations in config file", ex);
        }
    }
    
    private static File getOrganisationsConfigFile()  {
        CatalogAppConfig cfg = CatalogAppConfig.getConfig();
        String ojf = cfg.getOrganizationsJsonFile();
        if (ojf==null) {
            ojf = DEFAULT_ORGANISATIONS_FILE;
        }
        File f = new File(ojf);
        if(!f.isAbsolute()) {
            f = new File(cfg.getConfigFilePath(), cfg.getOrganizationsJsonFile());
        }
        return f;
    }
    
}
