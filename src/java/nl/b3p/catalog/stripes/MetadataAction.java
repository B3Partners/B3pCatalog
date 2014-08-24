package nl.b3p.catalog.stripes;

import com.thoughtworks.xstream.XStream; // TODO remove when going live and also change Netbeans properties
import java.io.BufferedOutputStream;
import java.io.File;
import java.io.IOException;
import java.io.OutputStream;
import java.io.StringReader;
import java.text.DateFormat;
import java.text.SimpleDateFormat;
import java.util.Arrays;
import java.util.Date;
import java.util.HashMap;
import java.util.Iterator;
import java.util.Map;
import java.util.logging.Level;
import java.util.logging.Logger;
import javax.xml.transform.TransformerException;
import net.sourceforge.stripes.action.FileBean;
import net.sourceforge.stripes.action.ForwardResolution;
import net.sourceforge.stripes.action.Resolution;
import net.sourceforge.stripes.action.StreamingResolution;
import net.sourceforge.stripes.validation.Validate;
import nl.b3p.catalog.B3PCatalogException;
import nl.b3p.catalog.arcgis.ArcGISSynchronizer;
import nl.b3p.catalog.arcgis.ArcObjectsSynchronizerForker;
import nl.b3p.catalog.arcgis.ArcObjectsSynchronizerMain;
import nl.b3p.catalog.arcgis.ArcSDEHelperProxy;
import nl.b3p.catalog.arcgis.ArcSDEJDBCDataset;
import nl.b3p.catalog.arcgis.DatasetHelperProxy;
import nl.b3p.catalog.arcgis.FGDBHelperProxy;
import nl.b3p.catalog.arcgis.Shapefiles;
import nl.b3p.catalog.config.AclAccess;
import nl.b3p.catalog.config.ArcObjectsConfig;
import nl.b3p.catalog.config.CatalogAppConfig;
import nl.b3p.catalog.config.Root;
import nl.b3p.catalog.filetree.Extensions;
import nl.b3p.catalog.filetree.FileListHelper;
import nl.b3p.catalog.kaartenbalie.KbJDBCHelperProxy;
import nl.b3p.catalog.resolution.HtmlErrorResolution;
import nl.b3p.catalog.resolution.HtmlResolution;
import nl.b3p.catalog.xml.DocumentHelper;
import nl.b3p.catalog.xml.NCMLSynchronizer;
import nl.b3p.catalog.xml.Names;
import nl.b3p.catalog.xml.Namespaces;
import nl.b3p.catalog.xml.ShapefileSynchronizer;
import nl.b3p.catalog.xml.XPathHelper;
import nl.b3p.catalog.xml.mdeXml2Html; // wolverine. Make this cleaner.
import static nl.b3p.catalog.xml.mdeXml2Html.getXSLParam;
import org.apache.commons.io.FileUtils;
import org.apache.commons.lang.StringUtils;
import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.jdom.Document;
import org.jdom.Element;
import org.jdom.JDOMException;
import org.jdom.input.SAXBuilder;
import org.jdom.output.Format;
import org.jdom.output.XMLOutputter;
import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;


public class MetadataAction extends DefaultAction {
    
   XStream xstream = new XStream();

    private final static Log log = LogFactory.getLog(MetadataAction.class);

    private static final String FILE_MODE = "file";
    private static final String SDE_MODE = "sde";
    private static final String LOCAL_MODE = "local";
    private static final String KB_MODE = "kaartenbalie";
    
    private static final String EXPORT_TYPE_ALL = "all";
    private static final String EXPORT_TYPE_DATASETS = "datasets";
    private static final String EXPORT_TYPE_SERVICES = "services";

    // Fields in DS1, Ds2, Ds3 to check for. 
    public final static String ADDRESS = "address";
    public final static String CITY = "city";
    public final static String STATE = "state";
    public final static String POSTCALCODE = "postalCode";
    public final static String COUNTRY = "country";
    public final static String URL = "url";
    public final static String EMAIL = "email";
    public final static String VOICE = "voice";
    public final static String CONTACTS = "contacts";

    public static final String SESSION_KEY_METADATA_XML = MetadataAction.class.getName() + ".METADATA_XML";
    private final static DateFormat DATETIME_FORMAT = new SimpleDateFormat("yyyy-MM-dd'T'HH:mm:ss");

    /* XXX niet nodig omdat objecten van verschillende types toch niet dezelfde
     * naam mogen hebben...
     */
    private static final int esriDTFeatureClass = 5; /* esriDatasetType */

    @Validate(required = true, on = {"!importMD", "!updateXml", "!updateElementsAndGetXml", "!resetXml"})
    private String path;

    @Validate(required = true, on = {"!importMD", "!updateXml", "!updateElementsAndGetXml", "!resetXml"})
    private String mode;

    @Validate(required = true, on = {"save"})
    private String metadata;

    @Validate(required = true, on = "postComment")
    private String comment;

    @Validate(required = true, on = "export")
    private String exportType = EXPORT_TYPE_ALL;

    @Validate
    private FileBean importXml;

    @Validate
    private String synchronizeData;

    @Validate
    private String username;

    /* JSON with changes to be made to metadata XML. [{path: 'xpath here', attrName: 'attribute (if applicable)', newValue: 'val'}, ...] */
    @Validate(on = "updateXml")
    private String elementChanges;

    /* JSON with info about requested section addition or deletion. */
    @Validate(on = "updateXml")
    private String sectionChange;
    
    @Validate
    private Boolean viewMode = null;

    private Root root;
    private AclAccess rootAccess;
    private Map<String, String> extraHeaders = new HashMap<String, String>();
    
    

    public void determineRoot() throws B3PCatalogException {
        
        if (LOCAL_MODE.equals(mode)) {

            // When using the Java applet for selecting a file the access rights for a file 
            // can't be determined. Forcing it to WRITE, which in effect means the metadata 
            // can be edited.
            rootAccess = AclAccess.WRITE;  
            extraHeaders.put("X-MDE-Access", "WRITE");
            if (viewMode==null) {
                viewMode = Boolean.FALSE;
            }
            
        } else if (path!=null && !path.isEmpty()){

            // access can only be assessed when a path is present
            // without path there is no writing or reading so no check
            root = Root.getRootForPath(path, getContext().getRequest(), AclAccess.READ);
            rootAccess = root.getRequestUserHighestAccessLevel(getContext().getRequest());
            if (viewMode==null || !viewMode.booleanValue()) {
                viewMode = rootAccess == null || rootAccess.getSecurityLevel() < AclAccess.WRITE.getSecurityLevel();
            }
            extraHeaders.put("X-MDE-Access", rootAccess.name());

        } else {
            
            viewMode = Boolean.TRUE;
            
        }
    }
    
