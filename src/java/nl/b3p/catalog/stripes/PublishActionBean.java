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

import com.esri.arcgis.geodatabase.esriDatasetType;
import com.thoughtworks.xstream.XStream;
import java.io.StringReader;
import java.io.StringWriter;
import javax.xml.parsers.DocumentBuilder;
import javax.xml.parsers.DocumentBuilderFactory;
import javax.xml.transform.Transformer;
import javax.xml.transform.TransformerFactory;
import javax.xml.transform.dom.DOMResult;
import javax.xml.transform.dom.DOMSource;
import javax.xml.transform.stax.StAXSource;
import javax.xml.transform.stream.StreamResult;
import net.sourceforge.stripes.action.*;
import net.sourceforge.stripes.validation.Validate;
import nl.b3p.catalog.arcgis.FGDBHelper;
import nl.b3p.catalog.config.CSWServerConfig;
import nl.b3p.catalog.config.CatalogAppConfig;
import static nl.b3p.catalog.stripes.MetadataAction.SESSION_KEY_METADATA_XML;
import nl.b3p.catalog.xml.DocumentHelper;
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
import org.w3c.dom.Node;
import org.xml.sax.InputSource;

/**
 *
 * @author Matthijs Laan
 */
@StrictBinding
public class PublishActionBean implements ActionBean {

    private ActionBeanContext context;

    // wolverine
    private final static Log log = LogFactory.getLog(PublishActionBean.class);

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

    // wolverine. For debugging.
    XStream xstream = new XStream();

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

        //log.debug("Method publish. At START. contents key SESSION_KEY_METADATA_XML:" + xstream.toXML((Document) getContext().getRequest().getSession().getAttribute(SESSION_KEY_METADATA_XML)));

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
        log.debug("GeoNetworks response is:" + xstream.toXML(response));
        
        jo.put("totalInserted", response.getValue().getTransactionSummary().getTotalInserted());
        jo.put("totalUpdated", response.getValue().getTransactionSummary().getTotalUpdated());

        //log.debug("Method publish. At END contents key SESSION_KEY_METADATA_XML:" + xstream.toXML((Document) getContext().getRequest().getSession().getAttribute(SESSION_KEY_METADATA_XML)));
        return new StreamingResolution("application/json", new StringReader(jo.toString()));
    }

    private Document getISO19139Document() throws Exception {

        Document md = (Document) getContext().getRequest().getSession().getAttribute(MetadataAction.SESSION_KEY_METADATA_XML);
        //Document mdBackup = (Document) getContext().getRequest().getSession().getAttribute(MetadataAction.SESSION_KEY_METADATA_XML);

        //log.debug("In method getISO19139Documentm md: (wolverine) " + xstream.toXML(md));
        //log.debug("In method getISO19139Documentm mdBackup: " + xstream.toXML(mdBackup));

        // This seems to work, as in the fileIdentifier gets successfully extracted later
        // on which means no data is lost. TODO: Check for any side effects !!
        Document mdCopy = new Document((Element) md.getRootElement().clone());
        //Element MD_Metadata = DocumentHelper.getMD_Metadata(md);
        Element MD_Metadata = DocumentHelper.getMD_Metadata(mdCopy);

//        
//        TransformerFactory tf = TransformerFactory.newInstance();
//        Transformer transformer = tf.newTransformer();
//        StringWriter sw = new StringWriter();
//        //transformer.transform(new StAXSource(xer), new StreamResult(sw));
//        transformer.transform(new DOMSource((Node) md.getRootElement()), new StreamResult(sw));
//       
        
//        
//        Document mdCopy = new Document();
//        TransformerFactory tfactory = TransformerFactory.newInstance();
//        Transformer tx = tfactory.newTransformer();
//        DOMSource source = new DOMSource(md);
//        DOMResult result = new DOMResult();
//        tx.transform(source, result);
//        
        
        //mdCopy=  (Document) result.getNode();
        //log.debug("In method getISO19139Documentm mdCopy:  " + xstream.toXML(mdCopy));
        MD_Metadata.detach();
        // The detach causes that when doing multiple 'publishing' for the same 
        // file that the FileIdentifier can't be found for the seconds time.
        // removing .detach not possible because then another exeption is thrown 'duplicate objectid'
        // Storing the Document with the original content of SESSION_KEY_METADATA_XML.

       //getContext().getRequest().getSession().setAttribute(SESSION_KEY_METADATA_XML, mdBackup);
       // log.debug("In method getISO19139Documentm mdBackup: " + xstream.toXML(mdCopy));
       // log.debug("In method getISO19139Documentm MD_Metadata to return:" + xstream.toXML(MD_Metadata));
        return new Document(MD_Metadata);
    }
}
