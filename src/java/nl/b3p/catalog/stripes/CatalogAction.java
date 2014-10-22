/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

package nl.b3p.catalog.stripes;

import java.io.StringReader;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import javax.xml.bind.JAXBException;
import javax.xml.transform.TransformerConfigurationException;
import javax.xml.transform.TransformerException;
import javax.xml.transform.TransformerFactoryConfigurationError;
import net.sourceforge.stripes.action.ErrorResolution;
import net.sourceforge.stripes.action.ForwardResolution;
import net.sourceforge.stripes.action.Resolution;
import net.sourceforge.stripes.action.StreamingResolution;
import net.sourceforge.stripes.validation.Validate;
import nl.b3p.catalog.B3PCatalogException;
import nl.b3p.catalog.config.CSWServerConfig;
import nl.b3p.catalog.config.CatalogAppConfig;
import nl.b3p.catalog.resolution.HtmlErrorResolution;
import nl.b3p.catalog.resolution.HtmlResolution;
import nl.b3p.catalog.resolution.XmlResolution;
import nl.b3p.catalog.xml.DocumentHelper;
import nl.b3p.catalog.xml.mdeXml2Html;
import nl.b3p.csw.client.CswClient;
import nl.b3p.csw.client.CswRequestCreator;
import nl.b3p.csw.client.CswSmartRequestCreator;
import nl.b3p.csw.client.InputById;
import nl.b3p.csw.client.InputBySearch;
import nl.b3p.csw.client.Output;
import nl.b3p.csw.client.OutputById;
import nl.b3p.csw.client.OutputBySearch;
import nl.b3p.csw.client.OwsException;
import nl.b3p.csw.jaxb.csw.GetRecords;
import nl.b3p.csw.server.GeoNetworkCswServer;
import nl.b3p.csw.util.OperatesOn;
import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.jdom.Document;
import org.jdom.Element;
import org.jdom.JDOMException;
import org.jdom.Text;
import org.json.JSONArray;
import org.json.JSONObject;

/**
 *
 * @author Erik van de Pol
 */
public class CatalogAction extends DefaultAction {
    private final static Log log = LogFactory.getLog(CatalogAction.class);

    protected final static String SEARCH_RESULTS_JSP = "/WEB-INF/jsp/main/searchResults.jsp";

    @Validate(required=true, on="search")
    private String searchString;

    @Validate(required=true, on="search")
    private String searchType;
    
    @Validate(required=false)
    private String resultType;

    private List<MetadataBean> metadataList;

    @Validate(required = true, on = {"load", "loadMdAsHtml"})
    private String uuid;

    public Resolution search() {
        if (searchString == null || searchString.trim().equals(""))
            searchString = "*";

        try {
            CswClient client = getCswClient();

            GetRecords getRecords = null;
            if (searchType.equalsIgnoreCase("title")) { 
                // dit faciliteert full title search icm de SimpleAnalyzer in Lucene in Geonetwork
                getRecords = CswSmartRequestCreator.createSmartCswRequest(searchString, searchType);
            } else {
                getRecords = CswRequestCreator.createCswRequest(searchString, searchType, "", "", "", true);
            }

            OutputBySearch output = client.search(new InputBySearch(getRecords));
            //log.debug(new XMLOutputter().outputString(output.getXml()));

            metadataList = createMetadataList(output);
            
            if(this.resultType != null && this.resultType.equals("json")) {
                JSONArray resultList = new JSONArray(metadataList);
                JSONObject searchResult = new JSONObject();
                searchResult.put("success", true);
                searchResult.put("result", resultList);
                return new StreamingResolution("application/json; charset=UTF-8", searchResult.toString());
            }

            return new ForwardResolution(SEARCH_RESULTS_JSP);
        } catch (Exception e) {
            String message = "Fout bij het zoeken naar de metadata";
            log.error(message, e);
            return new HtmlErrorResolution(message, e);
        }
    }
    