    protected final static String VIEW_METADATA_JSP = "/WEB-INF/jsp/main/mdview.jsp";    
    public Resolution view() {
             return new ForwardResolution(VIEW_METADATA_JSP);
    }
        
    /**
     * loads metadata from source
     * preprocesses metadata to hold all elements
     * adds date and uuid when required to metadata
     * saves metadata on session
     * transforms metadata to html fragment
     * @return transformed html fragment
     */
    public Resolution loadMdAsHtml() {

        // Store corresponding (preprocessed) xml doc in session under SESSION_KEY_METADATA_XML
        // when loading md as html. subsequent changes in html are mirrored in this xml doc
        Document md = null;

        try {

            determineRoot(); // select edit or view mode.
            
            md = loadXmlFromSource(md);

            md = preprocessXml(md);
            
            //datestamp and uuid added when empty
            md = addDateUUID(md);

            getContext().getRequest().getSession().setAttribute(SESSION_KEY_METADATA_XML, md);

            String html = createHtmlFragment(md);
            return new HtmlResolution(new StringReader(html), extraHeaders);

        } catch (Exception e) {
            getContext().getRequest().getSession().removeAttribute(SESSION_KEY_METADATA_XML);
            String message = "Kan geen " + mode + " metadata openen van lokatie " + path;
            log.error(message, e);
            return new HtmlErrorResolution(message, e);
        }
    }

   /**
     * removes metadata from session
     * creates new empty metadata
     * preprocesses metadata to hold all elements
     * adds date and uuid when required to metadata
     * saves metadata on session
     * transforms metadata to html fragment
     * @return transformed html fragment
     */
    public Resolution resetXml() throws Exception {

        try {
            // reset xml only possible when write access
            viewMode = false;
 
            getContext().getRequest().getSession().removeAttribute(SESSION_KEY_METADATA_XML);
            //create default md doc
            Document md = DocumentHelper.getMetadataDocument("");

            md = preprocessXml(md);
            
            //datestamp and uuid added when empty
            md = addDateUUID(md);

            getContext().getRequest().getSession().setAttribute(SESSION_KEY_METADATA_XML, md);

            String html = createHtmlFragment(md);
            return new HtmlResolution(new StringReader(html), extraHeaders);
            
        } catch (Exception e) {
            String message = "Fout bij reset document";
            log.error(message, e);
            return new HtmlErrorResolution(message, e);
        }
    }

   /**
     * loads metadata from session
     * applies clientside element en section changes to metadata
     * preprocesses metadata to hold all elements
     * synchronises between elements of metadata if configured
     * saves metadata on session
     * transforms metadata to html fragment
     * @return transformed html fragment
     */
    public Resolution updateXml() throws Exception {

        try {
            // update xml only possible when write access
            viewMode = false;
            
            Document md = (Document) getContext().getRequest().getSession().getAttribute(SESSION_KEY_METADATA_XML);
            if (md == null) {
                throw new IllegalStateException("Geen metadatadocument geopend in deze sessie");
            }
            
            md = applyChangesXml(md, true);

            md = preprocessXml(md);

            md = syncBetweenElements(md);

            getContext().getRequest().getSession().setAttribute(SESSION_KEY_METADATA_XML, md);

            String html = createHtmlFragment(md);
            return new HtmlResolution(new StringReader(html), extraHeaders);
            
        } catch (Exception e) {
            String message = "Fout bij toepassen wijzigingen op XML document: " + elementChanges + " " + sectionChange;
            log.error(message, e);
            return new HtmlErrorResolution(message, e);
        }
    }

    /**
     * Past wijzigingen toe en geeft XML terug zodat lokaal kan worden
     * opgeslagen door local-access-servlet.
     *
     * loads metadata from session
     * applies clientside element changes to metadata
     * synchronises between elements of metadata if configured
     * cleanup copy of metadata
     * transforms metadata to xml stream
     * @return xml stream
     */
    public Resolution updateElementsAndGetXml() throws Exception {
        try {
            // update xml only possible when write access
            viewMode = false;
            
            Document md = (Document) getContext().getRequest().getSession().getAttribute(SESSION_KEY_METADATA_XML);
            if (md == null) {
                throw new IllegalStateException("Geen metadatadocument geopend in deze sessie");
            }

            // Bij opslaan kunnen geen section changes zijn gedaan, ook geen
            // preprocessing nodig
            md = applyChangesXml(md, false);

            md = syncBetweenElements(md);

            Document mdCopy = cleanupXmlCopy(md, exportType);
            // Geen XML parsing door browser, geef door als String
            return new StreamingResolution("text/plain", new StringReader(DocumentHelper.getDocumentString(mdCopy)));
            
        } catch (Exception e) {
            String message = "Fout bij toepassen wijzigingen op XML document: " + elementChanges + " " + sectionChange;
            log.error(message, e);
            return new HtmlErrorResolution(message, e);
        }
    }

    /**
     * loads metadata from session
     * applies clientside element changes to metadata
     * synchronises between elements of metadata if configured
     * cleanup copy of metadata
     * save copy of metadata to source
     * @return success or throw exception
     */
    public Resolution updateAndSaveXml() throws Exception {

        Document md;
        Document mdCopy;

        try {

            md = (Document) getContext().getRequest().getSession().getAttribute(SESSION_KEY_METADATA_XML);
            if (md == null) {
                throw new IllegalStateException("Geen metadatadocument geopend in deze sessie");
            }

            // Saving organisations. In the MDE atm the old getOrganisations etc is used.
            //saveOrganisations(md);
            
            // Bij opslaan kunnen geen section changes zijn gedaan, ook geen
            // preprocessing nodig
            md = applyChangesXml(md, false);

            md = syncBetweenElements(md);

            // create copy because instance in session variable should not be cleaned
            mdCopy = cleanupXmlCopy(md, EXPORT_TYPE_ALL);

        } catch (Exception e) {
            String message = "Fout bij toepassen wijzigingen op XML document: " + elementChanges + " " + sectionChange;
            log.error(message, e);
            return new HtmlErrorResolution(message, e);
        }

        String mdString = DocumentHelper.getDocumentString(mdCopy);

        try {
            determineRoot();

            if (rootAccess.getSecurityLevel() < AclAccess.WRITE.getSecurityLevel()) {
                throw new B3PCatalogException("Geen rechten om metadata op te slaan op deze locatie");
            }

            saveXmlToSource(mdString);

            return new StreamingResolution("text/plain", "success");
            
        } catch (Exception e) {
            String message = "Could not write " + mode + " metadata to location " + path;
            log.error(message, e);
            return new HtmlErrorResolution(message, e);
        }
    }

