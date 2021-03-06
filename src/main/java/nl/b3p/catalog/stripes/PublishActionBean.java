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
import java.util.List;
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
import org.jdom2.Document;
import org.jdom2.Element;
import org.jdom2.output.DOMOutputter;
import org.jdom2.output.Format;
import org.json.JSONObject;

/**
 *
 * @author Matthijs Laan
 */
@StrictBinding
public class PublishActionBean implements ActionBean {
    
    private static final String EXPORT_TYPE_ALL = "all";
    private static final String EXPORT_TYPE_DATASETS = "datasets";
    private static final String EXPORT_TYPE_SERVICES = "services";

    private ActionBeanContext context;

    @Validate(required = true, on = "publish")
    private String exportType = EXPORT_TYPE_DATASETS;
    
    @Validate
    private String cswServerName;
   
    //<editor-fold defaultstate="collapsed" desc="getters en setters">
    @Override
    public ActionBeanContext getContext() {
        return context;
    }

    @Override
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
        lcfgs.forEach((lcfg) -> {
            sb.append("<option value=\"")
                    .append(lcfg.getCswName())
                    .append("\">")
                    .append(lcfg.getCswName())
                    .append("</option>");
        });
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

        final DOMOutputter domOut = new DOMOutputter();
        domOut.setFormat(Format.getPrettyFormat());
        org.w3c.dom.Document doc = domOut.output(md);

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

        if (null != exportType) {
            switch (exportType) {
                case EXPORT_TYPE_DATASETS:
                    serviceMode = Boolean.FALSE;
                    datasetMode = Boolean.TRUE;
                    break;
                case EXPORT_TYPE_SERVICES:
                    serviceMode = Boolean.TRUE;
                    datasetMode = Boolean.FALSE;
                    break;
                case EXPORT_TYPE_ALL:
                    serviceMode = Boolean.TRUE;
                    datasetMode = Boolean.TRUE;
                    break;
                default:
                    break;
            }
        }
 
        // create copy because instance in session variable should not be cleaned
        Document mdCopy = new Document(md.getRootElement().clone());
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
