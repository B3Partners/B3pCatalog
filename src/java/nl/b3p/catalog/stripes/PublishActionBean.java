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
import net.sourceforge.stripes.action.*;
import net.sourceforge.stripes.validation.Validate;
import nl.b3p.catalog.config.CSWServerConfig;
import nl.b3p.catalog.config.CatalogAppConfig;
import nl.b3p.catalog.xml.DocumentHelper;
import nl.b3p.csw.client.CswClient;
import nl.b3p.csw.client.InputById;
import nl.b3p.csw.client.OutputById;
import nl.b3p.csw.jaxb.csw.TransactionResponse;
import nl.b3p.csw.server.GeoNetworkCswServer;
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
    private ActionBeanContext context;

    @Validate
    private String metadata;
    
    //<editor-fold defaultstate="collapsed" desc="getters en setters">
    public ActionBeanContext getContext() {
        return context;
    }
    
    public void setContext(ActionBeanContext context) {
        this.context = context;
    }
    
    public String getMetadata() {
        return metadata;
    }
    
    public void setMetadata(String metadata) {
        this.metadata = metadata;
    }
    //</editor-fold>
    
    private CswClient getCswClient() {
        CSWServerConfig cfg = CatalogAppConfig.getConfig().getCswServer();
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
        Document md = (Document)getContext().getRequest().getSession().getAttribute(MetadataAction.SESSION_KEY_METADATA_XML);            
        Element MD_Metadata = DocumentHelper.getMD_Metadata(md);

        MD_Metadata.detach();
        return new Document(MD_Metadata);        
    }
}