    /**
     * load metadata from session
     * synchronise by filling elements based on info from datasource
     * save metadata on session
     * transforms metadata to html fragment
     * @return transformed html fragment
     * @throws Exception 
     */
    public Resolution synchronizeLocal() throws Exception {

        determineRoot(); // select edit or view mode.

        // metadata string must already have been preprocessed on the clientside
        Document md = (Document) getContext().getRequest().getSession().getAttribute(SESSION_KEY_METADATA_XML);
        if (md == null) {
            throw new IllegalStateException("Geen metadatadocument geopend in deze sessie");
        }

        // Changed check for .shp.xml into .shp as afaik the filetree and java applet filter 
        // out .xml files. 
        if (path.toLowerCase().endsWith(".shp")) {

            ShapefileSynchronizer.synchronizeFromLocalAccessJSON(md, synchronizeData);

        } else if (path.toLowerCase().endsWith(".nc.xml")) {

            md = NCMLSynchronizer.synchronizeNCML(md, synchronizeData);
        }
        getContext().getRequest().getSession().setAttribute(SESSION_KEY_METADATA_XML, md);
        
        String html = createHtmlFragment(md);
        return new HtmlResolution(new StringReader(html), extraHeaders);
    }


    /**
     * load metadata from session
     * synchronise by filling elements based on info from datasource
     * save metadata on session
     * transforms metadata to html fragment
     * @return transformed html fragment
     * @throws Exception 
     */
    public Resolution synchronize() {

        try {

            if (LOCAL_MODE.equals(mode)) {
                return synchronizeLocal(); // Already calls determineRoot(); 
            }

            determineRoot(); // select view or edit mode. 

            // metadata string must already have been preprocessed on the clientside
            Document md = (Document) getContext().getRequest().getSession().getAttribute(SESSION_KEY_METADATA_XML);
            if (md == null) {
                throw new IllegalStateException("Geen metadatadocument geopend in deze sessie");
            }

            md = syncXmlFromDataSource(md);
            
            md = syncBetweenElements(md);

            getContext().getRequest().getSession().setAttribute(SESSION_KEY_METADATA_XML, md);

            String html = createHtmlFragment(md);
            return new HtmlResolution(new StringReader(html), extraHeaders);
            
        } catch (Exception e) {
            String message = "Fout tijdens synchroniseren " + mode + " metadata van lokatie " + path;
            log.error(message, e);
            return new HtmlErrorResolution(message, e);
        }
    }

    /**
     * synchronise by filling elements based on info from datafile
     * @param xmlDoc
     * @param dataFile
     * @throws IOException
     * @throws JDOMException 
     */
    private void synchronizeRegularMetadata(Document xmlDoc, File dataFile) throws IOException, JDOMException, B3PCatalogException {
        String localFilename = dataFile.getName();

        String title = "";
        String fileFormat = "";
        int dotIndex = localFilename.lastIndexOf(".");
        if (dotIndex > 0) {
            title = localFilename.substring(0, dotIndex);
            if (dotIndex < localFilename.length()) {
                fileFormat = localFilename.substring(dotIndex + 1);
                fileFormat = StringUtils.capitalize(fileFormat);
            }
        } else if (dotIndex == 0) {
            title = localFilename.substring(1);
        }

        // Set title if needed in DC or DS
        // Check if synchroniseDC_init in config.xml is true
        if (getXSLParam("synchroniseDC_init")) {

            Element dcTitle = XPathHelper.selectSingleElement(xmlDoc, XPathHelper.DOM_DC_TITLE);

                // If title is NOT already filled then synchronize it.
            // Note: Changes made in the MDE are only picked up after a save of the document.
            if (dcTitle.getText().isEmpty()) {
                XPathHelper.applyXPathValuePair(xmlDoc, XPathHelper.DOM_DC_TITLE, title);
            }
        } else {
            // set title in DS1.

            Element dsTitle = XPathHelper.selectSingleElement(xmlDoc, XPathHelper.TITLE);

            // If title is NOT already filled then synchronize it.
            // Note: Changes made in the MDE are only picked up after a save of the document.
            if (dsTitle.getText().isEmpty()) {
                XPathHelper.applyXPathValuePair(xmlDoc, XPathHelper.TITLE, title);
            }
        }

        XPathHelper.applyXPathValuePair(xmlDoc, XPathHelper.FC_TITLE, title);

        XPathHelper.applyXPathValuePair(xmlDoc, XPathHelper.DISTR_FORMAT_NAME, fileFormat);
        // Als distribute formaat naam is ingevuld, moet ook de versie ingevuld staan, anders is de xml niet correct volgens het xsd.
        XPathHelper.applyXPathValuePair(xmlDoc, XPathHelper.DISTR_FORMAT_VERSION, "Onbekend");

        XPathHelper.applyXPathValuePair(xmlDoc, XPathHelper.URL_DATASET, dataFile.getCanonicalPath());
        XPathHelper.applyXPathValuePair(xmlDoc, XPathHelper.NAME_DATASET, "");
        XPathHelper.applyXPathValuePair(xmlDoc, XPathHelper.PROTOCOL_DATASET, "download");
        XPathHelper.applyXPathValuePair(xmlDoc, XPathHelper.DESC_DATASET, "");

        //TODO: file type in md opslaan?
    }


    /**
     * loads metadata from import form
     * preprocesses metadata to hold all elements
     * adds date and uuid when required to metadata
     * saves metadata on session
     * transforms metadata to html fragment
     * @return html fragment
     */
    public Resolution importMD() {

        try {
            Document md;
            
            // import xml only possible when write access
            viewMode = false;
            
            if (importXml != null) {
                md = new SAXBuilder().build(importXml.getInputStream());
            } else if (metadata != null) {
                md = DocumentHelper.getMetadataDocument(metadata);
            } else {
                throw new IllegalArgumentException();
            }

            md = preprocessXml(md);
           
            //datestamp and uuid added when empty
            md = addDateUUID(md);

            getContext().getRequest().getSession().setAttribute(SESSION_KEY_METADATA_XML, md);

            String html = createHtmlFragment(md);
            return new HtmlResolution(new StringReader(html), extraHeaders);

        } catch (Exception e) {
            getContext().getRequest().getSession().removeAttribute(SESSION_KEY_METADATA_XML);
            String message = "Fout bij laden importeren metadata " + path;
            log.error(message, e);
            return new HtmlErrorResolution(message, e);
        } finally {
            try {
                if (importXml != null) {
                    importXml.delete();
                }
            } catch (IOException ex) {
            }
        }
    }

