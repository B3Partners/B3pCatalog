package nl.b3p.catalog.stripes;

import java.io.File;
import java.io.IOException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Map;
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
 * @author Chris van Lith
 */
public class OrganisationsAction extends DefaultAction {
    private final static Log log = LogFactory.getLog(OrganisationsAction.class);
    
    private static final String ENCODING = "UTF-8";
    
    private static final String DEFAULT_ORGANISATIONS_FILE = "organisations.json";
        
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
            
            return "{\"error\": \""+ ex.getMessage() + "\"}";
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
        // jbd: Not sure what the need for element.detach is?
        // even on document after 'legen' ALL 4 elements report that they are NOT null.
        
        if (e1 != null) {
            e1.detach();
            orgNodes.add(new Document(e1));
        }
        Element e2 = XPathHelper.selectSingleElement(mdCopy, XPathHelper.DOM_DS2_ORGANISATION_NAME);
        if (e2 != null) {
            e2.detach();
            orgNodes.add(new Document(e2));
        }
        Element e3 = XPathHelper.selectSingleElement(mdCopy, XPathHelper.DOM_DS3_ORGANISATION_NAME);
        if (e3 != null) {
            e3.detach();
            orgNodes.add(new Document(e3));
        }
        Element e4 = XPathHelper.selectSingleElement(mdCopy, XPathHelper.DOM_DS4_ORGANISATION_NAME);
        if (e4 != null) {
            e4.detach();
            orgNodes.add(new Document(e4));
        }

        JSONObject configOrgs = getOrganisationsJson();
        
        // maak map met nieuwe/aangepaste orgaisaties
        Map<String,JSONObject> checkedOrgs = new HashMap<String,JSONObject>();
        // loop over alle organisaties in metadata
        for (Document d : orgNodes) {
            Element e = XPathHelper.selectSingleElement(d, XPathHelper.ORGANISATION_NAME);
            if (e != null && !e.getTextTrim().isEmpty()) {
                // bepaal naam van organisatie
                String name = e.getTextTrim();
                JSONObject mdOrg = convertElement2Json(d);
                // bepaal of info van organisatie is aangapast
                List devis = findDeviations(mdOrg, getConfigOrganisation(configOrgs, name));
                if (devis!=null && !devis.isEmpty()) {
                    int loopnum = 1;
                    String loopname = name;
                    while (checkedOrgs.containsKey(loopname)) {
                        loopname = name.concat(Integer.toString(loopnum));
                        loopnum++;
                    }
                    checkedOrgs.put(loopname, mdOrg);
                }
            }
        }

        Iterator<String> it = checkedOrgs.keySet().iterator();
        while (it.hasNext()) {
            String name = it.next();
            JSONObject checkedOrg = checkedOrgs.get(name);
            configOrgs = mergeOrganisation(configOrgs, name, checkedOrg);
        }

        setOrganisationsJson(configOrgs);
    }

    private static List findDeviations(JSONObject o1, JSONObject o2) throws JSONException {
        ArrayList<String> deviList = new ArrayList<String>();
        if (o1 == null) {
            return null;
        } else if (o2 == null) {
            // Organisation contains values in the mde AND that organisation is NOT in the current organisations.json file.

            Iterator<?> o1it = o1.keys();
            while (o1it.hasNext()) {
                String label = (String) o1it.next();
                // contact
                if (label.equals("contacts")) {
                    JSONObject contacts1 = o1.optJSONObject(label);
                    if (contacts1 == null) {
                        // nothing to do
                    } else {                    
                        Iterator<?> contacts1it = contacts1.keys();
                        while (contacts1it.hasNext()) {
                            String sublabel = (String) contacts1it.next();
                            String value1 = contacts1.optString(sublabel); 
                            if (!value1.isEmpty() )  {
                                deviList.add(label + "_" + sublabel);
                            }
                        }
                    }

                } else {
                    // geen contact.
                    String value1 = o1.optString(label);
                    if (!value1.isEmpty()) {
                        deviList.add(label);
                    }
                }
            }
        } else {
            // o1 and o2 are both NOT null.  
            Iterator<?> o1it = o1.keys();
            while (o1it.hasNext()) {
                String label = (String) o1it.next();
                if (label.equals("contacts")) {
                    JSONObject contacts1 = o1.optJSONObject(label);
                    JSONObject contacts2 = o2.optJSONObject(label);
                    if (contacts1 == null) {
                        // nothing to do
                    } else if (contacts2 == null) {
                        // all new
                        deviList.add(label);
                    } else {
                        // check differences
                        Iterator<?> contacts1it = contacts1.keys(); 
                        while (contacts1it.hasNext()) {
                            String sublabel = (String) contacts1it.next();

                            String value1 = contacts1.optString(sublabel);
                            String value2 = contacts2.optString(sublabel);
                            if (!value1.equals(value2)) {
                                deviList.add(label + "_" + sublabel);
                            }
                        }
                    }
                // not a contact.
                } else {
                    // optString() returns empty string if in the JSON object the key does not contain a value
                    String value1 = o1.optString(label);
                    String value2 = o2.optString(label);
                    if (!value1.equals(value2) ) {
                        deviList.add(label);
                    }

                }
            }
        }
        return deviList;
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

    private static JSONObject getConfigOrganisation(JSONObject configOrgs, String mdOrgName) throws JSONException, IOException {
        if (configOrgs.has(mdOrgName)) {
            return (JSONObject) configOrgs.get(mdOrgName);
        }
        return null;
    }
    
    private static JSONObject mergeOrganisation(JSONObject configOrgs, String mdOrgName, JSONObject mdOrg) throws JSONException, IOException {
        //  check if mdOrg in configOrgs
        if (configOrgs.has(mdOrgName)) { //  if yes
            // get configOrg
            JSONObject configOrg = configOrgs.optJSONObject(mdOrgName);
            // get configContacts from configOrg
            JSONObject configContacts = configOrg.optJSONObject("contacts");
            if (configContacts == null) {
                //      or create if not present
                configContacts = new JSONObject();
            }
            //      get mdContacts from mdOrg
            JSONObject mdContacts = mdOrg.optJSONObject("contacts");
            if (mdContacts != null) {
                //      loop over mdContacts
                Iterator<?> mdContactsKeys = mdContacts.keys();
                while (mdContactsKeys.hasNext()) {
                    String mdContactName = (String) mdContactsKeys.next();
                    JSONObject mdContact = mdContacts.optJSONObject(mdContactName);
                    // add or replace mdContacts to configContacts
                    configContacts.put(mdContactName, mdContact);
                }
             }
             //      add configContacts to mdOrg
             mdOrg.put("contacts", configContacts);
        }
        // add or replace mdOrg to configOrgs
        configOrgs.put(mdOrgName, mdOrg);
        // return configOrgs
        return configOrgs;
   }
}
