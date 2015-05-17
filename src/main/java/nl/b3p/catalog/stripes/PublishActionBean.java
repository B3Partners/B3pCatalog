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
import java.util.ArrayList;
import java.util.List;
import javax.xml.parsers.DocumentBuilder;
import javax.xml.parsers.DocumentBuilderFactory;
import net.sourceforge.stripes.action.ActionBean;
import net.sourceforge.stripes.action.ActionBeanContext;
import net.sourceforge.stripes.action.ErrorResolution;
import net.sourceforge.stripes.action.Resolution;
import net.sourceforge.stripes.action.StreamingResolution;
import net.sourceforge.stripes.action.StrictBinding;
import net.sourceforge.stripes.validation.Validate;
import nl.b3p.catalog.config.CSWServerConfig;
import nl.b3p.catalog.config.CatalogAppConfig;
import nl.b3p.catalog.resolution.HtmlResolution;
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
    
    private static final String EXPORT_TYPE_ALL = "all";
    private static final String EXPORT_TYPE_DATASETS = "datasets";
    private static final String EXPORT_TYPE_SERVICES = "services";

    @Validate(required = true, on = "publish")
    private String exportType = EXPORT_TYPE_DATASETS;
    
    @Validate
    private String cswServerName;
   
    //<editor-fold defaultstate="collapsed" desc="getters en setters">
    public ActionBeanContext getContext() {
        return context;
    }

    public void setContext(ActionBeanContext context) {
        this.context = context;
    }
    /**
     * @return the type
     */
    public String getExportType() {
        return exportType;
    }
    /**
     * @param exportType the exportType to set
     */
    public void setExportType(String exportType) {
        this.exportType = exportType;
    }
    /**
     * @return the cswServerName
     */
    public String getCswServerName() {
        return cswServerName;
    }

    /**
     * @param cswServerName the cswServerName to set
     */
    public void setCswServerName(String cswServerName) {
        this.cswServerName = cswServerName;
    }
    //</editor-fold>

    private CswClient getCswClient() {
        CSWServerConfig cfg = null;
        if (cswServerName != null && !cswServerName.isEmpty()) {
            List<CSWServerConfig> lcfgs = CatalogAppConfig.getConfig().getCswServers();
            for (CSWServerConfig lcfg : lcfgs) {
                if (cswServerName.equals(lcfg.getCswName())) {
                    cfg = lcfg;
                    break;
                }
            }
        }
        if (cfg==null) {
            cfg = CatalogAppConfig.getConfig().getDefaultCswServer();
        }
        return new CswClient(new GeoNetworkCswServer(
                cfg.getLoginUrl(),
                cfg.getUrl(),
                cfg.getUsername(),
                cfg.getPassword()
        ));
    }

    public Resolution optionsList() throws Exception {
        List<CSWServerConfig> lcfgs = CatalogAppConfig.getConfig().getCswServers();
        StringBuilder sb = new StringBuilder();
        for (CSWServerConfig lcfg : lcfgs) {
            sb.append("<option value=\"");
            sb.append(lcfg.getCswName());
            sb.append("\">");
            sb.append(lcfg.getCswName());
            sb.append("</option>");
        }
        //TODO cvl vullen select in GUI
        return new HtmlResolution(sb.toString());
    }

    public Resolution publish() throws Exception {

        Document md = getMDDocument(exportType);

        String fileIdentifier = new OutputById(null).getUUID(md.getRootElement());

        JSONObject jo = new JSONObject();
        jo.put("fileIdentifier", fileIdentifier);

        CswClient csw = getCswClient();
        if (csw==null) {
            return new ErrorResolution(404);
        }

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

    private Document getMDDocument(String exportType) throws Exception {

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

        if (EXPORT_TYPE_DATASETS.equals(exportType)) {
                    serviceMode = Boolean.FALSE;
                    datasetMode = Boolean.TRUE;
        } else if (EXPORT_TYPE_SERVICES.equals(exportType)) {
                    serviceMode = Boolean.TRUE;
                    datasetMode = Boolean.FALSE;
        } else if (EXPORT_TYPE_ALL.equals(exportType)) {
                    serviceMode = Boolean.TRUE;
                    datasetMode = Boolean.TRUE;
        }
 
        // create copy because instance in session variable should not be cleaned
        Document mdCopy = new Document((Element) md.getRootElement().clone());
        mdeXml2Html.cleanUpMetadata(mdCopy, serviceMode == null ? false : serviceMode, datasetMode == null ? false : datasetMode);
        mdeXml2Html.removeEmptyNodes(mdCopy);

        // strip off non iso parts
        if (EXPORT_TYPE_DATASETS.equals(exportType) || EXPORT_TYPE_SERVICES.equals(exportType)) {
            Element MD_Metadata = DocumentHelper.getMD_Metadata(mdCopy);
            MD_Metadata.detach();
            mdCopy = new Document(MD_Metadata);
        }
        return mdCopy;
    }

}