    /**
     * execute updateElementsAndGetXml
     * stream xml
     * @return xml stream
     * @throws Exception 
     */
    public Resolution export() throws Exception {
        Resolution resolution = updateElementsAndGetXml();

        if (resolution instanceof StreamingResolution) {
            String exportName = null;
            int i = path.lastIndexOf("/");
            if (i == -1) {
                i = path.lastIndexOf("\\");
            }
            if (i != -1) {
                exportName = path.substring(i + 1);
            } else {
                exportName = path;
            }
            if (!exportName.endsWith(".xml")) {
                exportName = exportName + ".xml";
            }
            StreamingResolution sr = (StreamingResolution) resolution;
            sr.setAttachment(true);
            sr.setFilename(exportName);
        }
        return resolution;
    }

    /**
     * load metadata from session
     * add comment
     * preprocesses metadata to hold all elements
     * saves metadata on session
     * transforms metadata to html fragment
     * @return transformed html fragment
     * @throws Exception 
     */
    public Resolution postComment() throws Exception {

        try {

            Document md = (Document) getContext().getRequest().getSession().getAttribute(SESSION_KEY_METADATA_XML);
            if (md == null) {
                throw new IllegalStateException("Geen metadatadocument geopend in deze sessie");
            }
            determineRoot(); 

            if (rootAccess.getSecurityLevel() < AclAccess.COMMENT.getSecurityLevel()) {
                throw new B3PCatalogException("Geen rechten om commentaar aan metadata toe te voegen op deze locatie");
            }

            addComment(md, comment);

            md = preprocessXml(md);
            
            getContext().getRequest().getSession().setAttribute(SESSION_KEY_METADATA_XML, md);

            // do save xml with comment when posting, otherwise users with only
            // comment role will not be able to save
            if (rootAccess.getSecurityLevel() == AclAccess.COMMENT.getSecurityLevel()) {
                Document mdCopy = cleanupXmlCopy(md, EXPORT_TYPE_ALL);
                String mdString = DocumentHelper.getDocumentString(mdCopy);
                saveXmlToSource(mdString);
            }
             
            String html = createHtmlFragment(md);
            return new HtmlResolution(new StringReader(html), extraHeaders);

        } catch (Exception e) {
            String message = "Het is niet gelukt om het commentaar (" + comment + ") te posten in " + mode + " op lokatie \"" + path + "\"";
            log.error(message, e);
            return new HtmlErrorResolution(message, e);
        }
    }

    /**
     * preprocesing adds all elements possible
     * client specific preprocessing possible
     * @param md
     * @return
     * @throws JDOMException
     * @throws IOException
     * @throws TransformerException 
     */
    private Document preprocessXml(Document md) throws JDOMException, IOException, TransformerException {
        md = mdeXml2Html.preprocess(md, viewMode);
        md = mdeXml2Html.extraPreprocessor1(md, viewMode);
        md = mdeXml2Html.extraPreprocessor2(md, viewMode);
        log.debug("serverside xml after preprocessing: " + DocumentHelper.getDocumentString(md));
        return md;
    }
    
    /**
     * transform xml into html fragment
     * client specific adaptation of html possible
     * @param md
     * @return
     * @throws JDOMException
     * @throws IOException
     * @throws TransformerException 
     */
    private String createHtmlFragment(Document md) throws JDOMException, IOException, TransformerException {
        Document htmlDoc = mdeXml2Html.transform(md, viewMode);
        htmlDoc = mdeXml2Html.extraPostprocessor1(htmlDoc, viewMode);
        String html = DocumentHelper.getDocumentString(htmlDoc);
        log.debug("serverside rendered html: " + html);
        return html;
    }

    private Document addDateUUID(Document md) throws JDOMException {
        //datestamp and uuid added when empty
        mdeXml2Html.addDateStamp(md, false);
        mdeXml2Html.addUUID(md, false);
        return md;
    }

    /**
     * syncing between elements of the xml tree
     * @param md
     * @return
     * @throws B3PCatalogException
     * @throws JDOMException
     * @throws IOException
     * @throws TransformerException 
     */
    private Document syncBetweenElements(Document md) throws B3PCatalogException, JDOMException, IOException, TransformerException {
        Boolean synchroniseDC = mdeXml2Html.getXSLParam("synchroniseDC_init");
        if (synchroniseDC != null && synchroniseDC) {
            md = mdeXml2Html.dCtoISO19115Synchronizer(md);
            // TODO zijn de volgende syncs nodig?
//                md = mdeXml2Html.iSO19115toDCSynchronizer(md);
        }
        md = mdeXml2Html.extraSync1(md);
        md = mdeXml2Html.extraSync2(md);
        return md;
    }
    
    /**
     * load metadata from source specific location:
     * <li>xml file next to datafile
     * <li>kaartenbalie tables
     * <li>sde/shape geometries
     * <li>fgbd files
     * @param md
     * @return
     * @throws JDOMException
     * @throws Exception 
     */
    private Document loadXmlFromSource(Document md) throws JDOMException, Exception {
        // Java applet is used, metadata in request param metadata
        if (LOCAL_MODE.equals(mode)) {
                // metadata contains the string "null" when the following happens.
            // In the java applet a file is selected called X. The javascript then calls a Java applet
            // to read file X.xml. If this succeeds the methode loadAsHtml is called and metadata contains 
            // the xml contents of X.xml. If the applet fails (happens when no .xml exists) method loadMdHtml
            // is also called but this time the variable metadata does not contain XML but the 
            // string "null". Hence this test.
            if (metadata.equals("null")) {
                metadata = DocumentHelper.EMPTY_METADATA;
            }
            md = DocumentHelper.getMetadataDocument(metadata);

        } else {
            if (KB_MODE.equals(mode)) {

                metadata = KbJDBCHelperProxy.getMetadata(root, path);
                md = DocumentHelper.getMetadataDocument(metadata);

            } else if (SDE_MODE.equals(mode)) {

                metadata = ArcSDEHelperProxy.getMetadata(root, path);
                md = DocumentHelper.getMetadataDocument(metadata);

            } else if (FILE_MODE.equals(mode)) {

                File mdFile = FileListHelper.getFileForPath(root, path);

                if (FGDBHelperProxy.isFGDBDirOrInsideFGDBDir(mdFile)) {
                    try {
                        FGDBHelperProxy.cleanerTrackObjectsInCurrentThread();
                        metadata = FGDBHelperProxy.getMetadata(mdFile, esriDTFeatureClass);
                    } finally {
                        FGDBHelperProxy.cleanerReleaseAllInCurrentThread();
                    }
                    md = DocumentHelper.getMetadataDocument(metadata);

                } else {
                    mdFile = new File(mdFile.getCanonicalPath() + Extensions.METADATA);
                    if (!mdFile.exists()) {
                        // create new metadata on client side or show this in exported file:
                        md = DocumentHelper.getMetadataDocument(DocumentHelper.EMPTY_METADATA);
                    } else {
                        md = DocumentHelper.getMetadataDocument(mdFile);
                    }
                }
            } else {
                throw new IllegalArgumentException("Invalid mode: " + mode);
            }
        }
        return md;
    }
    
