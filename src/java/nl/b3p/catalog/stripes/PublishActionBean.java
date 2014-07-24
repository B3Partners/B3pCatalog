/*
 * Copyright (C) 2012 B3Partners B.V.
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
package nl.b3p.catalog.stripes;


import java.io.StringReader;
import javax.xml.parsers.DocumentBuilder;
import javax.xml.parsers.DocumentBuilderFactory;
import net.sourceforge.stripes.action.ActionBean;
import net.sourceforge.stripes.action.ActionBeanContext;
import net.sourceforge.stripes.action.Resolution;
import net.sourceforge.stripes.action.StreamingResolution;
import net.sourceforge.stripes.action.StrictBinding;
import net.sourceforge.stripes.validation.Validate;
import nl.b3p.catalog.config.CSWServerConfig;
import nl.b3p.catalog.config.CatalogAppConfig;
import static nl.b3p.catalog.stripes.MetadataAction.SESSION_KEY_METADATA_XML;
import nl.b3p.catalog.xml.DocumentHelper;
import nl.b3p.catalog.xml.mdeXml2Html;
import nl.b3p.csw.client.CswClient;
import nl.b3p.csw.client.InputById;
import nl.b3p.csw.client.OutputById;
import nl.b3p.csw.jaxb.csw.TransactionResponse;
import nl.b3p.csw.server.GeoNetworkCswServer;
import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.jdom.Document;
import org.jdom.Element;
import org.jdom.output.Format;
import org.jdom.output.XMLOutputter;
import org.json.JSONObject;
import org.xml.sax.InputSource;

/**
 *
 * @author Matthijs Laan
 */
@StrictBinding
public class PublishActionBean implements ActionBean {

    private final static Log log = LogFactory.getLog(PublishActionBean.class);
    private ActionBeanContext context;

    @Validate
    private String type = "dataset";
   
    //<editor-fold defaultstate="collapsed" desc="getters en setters">
    public ActionBeanContext getContext() {
        return context;
    }

    public void setContext(ActionBeanContext context) {
        this.context = context;
    }

    //</editor-fold>

    private CswClient getCswClient() {
        CSWServerConfig cfg = CatalogAppConfig.getConfig().getDefaultCswServer();
        return new CswClient(new GeoNetworkCswServer(
                cfg.getLoginUrl(),
                cfg.getUrl(),
                cfg.getUsername(),
                cfg.getPassword()
        ));
    }

    public Resolution publish() throws Exception {

        Document md = getISO19139Document();

        String fileIdentifier = new OutputById(null).getUUID(md.getRootElement());

        JSONObject jo = new JSONObject();
        jo.put("fileIdentifier", fileIdentifier);

        CswClient csw = getCswClient();

        OutputById out = csw.search(new InputById(fileIdentifier));

        boolean exists = !out.getSearchResultsW3C().isEmpty();
        jo.put("exists", exists);

        String mdString = new XMLOutputter(Format.getPrettyFormat()).outputString(md);

        DocumentBuilderFactory dbf = DocumentBuilderFactory.newInstance();
        dbf.setNamespaceAware(true);
        DocumentBuilder db = dbf.newDocumentBuilder();
        org.w3c.dom.Document doc = db.parse(new InputSource(new StringReader(mdString)));

        TransactionResponse response = exists ? csw.update(fileIdentifier, doc) : csw.insert(doc);
             
        jo.put("totalInserted", response.getValue().getTransactionSummary().getTotalInserted());
        jo.put("totalUpdated", response.getValue().getTransactionSummary().getTotalUpdated());

        return new StreamingResolution("application/json", new StringReader(jo.toString()));
    }

    private Document getISO19139Document() throws Exception {

        /* The MD_Metadata.detach() causes that when doing multiple 'publishing' actions 
         for the same file that the FileIdentifier can't be after the first publish.
         The md gets changed on Tomcat and its impossible to do multiple publish actions.
         Removing .detach is not possible because then another exeption is thrown 'duplicate objectid'
         A copy of md is created and used.
         */
        Document md = (Document) getContext().getRequest().getSession().getAttribute(SESSION_KEY_METADATA_XML);
        if (md == null) {
            throw new IllegalStateException("Geen metadatadocument geopend in deze sessie");
        }

        Boolean serviceMode = mdeXml2Html.getXSLParam("serviceMode_init");
        Boolean datasetMode = mdeXml2Html.getXSLParam("datasetMode_init");
        
        //Als zowel dataset als service aanstaan, dan bepaalt type welke versie
        //gepubliceerd gaat worden, beide mag niet.
        //TODO bij gebruiker opvragen welke type gepubliceerd moet worden, indien
        //beide beschikbaar zijn.
        if (serviceMode!=null && serviceMode.booleanValue() 
                && datasetMode!=null && datasetMode.booleanValue()) {
            if (type.equalsIgnoreCase("dataset")) {
                serviceMode = Boolean.FALSE;
            } else {
                datasetMode = Boolean.FALSE;
            }
        }

        mdeXml2Html.cleanUpMetadata(md, serviceMode == null ? false : serviceMode, datasetMode == null ? false : datasetMode);
        mdeXml2Html.removeEmptyNodes(md);

        Document mdCopy = new Document((Element) md.getRootElement().clone());
        Element MD_Metadata = DocumentHelper.getMD_Metadata(mdCopy);
        MD_Metadata.detach();
        return new Document(MD_Metadata);
    }

    /**
     * @return the type
     */
    public String getType() {
        return type;
    }

    /**
     * @param type the type to set
     */
    public void setType(String type) {
        this.type = type;
    }
}
