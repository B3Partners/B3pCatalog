package nl.b3p.catalog.stripes;

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
import java.util.Map;
import net.sourceforge.stripes.action.FileBean;
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
import nl.b3p.catalog.resolution.HtmlErrorResolution;
import nl.b3p.catalog.resolution.HtmlResolution;
import nl.b3p.catalog.xml.DocumentHelper;
import nl.b3p.catalog.xml.NCMLSynchronizer;
import nl.b3p.catalog.xml.Names;
import nl.b3p.catalog.xml.Namespaces;
import nl.b3p.catalog.xml.ShapefileSynchronizer;
import nl.b3p.catalog.xml.XPathHelper;
import nl.b3p.catalog.xml.mdeXml2Html;
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
import org.json.JSONObject;

public class MetadataAction extends DefaultAction {

    private final static Log log = LogFactory.getLog(MetadataAction.class);

    private static final String FILE_MODE = "file";
    private static final String SDE_MODE = "sde";
    private static final String LOCAL_MODE = "local";

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
    private boolean strictISO19115 = false;

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
        } else {
            root = Root.getRootForPath(path, getContext().getRequest(), AclAccess.READ);
            rootAccess = root.getRequestUserHighestAccessLevel(getContext().getRequest());
            extraHeaders.put("X-MDE-Access", rootAccess.name());
        }
    }

    public boolean determineViewMode() {

        boolean viewMode = false;

        // Java applet used.  
        if (LOCAL_MODE.equals(mode)) {
            viewMode = false;
        } else {
            // Filetree
            viewMode = rootAccess == null || rootAccess.getSecurityLevel() < AclAccess.WRITE.getSecurityLevel();
        }
        return viewMode;

    }

    public Resolution loadMdAsHtml() {

        // Store corresponding (preprocessed) xml doc in session under SESSION_KEY_METADATA_XML
        // when loading md as html. subsequent changes in html are mirrored in this xml doc
        Document mdDoc = null;
     

        try {

            determineRoot(); // select edit or view mode.

            // Java applet is used.
            if (LOCAL_MODE.equals(mode)) {

                // copied stuff from the file_mode part. 

                // metadata contains the string "null" when the following happens.
                // In the java applet a file is selected called X. The javascript then calls a Java applet
                // to read file X.xml. If this succeeds the methode loadAsHtml is called and metadata contains 
                // the xml contents of X.xml. If the applet fails (happens when no .xml exists) method loadMdHtml
                // is also called but this time the variable metadata does not contain XML but the 
                // string "null". Hence this test.
                // 
                if (metadata.equals("null"))  {
                    metadata = DocumentHelper.EMPTY_METADATA;
                }
                if (strictISO19115) {
                    mdDoc = extractMD_MetadataAsDoc(metadata);
                } else {
                    mdDoc = DocumentHelper.getMetadataDocument(metadata);
                }
            } else {
                if (SDE_MODE.equals(mode)) {

                    metadata = ArcSDEHelperProxy.getMetadata(root, path);
                    mdDoc = strictISO19115 ? extractMD_MetadataAsDoc(metadata) : DocumentHelper.getMetadataDocument(metadata);

                } else if (FILE_MODE.equals(mode)) {

                    File mdFile = FileListHelper.getFileForPath(root, path);

                    if (FGDBHelperProxy.isFGDBDirOrInsideFGDBDir(mdFile)) {
                        try {
                            FGDBHelperProxy.cleanerTrackObjectsInCurrentThread();
                            metadata = FGDBHelperProxy.getMetadata(mdFile, esriDTFeatureClass);
                        } finally {
                            FGDBHelperProxy.cleanerReleaseAllInCurrentThread();
                        }
                        mdDoc = strictISO19115 ? extractMD_MetadataAsDoc(metadata) : DocumentHelper.getMetadataDocument(metadata);
                    } else {
                        mdFile = new File(mdFile.getCanonicalPath() + Extensions.METADATA);
                        if (!mdFile.exists()) {
                            // create new metadata on client side or show this in exported file:
                            mdDoc = DocumentHelper.getMetadataDocument(DocumentHelper.EMPTY_METADATA);
                        } else {
                            if (strictISO19115) {
                                mdDoc = extractMD_MetadataAsDoc(mdFile);
                            } else {
                                mdDoc = DocumentHelper.getMetadataDocument(mdFile);
                            }
                        }
                    }
                } else {
                    throw new IllegalArgumentException("Invalid mode: " + mode);
                }
            }

            Document ppDoc = mdeXml2Html.preprocess(mdDoc, determineViewMode());
            //datestamp and uuid added when empty
            mdeXml2Html.addDateStamp(ppDoc, false);
            mdeXml2Html.addUUID(ppDoc, false);
            getContext().getRequest().getSession().setAttribute(SESSION_KEY_METADATA_XML, ppDoc);

            Document htmlDoc = mdeXml2Html.transform(ppDoc, determineViewMode());

            String d = DocumentHelper.getDocumentString(htmlDoc);
            log.debug("serverside rendered html for method loadMdAsHtml: " + d);
            StringReader sr = new StringReader(d);
            return new HtmlResolution(sr, extraHeaders);

        } catch (Exception e) {
            getContext().getRequest().getSession().removeAttribute(SESSION_KEY_METADATA_XML);
            String message = "Kan geen " + mode + " metadata openen van lokatie " + path;
            log.error(message, e);
            return new HtmlErrorResolution(message, e);
        }
    }

    public Resolution resetXml() throws Exception {

        try {

            getContext().getRequest().getSession().removeAttribute(SESSION_KEY_METADATA_XML);
            //create default md doc
            Document md = DocumentHelper.getMetadataDocument("");

            Document ppDoc = mdeXml2Html.preprocess(md);
            //datestamp and uuid added when empty
            mdeXml2Html.addDateStamp(ppDoc, false);
            mdeXml2Html.addUUID(ppDoc, false);
            getContext().getRequest().getSession().setAttribute(SESSION_KEY_METADATA_XML, ppDoc);

            Document htmlDoc = mdeXml2Html.transform(ppDoc);
            String html = DocumentHelper.getDocumentString(htmlDoc);

            log.debug("serverside rendered html after resetting xml: " + html);

            return new HtmlResolution(new StringReader(html), extraHeaders);
        } catch (Exception e) {
            String message = "Fout bij reset document";
            log.error(message, e);
            return new HtmlErrorResolution(message, e);
        }
    }

    public Resolution updateXml() throws Exception {

        try {

            Document md = (Document) getContext().getRequest().getSession().getAttribute(SESSION_KEY_METADATA_XML);
            if (md == null) {
                throw new IllegalStateException("Geen metadatadocument geopend in deze sessie");
            }

            if (elementChanges != null) {
                mdeXml2Html.applyElementChanges(md, new JSONArray(elementChanges));
            }

            if (sectionChange != null) {
                mdeXml2Html.applySectionChange(md, new JSONObject(sectionChange));
            }

            log.debug("serverside xml after updating: " + DocumentHelper.getDocumentString(md));
            Document ppDoc = mdeXml2Html.preprocess(md);

            Boolean synchroniseDC = mdeXml2Html.getXSLParam("synchroniseDC_init");
            if (synchroniseDC != null && synchroniseDC) {
                ppDoc = mdeXml2Html.dCtoISO19115Synchronizer(ppDoc);
                // TODO zijn de volgende syncs nodig?
//                ppDoc = mdeXml2Html.iSO19115toDCSynchronizer(ppDoc);
            }

            getContext().getRequest().getSession().setAttribute(SESSION_KEY_METADATA_XML, ppDoc);

            Document htmlDoc = mdeXml2Html.transform(ppDoc);
            String html = DocumentHelper.getDocumentString(htmlDoc);

            log.debug("serverside rendered html after updating xml: " + html);

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
     */
    public Resolution updateElementsAndGetXml() throws Exception {
        try {
            Document md = (Document) getContext().getRequest().getSession().getAttribute(SESSION_KEY_METADATA_XML);
            if (md == null) {
                throw new IllegalStateException("Geen metadatadocument geopend in deze sessie");
            }

            if (elementChanges != null) {
                mdeXml2Html.applyElementChanges(md, new JSONArray(elementChanges));
            }

            // Bij opslaan kunnen geen section changes zijn gedaan, ook geen
            // preprocessing nodig
            Boolean synchroniseDC = mdeXml2Html.getXSLParam("synchroniseDC_init");
            if (synchroniseDC != null && synchroniseDC) {
                md = mdeXml2Html.dCtoISO19115Synchronizer(md);
                 // TODO zijn de volgende syncs nodig?
//                md = mdeXml2Html.iSO19115toDCSynchronizer(md);
            }

            Boolean serviceMode = mdeXml2Html.getXSLParam("serviceMode_init");
            Boolean datasetMode = mdeXml2Html.getXSLParam("datasetMode_init");
            
            mdeXml2Html.cleanUpMetadata(md, serviceMode == null ? false : serviceMode, datasetMode == null ? false : datasetMode);
            mdeXml2Html.removeEmptyNodes(md);
            
            if (strictISO19115) {
                Document mdCopy = new Document((Element) md.getRootElement().clone());
                Element MD_Metadata = DocumentHelper.getMD_Metadata(mdCopy);
                MD_Metadata.detach();
                md = new Document(MD_Metadata);
            }

            // Geen XML parsing door browser, geef door als String
            return new StreamingResolution("text/plain", new StringReader(DocumentHelper.getDocumentString(md)));
        } catch (Exception e) {
            String message = "Fout bij toepassen wijzigingen op XML document: " + elementChanges + " " + sectionChange;
            log.error(message, e);
            return new HtmlErrorResolution(message, e);
        }
    }

    public Resolution updateAndSaveXml() throws Exception {

        Document md;

        try {

            md = (Document) getContext().getRequest().getSession().getAttribute(SESSION_KEY_METADATA_XML);
            if (md == null) {
                throw new IllegalStateException("Geen metadatadocument geopend in deze sessie");
            }

            if (elementChanges != null) {
                mdeXml2Html.applyElementChanges(md, new JSONArray(elementChanges));
            }

            // Bij opslaan kunnen geen section changes zijn gedaan, ook geen
            // preprocessing nodig
            Boolean synchroniseDC = mdeXml2Html.getXSLParam("synchroniseDC_init");
            if (synchroniseDC != null && synchroniseDC) {
                md = mdeXml2Html.dCtoISO19115Synchronizer(md);
                // TODO zijn de volgende syncs nodig?
//                md = mdeXml2Html.iSO19115toDCSynchronizer(md);
            }

            Boolean serviceMode = mdeXml2Html.getXSLParam("serviceMode_init");
            Boolean datasetMode = mdeXml2Html.getXSLParam("datasetMode_init");
            mdeXml2Html.cleanUpMetadata(md, serviceMode == null ? false : serviceMode, datasetMode == null ? false : datasetMode);

            mdeXml2Html.removeEmptyNodes(md);
        } catch (Exception e) {
            String message = "Fout bij toepassen wijzigingen op XML document: " + elementChanges + " " + sectionChange;
            log.error(message, e);
            return new HtmlErrorResolution(message, e);
        }

        String mdString = DocumentHelper.getDocumentString(md);

        try {
            determineRoot();

            if (rootAccess.getSecurityLevel() < AclAccess.WRITE.getSecurityLevel()) {
                throw new B3PCatalogException("Geen rechten om metadata op te slaan op deze locatie");
            }

            if (SDE_MODE.equals(mode)) {

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

            return new StreamingResolution("text/plain", "success");
        } catch (Exception e) {
            String message = "Could not write " + mode + " metadata to location " + path;
            log.error(message, e);
            return new HtmlErrorResolution(message, e);
        }
    }

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
        Document htmlDoc = mdeXml2Html.transform(md);
        String html = DocumentHelper.getDocumentString(htmlDoc);

        log.debug("serverside rendered html after syncing xml: " + html);

        return new HtmlResolution(new StringReader(html), extraHeaders);
    }


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

            if (SDE_MODE.equals(mode)) {

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

            getContext().getRequest().getSession().setAttribute(SESSION_KEY_METADATA_XML, md);

            Document htmlDoc = mdeXml2Html.transform(md);
            String html = DocumentHelper.getDocumentString(htmlDoc);

            log.debug("serverside rendered html after updating xml: " + html);

            return new HtmlResolution(new StringReader(html), extraHeaders);
        } catch (Exception e) {
            String message = "Fout tijdens synchroniseren " + mode + " metadata van lokatie " + path;
            log.error(message, e);
            return new HtmlErrorResolution(message, e);
        }
    }

    private void synchronizeRegularMetadata(Document xmlDoc, File dataFile) throws IOException, JDOMException {
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

        XPathHelper.applyXPathValuePair(xmlDoc, XPathHelper.TITLE, title);
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

    public Resolution importMD() {

        try {
            Document mdDoc;

            if (importXml != null) {
                mdDoc = new SAXBuilder().build(importXml.getInputStream());
            } else if (metadata != null) {
                mdDoc = DocumentHelper.getMetadataDocument(metadata);
            } else {
                throw new IllegalArgumentException();
            }

            // log.debug("MetadataAction.ImportMD calling mdeXml2Html.preprocess");
            Document ppDoc = mdeXml2Html.preprocess(mdDoc, determineViewMode());
            
            //datestamp and uuid added when empty
            mdeXml2Html.addDateStamp(ppDoc, false);
            mdeXml2Html.addUUID(ppDoc, false);
            getContext().getRequest().getSession().setAttribute(SESSION_KEY_METADATA_XML, ppDoc);

            Document htmlDoc = mdeXml2Html.transform(ppDoc, determineViewMode());

            String d = DocumentHelper.getDocumentString(htmlDoc);

            log.debug("serverside rendered html (for method importdMD): " + d);
            StringReader sr = new StringReader(d);
            return new HtmlResolution(sr, extraHeaders);

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

            Document ppDoc = mdeXml2Html.preprocess(md, determineViewMode());
            log.debug("serverside pp xml after adding comment: " + DocumentHelper.getDocumentString(ppDoc));

            getContext().getRequest().getSession().setAttribute(SESSION_KEY_METADATA_XML, ppDoc);

            Document htmlDoc = mdeXml2Html.transform(ppDoc, determineViewMode());
            String html = DocumentHelper.getDocumentString(htmlDoc);
            log.debug("serverside rendered html after updating xml after adding comment: " + html);

            return new HtmlResolution(new StringReader(html), extraHeaders);

        } catch (Exception e) {
            String message = "Het is niet gelukt om het commentaar (" + comment + ") te posten in " + mode + " op lokatie \"" + path + "\"";
            log.error(message, e);
            return new HtmlErrorResolution(message, e);
        }
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

    public boolean isStrictISO19115() {
        return strictISO19115;
    }

    public void setStrictISO19115(boolean strictISO19115) {
        this.strictISO19115 = strictISO19115;
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
    // </editor-fold>
}