    /**
     * save metadata to source specific location
     * @param mdString
     * @throws Exception 
     */
    private void saveXmlToSource(String mdString) throws Exception {
        if (KB_MODE.equals(mode)) {

            KbJDBCHelperProxy.saveMetadata(root, path, mdString);

        } else if (SDE_MODE.equals(mode)) {

            Object dataset = ArcSDEHelperProxy.getDataset(root, path);
            ArcSDEHelperProxy.saveMetadata(dataset, mdString);

        } else if (FILE_MODE.equals(mode)) {

            File mdFile = FileListHelper.getFileForPath(root, path);

            if (FGDBHelperProxy.isFGDBDirOrInsideFGDBDir(mdFile)) {
                try {
                    FGDBHelperProxy.cleanerTrackObjectsInCurrentThread();
                    FGDBHelperProxy.setMetadata(mdFile, 5, mdString);
                } finally {
                    FGDBHelperProxy.cleanerReleaseAllInCurrentThread();
                }
            } else {
                mdFile = new File(mdFile.getCanonicalPath() + Extensions.METADATA);

                OutputStream outputStream = new BufferedOutputStream(FileUtils.openOutputStream(mdFile));
                outputStream.write(mdString.getBytes("UTF-8"));
                outputStream.close();
            }
        } else {
            throw new IllegalArgumentException("Invalid mode: " + mode);
        }
    }   
    
    /**
     * sync metadata by collecting informatie from the dataset:
     * <li>bbox
     * <li>title
     * <li>projection
     * <li>.....
     * @param md
     * @return
     * @throws JDOMException
     * @throws Exception 
     */
    private Document syncXmlFromDataSource(Document md) throws JDOMException, Exception {
        if (KB_MODE.equals(mode)) {

            String mdString = DocumentHelper.getDocumentString(md);
            mdString = KbJDBCHelperProxy.syncMetadata(root, path, mdString);
            md = DocumentHelper.getMetadataDocument(mdString);

        } else if (SDE_MODE.equals(mode)) {

            Object dataset = ArcSDEHelperProxy.getDataset(root, path);

            if (dataset instanceof ArcSDEJDBCDataset) {

                ArcObjectsConfig cfg = CatalogAppConfig.getConfig().getArcObjectsConfig();

                if (cfg.isEnabled()) {
                    dataset = ArcSDEHelperProxy.getArcObjectsDataset(root, path);
                    ArcGISSynchronizer.synchronize(md, dataset, ArcGISSynchronizer.FORMAT_NAME_SDE);
                } else if (cfg.isForkSynchroniser()) {
                    ArcSDEJDBCDataset ds = (ArcSDEJDBCDataset) dataset;

                    if (ds.getRoot().getArcobjectsConnection() == null) {
                        throw new Exception("ArcObjects niet geconfigureerd, synchroniseren niet mogelijk");
                    }
                    md = ArcObjectsSynchronizerForker.synchronize(
                            getContext().getServletContext(),
                            ds.getAbsoluteName(),
                            ArcObjectsSynchronizerMain.TYPE_SDE,
                            ds.getRoot().getArcobjectsConnection(),
                            metadata
                    );
                } else {
                    throw new Exception("ArcObjects niet geconfigureerd, synchroniseren niet mogelijk");
                }
            } else {
                ArcGISSynchronizer.synchronize(md, dataset, ArcGISSynchronizer.FORMAT_NAME_SDE);
            }

        } else if (FILE_MODE.equals(mode)) {

            File dataFile = FileListHelper.getFileForPath(root, path);

            boolean isFGDB = FGDBHelperProxy.isFGDBDirOrInsideFGDBDir(dataFile);
            ArcObjectsConfig cfg = CatalogAppConfig.getConfig().getArcObjectsConfig();
            if (cfg.isEnabled()) {
                if (isFGDB) {
                    try {
                        FGDBHelperProxy.cleanerTrackObjectsInCurrentThread();

                        Object ds = FGDBHelperProxy.getTargetDataset(dataFile, 5 /*esriDatasetType.esriDTFeatureClass*/);
                        ArcGISSynchronizer.synchronize(md, ds, ArcGISSynchronizer.FORMAT_NAME_FGDB);
                    } finally {
                        FGDBHelperProxy.cleanerReleaseAllInCurrentThread();
                    }
                } else if (path.endsWith(Extensions.SHAPE)) {
                    try {
                        FGDBHelperProxy.cleanerTrackObjectsInCurrentThread();

                        Object ds = DatasetHelperProxy.getShapeDataset(dataFile);
                        ArcGISSynchronizer.synchronize(md, ds, ArcGISSynchronizer.FORMAT_NAME_SHAPE);
                    } finally {
                        FGDBHelperProxy.cleanerReleaseAllInCurrentThread();
                    }
                }
            } else if (cfg.isForkSynchroniser()) {
                md = ArcObjectsSynchronizerForker.synchronize(
                        getContext().getServletContext(),
                        FileListHelper.getFileForPath(root, path).getAbsolutePath(),
                        isFGDB ? ArcObjectsSynchronizerMain.TYPE_FGDB : ArcObjectsSynchronizerMain.TYPE_SHAPE,
                        null,
                        metadata
                );
            } else if (path.endsWith(Extensions.SHAPE)) {
                File shapeFile = FileListHelper.getFileForPath(root, path);

                    // TODO: Create a new method which combines the two. No point in first creating 
                // A JSON object and then saving it. The JSON step has to go.
                // Implement this after all other requirements are done/tested.
                String synchronizeData = Shapefiles.getMetadata(shapeFile.getCanonicalPath());
                ShapefileSynchronizer.synchronizeFromLocalAccessJSON(md, synchronizeData);

            } else {
                synchronizeRegularMetadata(md, dataFile);
            }
        } else {
            throw new IllegalArgumentException("Invalid mode: " + mode);
        }
        return md;
    }
 
