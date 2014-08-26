package nl.b3p.catalog.stripes;

import java.io.File;
import java.io.IOException;
import java.util.ArrayList;
import java.util.Iterator;
import java.util.List;
import net.sourceforge.stripes.action.DefaultHandler;
import net.sourceforge.stripes.action.Resolution;
import net.sourceforge.stripes.action.StreamingResolution;
import nl.b3p.catalog.config.CatalogAppConfig;
import nl.b3p.catalog.xml.XPathHelper;
import org.apache.commons.io.FileUtils;
import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.jdom.Document;
import org.jdom.Element;
import org.jdom.JDOMException;
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
    private static final String DEFAULT_ORGANISATIONS_FILE_PREAMBULE = 
        "\n/*  \n" +
        "Organisaties en contacten  \n" +
        "  \n" +
        "Onder elk contact kunnen dezelfde properties ingevuld worden als bij een organisatie.  \n" +
        "  \n" +
        "Template:  \n" +
        "{  \n" +
        "    \"<Naam organisatie 1>\": {  \n" +
        "        \"address\": \"<adres>\",  \n" +
        "        \"city\": \"<stad>\",  \n" +
        "        \"state\": \"<provincie>\",  \n" +
        "        \"postalCode\": \"<postcode>\",  \n" +
        "        \"country\": \"<land>\",  \n" +
        "        \"url\": \"<url>\",  \n" +
        "        \"email\": \"<email adres>\",  \n" +
        "        \"voice\": \"<telefoonnummer>\",  \n" +
        "        \"contacts\": {  \n" +
        "            \"<contact naam 1>\": {  \n" +
        "                \"email\": \"chrisvanlith@b3partners.nl\"  \n" +
        "            },  \n" +
        "            \"<contact naam 2>\": {  \n" +
        "                \"email\": \"erikvandepol@b3partners.nl\"  \n" +
        "            }  \n" +
        "        }  \n" +
        "    },  \n" +
        "    \"<Naam organisatie 2>\": {  \n" +
        "        \"address\": \"<adres>\",  \n" +
        "        \"city\": \"<stad>\",  \n" +
        "        \"state\": \"<provincie>\",  \n" +
        "        \"postalCode\": \"<postcode>\",  \n" +
        "        \"country\": \"<land>\",  \n" +
        "        \"url\": \"<url>\",  \n" +
        "        \"email\": \"<email adres>\",  \n" +
        "        \"voice\": \"<telefoonnummer>\",  \n" +
        "    }  \n" +
        "};  \n" +
        "etc...  \n" +
        "*/  \n"; 
    
    @DefaultHandler
    public Resolution main() {
        String organisations = "organisations = " + getOrganisations() + ";";
        
        // TODO ipv JavaScript code JSON teruggeven en dit eerst valideren
        // met org.json.JSONObject
        // In MDE niet met <script> tag maar met XHR laden 
        // Checked with Matthijs. Niet meer relevant is volgende commentaar: 
        // (mogelijk probleem met XHR in ArcCatalog plugin?)
        
        return new StreamingResolution("text/javascript; charset=" + ENCODING, organisations);
    }

    public Resolution json() {
        String organisations = getOrganisations();
        return new StreamingResolution("text/plain; charset=" + ENCODING, organisations);
    }
    
    public static JSONObject getOrganisationsJson() throws IOException, JSONException {
        String jsonFileContents = FileUtils.readFileToString(getOrganisationsConfigFile(), ENCODING);
        return new JSONObject(jsonFileContents);
    }
    
    public static String getOrganisations() {
        try {
            JSONObject jsonObj = getOrganisationsJson();
            return jsonObj.toString(4); // prety print it.
                    //+ DEFAULT_ORGANISATIONS_FILE_PREAMBULE; 
            
         } catch (Exception ex) {
            log.error("Cannot read organisations config file: " + ex.getMessage());
            
            return "organisations = {}";
        }
    }
    
    public static void setOrganisations (String organisations) throws IOException, JSONException {
        setOrganisationsJson (new JSONObject(organisations));
    }
       
    public static void setOrganisationsJson (JSONObject organisations) throws IOException, JSONException {
            // This validates the json object as well.
            String OrganisationsString = 
                    organisations.toString(4); // prety print it.
                    //+ DEFAULT_ORGANISATIONS_FILE_PREAMBULE;
            
            FileUtils.writeStringToFile(getOrganisationsConfigFile(), OrganisationsString, ENCODING);
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
    
    public static void saveOrganisations(Document md) throws JDOMException, JSONException, IOException {
        
        Document mdCopy = new Document((Element) md.getRootElement().clone());
        List<Document> orgNodes = new ArrayList<Document>();
        Element e1 = XPathHelper.selectSingleElement(mdCopy, XPathHelper.DOM_DS1_ORGANISATION_NAME);
        e1.detach();
        orgNodes.add(new Document(e1));
        Element e2 = XPathHelper.selectSingleElement(mdCopy, XPathHelper.DOM_DS2_ORGANISATION_NAME);
        e2.detach();
        orgNodes.add(new Document(e2));
        Element e3 = XPathHelper.selectSingleElement(mdCopy, XPathHelper.DOM_DS3_ORGANISATION_NAME);
        e3.detach();
        orgNodes.add(new Document(e3));
        Element e4 = XPathHelper.selectSingleElement(mdCopy, XPathHelper.DOM_DS4_ORGANISATION_NAME);
        e4.detach();
        orgNodes.add(new Document(e4));

        JSONObject configOrgs = getOrganisationsJson();
        
        for (Document d : orgNodes) {
            Element e = XPathHelper.selectSingleElement(d, XPathHelper.ORGANISATION_NAME);
            if (e != null && !e.getTextTrim().isEmpty()) {
                String name = e.getTextTrim();
                JSONObject mdOrg = convertElement2Json(d);
                configOrgs = mergeOrganisation(configOrgs, name, mdOrg);
            }
        }
        
        setOrganisationsJson(configOrgs);
    }
     
    private static JSONObject convertElement2Json(Document d) throws JDOMException, JSONException {
        JSONObject orgJson = new JSONObject();
        // belong to organisation
        Element e = XPathHelper.selectSingleElement(d, XPathHelper.VOICE);
        if (e != null) {
            orgJson.putOpt("voice", e.getTextTrim());
        }
        e = XPathHelper.selectSingleElement(d, XPathHelper.URL);
        if (e != null) {
            orgJson.putOpt("url", e.getTextTrim());
        }
        e = XPathHelper.selectSingleElement(d, XPathHelper.ADDRESS);
        if (e != null) {
            orgJson.putOpt("address", e.getTextTrim());
        }
        e = XPathHelper.selectSingleElement(d, XPathHelper.CITY);
        if (e != null) {
            orgJson.putOpt("city", e.getTextTrim());
        }
        e = XPathHelper.selectSingleElement(d, XPathHelper.STATE);
        if (e != null) {
            orgJson.putOpt("state", e.getTextTrim());
        }
        e = XPathHelper.selectSingleElement(d, XPathHelper.POSTAL_CODE);
        if (e != null) {
            orgJson.putOpt("postalCode", e.getTextTrim());
        }
        e = XPathHelper.selectSingleElement(d, XPathHelper.COUNTRY);
        if (e != null) {
            orgJson.putOpt("country", e.getTextTrim());
        }
        // if individual name is empty, email belongs to organisation, otherwise to contact
        e = XPathHelper.selectSingleElement(d, XPathHelper.EMAIL);
        String email = null;
        if (e != null) {
            email = e.getTextTrim();
        }
        // belong to contact
        e = XPathHelper.selectSingleElement(d, XPathHelper.INDIVIDUAL_NAME);
        if (e != null && !e.getTextTrim().isEmpty() && email!=null) {
            JSONObject contactJson = new JSONObject();
            JSONObject emailJson = new JSONObject();
            emailJson.putOpt("email", email);
            contactJson.putOpt(e.getTextTrim(), emailJson);
            orgJson.putOpt("contacts", contactJson);
        } else {
            orgJson.putOpt("email", email);
        }
        
        return orgJson;
    }

    private static JSONObject mergeOrganisation(JSONObject configOrgs, String mdOrgName, JSONObject mdOrg) throws JSONException, IOException {
        //  check if mdOrg in configOrgs
        if (configOrgs.has(mdOrgName)) { //  if yes
            //      get configOrg
            JSONObject configOrg = (JSONObject) configOrgs.get(mdOrgName);
            //      remove configOrg from configOrgs
            configOrgs.remove(mdOrgName);
            //      get mdContacts from mdOrg
            JSONObject mdContacts = (JSONObject) mdOrg.optJSONObject("contacts");
            if (mdContacts != null) {
                //      get configContacts from configOrg
                JSONObject configContacts = (JSONObject) configOrg.optJSONObject("contacts");
                //      remove "contacts"
                configOrg.remove("contacts");
                //      loop over mdContacts
                Iterator<?> mdContactsKeys = mdContacts.keys();
                while (mdContactsKeys.hasNext()) {
                    String mdContactName = (String) mdContactsKeys.next();
                    JSONObject mdContact = (JSONObject) mdContacts.get(mdContactName);
                    //          check if mdContact in configContacts
                    if (configContacts.has(mdContactName)) { //  if yes
                        //              remove configContact from configContacts
                        configContacts.remove(mdContactName);
                    }
                    //              add mdContacts to configContacts
                    configContacts.put(mdContactName, mdContact);
                }
                //      add configContacts to configOrg
                configOrg.put("contacts", configContacts);
            }
            //      add configOrg to configOrgs
            configOrgs.put(mdOrgName, configOrg);
        } else { //  if no
            //      add mdOrg to configOrgs
            configOrgs.put(mdOrgName, mdOrg);
        }
        // return configOrgs
        return configOrgs;
   }
}