    public Resolution loadMdAsHtml() {
        
        Document mdDoc;
        
        try {
            CswClient client = getCswClient();
            OutputById output = client.search(new InputById(uuid));
            //log.debug(new XMLOutputter().outputString(output.getXml()));
            
            if(output.getSearchResult() == null) {
                throw new IllegalArgumentException(String.format("Metadata document met UUID \"%s\" kon niet worden gevonden bij CSW-service", uuid));
            }

            String metadata = output.getSearchResultString();
            mdDoc = DocumentHelper.getMetadataDocument(metadata);

            Document htmlDoc = mdeXml2Html.transform(mdDoc, true);

            String d = DocumentHelper.getDocumentString(htmlDoc);
            log.debug("serverside rendered html for method loadMdAsHtml: " + d);
            StringReader sr = new StringReader(d);
            return new HtmlResolution(sr);

        } catch (Exception e) {
            String message = "Fout bij het laden van de metadata.";
            log.error(message, e);
            return new HtmlErrorResolution(message, e);
        }
    }

    public Resolution load() {
        try {
            CswClient client = getCswClient();
            OutputById output = client.search(new InputById(uuid));
            //log.debug(new XMLOutputter().outputString(output.getXml()));
            
            if(output.getSearchResult() == null) {
                throw new IllegalArgumentException(String.format("Metadata document met UUID \"%s\" kon niet worden gevonden bij CSW-service", uuid));
            }

            if(this.resultType != null && this.resultType.equals("json")) {
                JSONObject loadResult = new JSONObject();
                loadResult.put("success", true);
                loadResult.put("result", createMetadataList(output));
                return new StreamingResolution("application/json; charset=UTF-8", loadResult.toString());
            }
            
            return new XmlResolution(output.getSearchResultString());
        } catch (Exception e) {
            String message = "Fout bij het laden van de metadata.";
            log.error(message, e);
            return new HtmlErrorResolution(message, e);
        }
    }

    public Resolution export() {
        Resolution resolution = load();
        if (resolution instanceof XmlResolution) {
            // je zou hier de title kunnen extracten en die als filename kunnen includen
            String exportName = "metadata.xml";
            XmlResolution xmlResolution = (XmlResolution)resolution;
            xmlResolution.setAttachment(true);
            xmlResolution.setFilename(exportName);
        }
        return resolution;
    }
   
    private CswClient getCswClient() throws B3PCatalogException {
        CSWServerConfig cfg = CatalogAppConfig.getConfig().getDefaultCswServer();
        if (cfg==null || cfg.getCswName()==null || cfg.getCswName().isEmpty()) {
            throw new B3PCatalogException("Geen CSW server geconfigureerd!");
        }
        return new CswClient(new GeoNetworkCswServer(
                 cfg.getLoginUrl(),
                 cfg.getUrl(),
                 cfg.getUsername(),
                 cfg.getPassword()
         ));
    }

    protected List<MetadataBean> createMetadataList(Output output) throws TransformerConfigurationException, TransformerFactoryConfigurationError, TransformerException, JDOMException, JAXBException, OwsException {
        List<Element> metadataDocs = output.getSearchResults();
        List<MetadataBean> list = new ArrayList<MetadataBean>(metadataDocs.size());

        for (Element mdElem : metadataDocs) {
            MetadataBean metadataBean = new MetadataBean();

            metadataBean.setTitle(output.getTitle(mdElem));
            metadataBean.setAltTitle("");
            metadataBean.setAbstractString(output.getAbstractText(mdElem));
            metadataBean.setUuid(output.getUUID(mdElem, true));
            metadataBean.setMetadataForService(output.isMetadataForService(mdElem));
            metadataBean.setOperatesOn(output.getOperatesOnAsStringList(mdElem));
            metadataBean.setKeyWords(output.getKeyWordsAsStringList(mdElem));
            metadataBean.setBrowseGraphicFileName(output.getBrowseGraphicFileName(mdElem));
            metadataBean.setDateStamp(output.getDateStamp(mdElem));
            metadataBean.setIdentificationDate(output.getIdentificationDate(mdElem));
            metadataBean.setMetadataStandardName(output.getMetadataStandardName(mdElem));
            metadataBean.setResponsibleOrganisationName(output.getResponsibleOrganisationName(mdElem));

            list.add(metadataBean);
        }

        return list;
    }