    /**
     * remove empty elements and parts of the xml tree that do not belong there
     * what belogs or not depends on the type of metadat that is required:
     * <li>metadata for services
     * <li>metadata for datasets
     * <li>full set of metadata
     * @param md
     * @param strict
     * @return
     * @throws B3PCatalogException 
     */
    private Document cleanupXmlCopy(Document md, String exportType) throws B3PCatalogException {
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
  
    /**
     * When editing clientside all edits are collected and send to the backend
     * in one go using a JSON array. Here the JSON is applied to the xml tree.
     * @param md
     * @param doSections
     * @return
     * @throws Exception 
     */
    private Document applyChangesXml(Document md, boolean doSections) throws Exception {
        if (elementChanges != null) {
            mdeXml2Html.applyElementChanges(md, new JSONArray(elementChanges));
        }

        if (sectionChange != null && doSections) {
            mdeXml2Html.applySectionChange(md, new JSONObject(sectionChange));
        }
        return md;
    }
    
    protected Document extractMD_MetadataAsDoc(Document doc) throws JDOMException, IOException, B3PCatalogException {
        Element MD_Metadata = DocumentHelper.getMD_Metadata(doc); 

        MD_Metadata.detach();
        Document extractedDoc = new Document(MD_Metadata);

        return extractedDoc;
    }
    
    protected String extractMD_Metadata(Document doc) throws JDOMException, IOException, B3PCatalogException {
        Document extractedDoc = extractMD_MetadataAsDoc(doc);
        return new XMLOutputter(Format.getPrettyFormat()).outputString(extractedDoc);
    }

    protected Document extractMD_MetadataAsDoc(String md) throws JDOMException, IOException, B3PCatalogException {
        Document doc = DocumentHelper.getMetadataDocument(md);
        return extractMD_MetadataAsDoc(doc);
    }

    protected String extractMD_Metadata(String md) throws JDOMException, IOException, B3PCatalogException {
        Document extractedDoc = extractMD_MetadataAsDoc(md);

        return new XMLOutputter(Format.getPrettyFormat()).outputString(extractedDoc);
    }

    protected Document extractMD_MetadataAsDoc(File mdFile) throws JDOMException, IOException, B3PCatalogException {
        Document doc = DocumentHelper.getMetadataDocument(mdFile);
        return extractMD_MetadataAsDoc(doc);
    }

    protected String extractMD_Metadata(File mdFile) throws JDOMException, IOException, B3PCatalogException {
        Document extractedDoc = extractMD_MetadataAsDoc(mdFile);

        return new XMLOutputter(Format.getPrettyFormat()).outputString(extractedDoc);
    }

    private void addComment(Document doc, String comment) throws B3PCatalogException {
        Element comments = DocumentHelper.getComments(doc);
        if (comments == null) {
            throw new B3PCatalogException("Xml Document is non-metadata xml. This is not allowed.");
        }

        String user = getContext().getRequest().getRemoteUser();
        if (user == null) {
            user = username;
        }
        Element newComment = new Element(Names.B3P_COMMENT, Namespaces.B3P).addContent(Arrays.asList(
                new Element(Names.B3P_USERNAME, Namespaces.B3P).setText(user),
                new Element(Names.B3P_DATE_TIME, Namespaces.B3P).setText(DATETIME_FORMAT.format(new Date())),
                new Element(Names.B3P_CONTENT, Namespaces.B3P).setText(comment)
        ));
        comments.addContent(newComment);
        log.debug("serverside xml after adding new comment: " + DocumentHelper.getDocumentString(doc));

    }
    
    private void saveOrganisations(Document md) throws JDOMException {

        Element ds1OrganisationName = XPathHelper.selectSingleElement(md, XPathHelper.DOM_DS1_ORGANISATION_NAME);
        Element ds2OrganisationName = XPathHelper.selectSingleElement(md, XPathHelper.DOM_DS2_ORGANISATION_NAME);
        Element ds3OrganisationName = XPathHelper.selectSingleElement(md, XPathHelper.DOM_DS3_ORGANISATION_NAME);
        log.debug("Saving organisation info into organisation.json file");
        log.debug("ds1OrganisationName:" + ds1OrganisationName + "value: " + ds1OrganisationName.getText());
        log.debug("ds2OrganisationName:" + ds2OrganisationName + "value:" +  ds2OrganisationName.getText());
        log.debug("ds3OrganisationName:" + ds3OrganisationName + "value:" +  ds3OrganisationName.getText());
        
        // Some tests.
        String jsonString = OrganisationsAction.getOrganisations();
        String jsonStringV2 = OrganisationsAction.getOrganisationsV2();
        log.debug("wolverine. Read in json file contents. getOrganisations " + jsonString);
        log.debug("wolverine. Read in json file contents. getOrganisationsV2 " + jsonStringV2);
        
        saveNewOrChangedOrganisation(md);
        showOrganisations(); 
        

    }

    

    // <editor-fold defaultstate="collapsed" desc="getters en setters">
    public String getMode() {
        return mode;
    }

    public void setMode(String mode) {
        this.mode = mode;
    }

    public String getElementChanges() {
        return elementChanges;
    }

    public void setElementChanges(String elementChanges) {
        this.elementChanges = elementChanges;
    }

    public String getSectionChange() {
        return sectionChange;
    }

    public void setSectionChange(String sectionChange) {
        this.sectionChange = sectionChange;
    }

    public String getPath() {
        return path;
    }

    public void setPath(String path) {
        this.path = path;
    }

    public String getMetadata() {
        return metadata;
    }

    public void setMetadata(String metadata) {
        this.metadata = metadata;
    }

    public String getComment() {
        return comment;
    }

    public void setComment(String comment) {
        this.comment = comment;
    }

    public String getExportType() {
        return exportType;
    }

    public void setExportType(String exportType) {
        this.exportType = exportType;
    }

    public FileBean getImportXml() {
        return importXml;
    }

    public void setImportXml(FileBean importXml) {
        this.importXml = importXml;
    }

    public String getSynchronizeData() {
        return synchronizeData;
    }

    public void setSynchronizeData(String synchronizeData) {
        this.synchronizeData = synchronizeData;
    }

    public String getUsername() {
        return username;
    }

    public void setUsername(String username) {
        this.username = username;
    }

    /**
     * @return the viewMode
     */
    public Boolean getViewMode() {
        return viewMode;
    }

    /**
     * @param viewMode the viewMode to set
     */
    public void setViewMode(Boolean viewMode) {
        this.viewMode = viewMode;
    }
    // </editor-fold>

    private void showOrganisations() {
        
        
       try {
           String jsonStringV2 = OrganisationsAction.getOrganisationsV2();
           // if we get here the json is already validated.
           
           JSONObject jsonObj= new JSONObject(jsonStringV2);
           
           createJsonTestObject();
           
           // Lets loop over all the organisations in the json file.
           
           Iterator <?> keys = jsonObj.keys();
           while ( keys.hasNext() ) {
               String key = (String)keys.next();
            if( jsonObj.get(key) instanceof JSONObject ){
                  displayOrganisation (key, (JSONObject) jsonObj.get(key)); 
            }
           } 
           
           
           // throw new UnsupportedOperationException("Not supported yet."); //To change body of generated methods, choose Tools | Templates.
       } catch (JSONException ex) {
           Logger.getLogger(MetadataAction.class.getName()).log(Level.SEVERE, null, ex);
       }
    }

    private void createJsonTestObject() {
        
       try {
           JSONObject jsonOrgContent = new JSONObject();
           JSONObject jsonContacts = new JSONObject();
           JSONObject jsonOrganisation = new JSONObject();
           
                     
           // This is the body of an organisation.
           jsonOrgContent.put("address", "wolv-org address");
           jsonOrgContent.put( "city", "wolv-org city");
           jsonOrgContent.put( "state", "wolv-org state");
           jsonOrgContent.put( "PostalCode", "wolv-org postalCode");
           jsonOrgContent.put(  "country", "wolv-org country");
           
           jsonOrgContent.put( "url", "<stad>");
           jsonOrgContent.put( "email", "wolv-org email");
           jsonOrgContent.put( "PostalCode", "<postcode>");
           jsonOrgContent.put(  "voice", "wolv-org voice");
           
           
           // Contacts object.
           jsonContacts.put("wolv-org contact 1", new JSONObject().put("email","wolv-org contacts 1 email wolverine2710@gmail.com"));
           jsonContacts.put("wolv-org contact 2", new JSONObject().put("email","wolv-org contacts 2 email wolverine2710@gmail.com"));                
           jsonOrgContent.put("contacts",jsonContacts );
           
           // Now create 
           jsonOrganisation.put("Wolv-org organisatie house of snikt", jsonOrgContent); 
           
           log.debug("Wolverine: manually contstructed json object" + jsonOrganisation.toString());
           //System.out.println("Wolverine: manually contstructed json object" + jsonOrganisation.to);
           
           
           
           
           
           //throw new UnsupportedOperationException("Not supported yet."); //To change body of generated methods, choose Tools | Templates.
       } catch (JSONException ex) {
           Logger.getLogger(MetadataAction.class.getName()).log(Level.SEVERE, null, ex);
       }
       
    }

    private void displayOrganisation(String key, JSONObject valueObj) {

        log.debug("wolv displayOrganisation. key:" + key);
        log.debug("wolv displayOrganisation. value:" + valueObj.toString());

        log.debug("address:" + valueObj.opt("address"));
        log.debug("city:" + valueObj.opt("city"));
        log.debug("state:" + valueObj.opt("state"));
        log.debug("postalCode:" + valueObj.opt("postalCode"));
        log.debug("url:" + valueObj.opt("url"));
        log.debug("email:" + valueObj.opt("email"));
        log.debug("voice:" + valueObj.opt("voice"));

        JSONObject contacts = (JSONObject) valueObj.opt("contacts");
        JSONObject contactsObj = new JSONObject();
        
        
        Iterator<?> contactKeys = contacts.keys();
        while (contactKeys.hasNext()) {
            String keyContact = (String) contactKeys.next();
            String emailAddress = "";

            try {
                contactsObj = (JSONObject) contacts.get(keyContact);
                if (contactsObj instanceof JSONObject) {
                    // displayOrganisation(key, (JSONObject) jsonObj.get(key));
                    emailAddress =  (String) contactsObj.opt("email"); 
                }
                else {
                    emailAddress ="dummy"; 
                }
                log.debug("contact:" + keyContact + "email:" + emailAddress);
            } catch (JSONException ex) {
                Logger.getLogger(MetadataAction.class.getName()).log(Level.SEVERE, null, ex);
            }
        }
    }

 
    private void saveNewOrChangedOrganisation(Document md) {
        try {
           //throw new UnsupportedOperationException("Not supported yet."); //To change body of generated methods, choose Tools | Templates.

            // retrieve currently stored Organisations.
            String jsonStringV2 = OrganisationsAction.getOrganisationsV2();

           // if we get here the json is already validated.
            JSONObject jsonObj = new JSONObject(jsonStringV2);
            JSONObject jsonMde = new JSONObject();
            JSONObject jsonNewOrChanged = new JSONObject();
            JSONObject jsonMerged = new JSONObject();
            JSONObject currentValue = new JSONObject();
            JSONObject curentOrganisationJson = new JSONObject();

            // Create a list/array of all the of keys of the json objects.
            String[] fieldNames = JSONObject.getNames(jsonObj);
            log.debug("String array fieldnames:" + fieldNames);
            log.debug("List of fieldnames:" + Arrays.asList(fieldNames));

            // Lets loop over all the organisations in the json file.
            Iterator<?> keys = jsonObj.keys();
            while (keys.hasNext()) {
                String currKey = (String) keys.next();
                currentValue = (JSONObject) jsonObj.get(currKey);
                if (currentValue instanceof JSONObject) {
                    displayOrganisation(currKey, currentValue);
                    curentOrganisationJson = createJsonObject(currKey, currentValue);
                    jsonMde = getMdeOrganisation(md, 1);

                    // Check if the json Object retrieve from the MDE is already in the organisation.json file.
                    if (!Arrays.asList(fieldNames).contains(getOrganisationsName(jsonMde))) {
                        // Add organisation to existing json file.
                        //String orgName = JSONObject.getNames(jsonMde)[0];
                        String orgName = getOrganisationsName(jsonMde);
                        JSONObject orgValue = jsonMde.getJSONObject(orgName);
                        jsonNewOrChanged.put(orgName, orgValue);

                    } else if (isNewOrChangedOrganisation(curentOrganisationJson, jsonMde)) {

                        // Add organisation to existing json file.
                        String orgName = JSONObject.getNames(jsonMde)[0];
                        JSONObject orgValue = jsonMde.getJSONObject(orgName);
                        jsonNewOrChanged.put(orgName, orgValue);

                    } else {
                        String dummy = "UNchanged";
                    }

                }
            }
            // merge contents of the json file with the new/changed MDE object.
            jsonMerged = mergeJson(jsonObj, jsonNewOrChanged);
            OrganisationsAction.setOrganisationsV2(jsonMerged);

          // save merged json object to the file.
        } catch (JSONException ex) {
            Logger.getLogger(MetadataAction.class.getName()).log(Level.SEVERE, null, ex);
        }
    }

    private JSONObject getMdeOrganisation(Document md, int number) {

        JSONObject jsonOrgContent = new JSONObject();
        JSONObject jsonContacts = new JSONObject();
        JSONObject jsonOrganisation = new JSONObject();

        String organisation = ""; 
        String address = ""; 
        String city = "";
        String state = "";
        String postalCode = ""; 
        String country = "";
        String url = ""; 
        String email = "";
        String voice = ""; 
        String contact1Name = ""; 
        String contact2Name = ""; 
        String contact1Email = ""; 
        String contact2Email = ""; 
        
        
        
       try {
           // ON three places in the MDE organisations info is stored
           // One can specify which one you want to retrieve and its returned
           
           switch (number) {
               case 1:
                   organisation = getValueElement(md, XPathHelper.DOM_DS1_ORGANISATION_NAME);
                   address = getValueElement(md, XPathHelper.DOM_DS1_ADDRESS);
                   city = getValueElement(md, XPathHelper.DOM_DS1_CITY);
                   postalCode = getValueElement(md, XPathHelper.DOM_DS1_POSTCALCODE);
                   country = getValueElement(md, XPathHelper.DOM_DS1_COUNTRY);
                   city = getValueElement(md, XPathHelper.DOM_DS1_CITY);
                   email = getValueElement(md, XPathHelper.DOM_DS1_EMAIL);
                   voice = getValueElement(md, XPathHelper.DOM_DS1_VOICE);
                   url = getValueElement(md, XPathHelper.DOM_DS1_URL);
                   
                   
                   break;
               case 2:
                   break;
               case 3:
                   break;
           }
           
           
                     
           // This is the body of an organisation.
           jsonOrgContent.put("address", email);
           jsonOrgContent.put( "city", city);
           jsonOrgContent.put( "state", state);
           jsonOrgContent.put( "postalCode", postalCode);
           jsonOrgContent.put( "country", country);
           
           jsonOrgContent.put( "url", url);
           jsonOrgContent.put( "email", email);
           jsonOrgContent.put(  "voice", voice);
           
           // Contacts object.
           jsonContacts.put( contact1Name, new JSONObject().put("email",""));
           jsonOrgContent.put("contacts",jsonContacts );
           
           // Now create
           jsonOrganisation.put(organisation, jsonOrgContent); 
           
       } catch (JSONException ex) {
           Logger.getLogger(MetadataAction.class.getName()).log(Level.SEVERE, null, ex);
       }
       return jsonOrganisation;
        
    }

    private String getValueElement(Document md, String domElement) {
        
       String elementValue = "";
       try {
           Element element = XPathHelper.selectSingleElement(md, domElement);
           
           // If title is NOT already filled then synchronize it.
           // Note: Changes made in the MDE are only picked up after a save of the document.
            if (element.getText().isEmpty()) {
                elementValue = ""; 
            }
            else {
                elementValue = element.getText(); 
            }

           return elementValue;
       } catch (JDOMException ex) {
           Logger.getLogger(MetadataAction.class.getName()).log(Level.SEVERE, null, ex);
       }
       return elementValue; 
    }

    private boolean isNewOrChangedOrganisation(JSONObject base, JSONObject check) {

        boolean exists = true; // defaults to true

        // Fields which HAVE to be the same. 
        String[] fields =  {ADDRESS, CITY, STATE,  POSTCALCODE, COUNTRY, URL, EMAIL};
        String lastProcesedField = ""; 
        String fieldBase = "";
        String fieldCheck = "";
        
        
        for (String field : fields) {
            
            try {
                JSONObject baseContent = (JSONObject) base.get(getOrganisationsName(base));
                JSONObject checkContent = (JSONObject) check.get(getOrganisationsName(check));
                
                fieldBase = (String) baseContent.opt(field);
                fieldCheck = (String) checkContent.opt(field);
                
                if (fieldBase.equals(fieldCheck)) {
                    exists = false;
                }
                else {
                    lastProcesedField = field;
                    exists = true;
                    log.debug("Method isNewOrChangedOrganisation breaks on:" + lastProcesedField); 
                    break;
                }
            } catch (JSONException ex) {
                
               Logger.getLogger(MetadataAction.class.getName()).log(Level.SEVERE, null, ex);
//                exists = false;
//                break;
            }
        }
        return exists;
    }

    private JSONObject mergeJson(JSONObject jsonObj, JSONObject jsonNewOrChanged) {

        JSONObject merged = new JSONObject(jsonObj, JSONObject.getNames(jsonObj));
        for (String key : JSONObject.getNames(jsonNewOrChanged)) {
            try {
                merged.put(key, jsonNewOrChanged.get(key));
            } catch (JSONException ex) {
                Logger.getLogger(MetadataAction.class.getName()).log(Level.SEVERE, null, ex);
            }
        }
        return merged;

    }

    private String getOrganisationsName(JSONObject organisation) {
        
           String organisationName = JSONObject.getNames(organisation)[0];
           return organisationName;
        
        //throw new UnsupportedOperationException("Not supported yet."); //To change body of generated methods, choose Tools | Templates.
    }

    private JSONObject createJsonObject(String jsonKey, JSONObject jsonValue) {

        JSONObject jsonObject = new JSONObject();
        try {

            jsonObject.put(jsonKey, jsonValue);

        } catch (JSONException ex) {
            Logger.getLogger(MetadataAction.class.getName()).log(Level.SEVERE, null, ex);
        }
        return jsonObject;
    }

}
  