    // placeholder for preprocessed metadata to be used in the jsp only.
    public class MetadataBean {
        private String title;
        private String altTitle;
        private String abstractString;
        private String uuid;
        private List<String> keyWords;
        private List<String> operatesOn;
        private boolean metadataForService;
        private String browseGraphicFileName;
        private String dateStamp;
        private String identificationDate;
        private String metadataStandardName;
        private String responsibleOrganisationName;

        public MetadataBean() {

        }

        public String getTitle() {
            return title;
        }

        public void setTitle(String title) {
            this.title = title;
        }

        public String getAltTitle() {
            return altTitle;
        }

        public void setAltTitle(String altTitle) {
            this.altTitle = altTitle;
        }

        public String getAbstractString() {
            return abstractString;
        }

        public void setAbstractString(String abtractString) {
            this.abstractString = abtractString;
        }

        public String getUuid() {
            return uuid;
        }

        public void setUuid(String uuid) {
            this.uuid = uuid;
        }

        /**
         * @return the keyWords
         */
        public List<String> getKeyWords() {
            return keyWords;
        }

        /**
         * @param keyWords the keyWords to set
         */
        public void setKeyWords(List<String> keyWords) {
            this.keyWords = keyWords;
        }

        /**
         * @return the operatesOn
         */
        public List<String> getOperatesOn() {
            return operatesOn;
        }

        /**
         * @param operatesOn the operatesOn to set
         */
        public void setOperatesOn(List<String> operatesOn) {
            this.operatesOn = operatesOn;
        }

        /**
         * @return the metadataForService
         */
        public boolean isoMetadataForService() {
            return metadataForService;
        }

        /**
         * @param metadataForService the metadataForService to set
         */
        public void setMetadataForService(boolean metadataForService) {
            this.metadataForService = metadataForService;
        }

        /**
         * @return the browseGraphicFileName
         */
        public String getBrowseGraphicFileName() {
            return browseGraphicFileName;
        }

        /**
         * @param browseGraphicFileName the browseGraphicFileName to set
         */
        public void setBrowseGraphicFileName(String browseGraphicFileName) {
            this.browseGraphicFileName = browseGraphicFileName;
        }

        /**
         * @return the dateStamp
         */
        public String getDateStamp() {
            return dateStamp;
        }

        /**
         * @param dateStamp the dateStamp to set
         */
        public void setDateStamp(String dateStamp) {
            this.dateStamp = dateStamp;
        }

        /**
         * @return the identificationDate
         */
        public String getIdentificationDate() {
            return identificationDate;
        }

        /**
         * @param identificationDate the identificationDate to set
         */
        public void setIdentificationDate(String identificationDate) {
            this.identificationDate = identificationDate;
        }

        /**
         * @return the metadataStandardName
         */
        public String getMetadataStandardName() {
            return metadataStandardName;
        }

        /**
         * @param metadataStandardName the metadataStandardName to set
         */
        public void setMetadataStandardName(String metadataStandardName) {
            this.metadataStandardName = metadataStandardName;
        }

        /**
         * @return the responsibleOrganisationName
         */
        public String getResponsibleOrganisationName() {
            return responsibleOrganisationName;
        }

        /**
         * @param responsibleOrganisationName the responsibleOrganisationName to set
         */
        public void setResponsibleOrganisationName(String responsibleOrganisationName) {
            this.responsibleOrganisationName = responsibleOrganisationName;
        }
    }

    public String getSearchString() {
        return searchString;
    }

    public void setSearchString(String searchString) {
        this.searchString = searchString;
    }

    public String getUuid() {
        return uuid;
    }

    public void setUuid(String uuid) {
        this.uuid = uuid;
    }

    public String getSearchType() {
        return searchType;
    }

    public void setSearchType(String searchType) {
        this.searchType = searchType;
    }
    
    public String getResultType() {
        return resultType;
    }

    public void setResultType(String resultType) {
        this.resultType = resultType;
    }

    public List<MetadataBean> getMetadataList() {
        return metadataList;
    }

    public void setMetadataList(List<MetadataBean> metadataList) {
        this.metadataList = metadataList;
    }


}
