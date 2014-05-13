package nl.b3p.catalog.stripes;

import java.io.BufferedInputStream;
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
import nl.b3p.catalog.config.*;
import nl.b3p.catalog.filetree.Extensions;
import nl.b3p.catalog.filetree.FileListHelper;
import nl.b3p.catalog.resolution.HtmlErrorResolution;
import nl.b3p.catalog.resolution.HtmlResolution;
import nl.b3p.catalog.resolution.XmlResolution;
import nl.b3p.catalog.xml.*;
import org.apache.commons.io.FileUtils;
import org.apache.commons.io.IOUtils;
import org.apache.commons.lang.StringEscapeUtils;
import org.apache.commons.lang.StringUtils;
import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.jdom.Content;
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

    private static final String SESSION_KEY_METADATA_XML = MetadataAction.class.getName() + ".METADATA_XML";
    
    private final static DateFormat DATETIME_FORMAT = new SimpleDateFormat("yyyy-MM-dd'T'HH:mm:ss");

    /* XXX niet nodig omdat objecten van verschillende types toch niet dezelfde
     * naam mogen hebben...
     */
    private static final int esriDTFeatureClass = 5; /* esriDatasetType */

    @Validate(required = true, on = {"!importMD","!updateXml"})
    private String path;

    @Validate(required = true, on = {"!importMD","!updateXml"})
    private String mode;

    @Validate(required = true, on = {"save", "synchronize"})
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
    @Validate(on="updateXml")
    private String elementChanges;
    
    /* JSON with info about requested section addition or deletion. */
    @Validate(on="updateXml")
    private String sectionChange;
    
    private Root root;
    private AclAccess rootAccess;
    private Map<String, String> extraHeaders = new HashMap<String, String>();

    public void determineRoot() throws B3PCatalogException {
        root = Root.getRootForPath(path, getContext().getRequest(), AclAccess.READ);
        rootAccess = root.getRequestUserHighestAccessLevel(getContext().getRequest());
        extraHeaders.put("X-MDE-Access", rootAccess.name());
    }

    public Resolution load() {

        try {
            if (LOCAL_MODE.equals(mode)) {
                return new XmlResolution(strictISO19115 ? extractMD_Metadata(metadata) : metadata);
            }
            determineRoot();

            if (SDE_MODE.equals(mode)) {

                metadata = ArcSDEHelperProxy.getMetadata(root, path);
                return new XmlResolution(strictISO19115 ? extractMD_Metadata(metadata) : metadata, extraHeaders);

            } else if (FILE_MODE.equals(mode)) {

                File mdFile = FileListHelper.getFileForPath(root, path);

                if (FGDBHelperProxy.isFGDBDirOrInsideFGDBDir(mdFile)) {
                    try {
                        FGDBHelperProxy.cleanerTrackObjectsInCurrentThread();
                        metadata = FGDBHelperProxy.getMetadata(mdFile, esriDTFeatureClass);
                    } finally {
                        FGDBHelperProxy.cleanerReleaseAllInCurrentThread();
                    }
                    return new XmlResolution(strictISO19115 ? extractMD_Metadata(metadata) : metadata, extraHeaders);
                } else {
                    mdFile = new File(mdFile.getCanonicalPath() + Extensions.METADATA);
                    if (!mdFile.exists()) {
                        // create new metadata on client side or show this in exported file:
                        return new XmlResolution(DocumentHelper.EMPTY_METADATA, extraHeaders);
                    } else {
                        if (strictISO19115) {
                            return new XmlResolution(extractMD_Metadata(mdFile), extraHeaders);
                        } else {
                            return new XmlResolution(new BufferedInputStream(FileUtils.openInputStream(mdFile)), extraHeaders);
                        }
                    }
                }
            } else {
                throw new IllegalArgumentException("Invalid mode: " + mode);
            }
        } catch (Exception e) {
            String message = "Kan geen " + mode + " metadata openen van lokatie " + path;
            log.error(message, e);
            return new HtmlErrorResolution(message, e);
        }
    }

    public Resolution loadMdAsHtml() {

        // store corresponding (preprocessed) xml doc in session under SESSION_KEY_METADATA_XML
        // when loading md as html 
        // subsequent changes in html are mirrored in this xml doc
        
        Document mdDoc = null;

        try {
            if (LOCAL_MODE.equals(mode)) {
                mdDoc = strictISO19115 ? extractMD_MetadataAsDoc(metadata) : DocumentHelper.getMetadataDocument(metadata);
            } else {
                determineRoot();

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
            
            Document ppDoc = mdeXml2Html.preprocess(mdDoc);
            getContext().getRequest().getSession().setAttribute(SESSION_KEY_METADATA_XML, ppDoc);
            
            Document htmlDoc = mdeXml2Html.transform(ppDoc);
            // this._addDateStamp(this.xmlDoc); 

            String d = DocumentHelper.getDocumentString(htmlDoc);
            log.debug("serverside rendered html: " + d);
            StringReader sr = new StringReader(d);
            return new HtmlResolution(sr);

        } catch (Exception e) {
            getContext().getRequest().getSession().removeAttribute(SESSION_KEY_METADATA_XML);
            String message = "Kan geen " + mode + " metadata openen van lokatie " + path;
            log.error(message, e);
            return new HtmlErrorResolution(message, e);
        }
    }
    
    public Resolution updateXml() throws Exception {
        
        try {

            Document md = (Document)getContext().getRequest().getSession().getAttribute(SESSION_KEY_METADATA_XML);            
            if(md == null) {
                throw new IllegalStateException("Geen metadatadocument geopend in deze sessie");
            }
            
            if(elementChanges != null) {
                mdeXml2Html.applyElementChanges(md, new JSONArray(elementChanges));
            }
            
            if(sectionChange != null) {
                mdeXml2Html.applySectionChange(md, new JSONObject(sectionChange));
            }
            
            log.debug("serverside xml after updating: " + DocumentHelper.getDocumentString(md));            
            Document ppDoc = mdeXml2Html.preprocess(md);
            getContext().getRequest().getSession().setAttribute(SESSION_KEY_METADATA_XML, ppDoc);            
            
            Document htmlDoc = mdeXml2Html.transform(ppDoc);        
            String html = DocumentHelper.getDocumentString(htmlDoc);

            log.debug("serverside rendered html after updating xml: " + html);            
            
            return new HtmlResolution(new StringReader(html));
        } catch(Exception e) {
            String message = "Fout bij toepassen wijzigingen op XML document: " + elementChanges + " " + sectionChange;
            log.error(message, e);
            return new HtmlErrorResolution(message, e);
        }
    }
    
    /**
     * Past wijzigingen toe en geeft XML terug zodat lokaal kan worden opgeslagen
     * door local-access-servlet.
     */
    public Resolution updateElementsAndGetXml() throws Exception {
        try {
            Document md = (Document)getContext().getRequest().getSession().getAttribute(SESSION_KEY_METADATA_XML);            
            if(md == null) {
                throw new IllegalStateException("Geen metadatadocument geopend in deze sessie");
            }
            
            if(elementChanges != null) {
                mdeXml2Html.applyElementChanges(md, new JSONArray(elementChanges));
            }

            // Bij opslaan kunnen geen section changes zijn gedaan, ook geen
            // preprocessing nodig
            
            // TODO: mdeXml2Html.cleanUpMetadata(md, serviceMode, datasetMode);
            
            // BUG: java.util.ConcurrentModificationException
            //mdeXml2Html.removeEmptyNodes(md);

            // Geen XML parsing door browser, geef door als String
            return new StreamingResolution("text/plain", new StringReader(DocumentHelper.getDocumentString(md)));
        } catch(Exception e) {
            String message = "Fout bij toepassen wijzigingen op XML document: " + elementChanges + " " + sectionChange;
            log.error(message, e);
            return new HtmlErrorResolution(message, e);
        }
    }
    
    public Resolution updateAndSaveXml() throws Exception {
        
        Document md;
        
        try {

            md = (Document)getContext().getRequest().getSession().getAttribute(SESSION_KEY_METADATA_XML);            
            if(md == null) {
                throw new IllegalStateException("Geen metadatadocument geopend in deze sessie");
            }
            
            if(elementChanges != null) {
                mdeXml2Html.applyElementChanges(md, new JSONArray(elementChanges));
            }

            // Bij opslaan kunnen geen section changes zijn gedaan, ook geen
            // preprocessing nodig
            
            // BUG: java.util.ConcurrentModificationException
            //mdeXml2Html.removeEmptyNodes(md);
        } catch(Exception e) {
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
                String oldMetadata = ArcSDEHelperProxy.getMetadata(dataset);
                ArcSDEHelperProxy.saveMetadata(dataset, sanitizeComments(oldMetadata, mdString));

            } else if (FILE_MODE.equals(mode)) {

                File mdFile = FileListHelper.getFileForPath(root, path);

                if (FGDBHelperProxy.isFGDBDirOrInsideFGDBDir(mdFile)) {
                    try {
                        FGDBHelperProxy.cleanerTrackObjectsInCurrentThread();
                        String oldMetadata = FGDBHelperProxy.getMetadata(mdFile, esriDTFeatureClass);
                        FGDBHelperProxy.setMetadata(mdFile, 5, sanitizeComments(oldMetadata, mdString));
                    } finally {
                        FGDBHelperProxy.cleanerReleaseAllInCurrentThread();
                    }
                } else {
                    mdFile = new File(mdFile.getCanonicalPath() + Extensions.METADATA);

                    Document oldMetadata = DocumentHelper.getMetadataDocument(mdFile);
                    mdString = sanitizeComments(oldMetadata, mdString);

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

    public Resolution save() {
        try {
            determineRoot();

            if (rootAccess.getSecurityLevel() < AclAccess.WRITE.getSecurityLevel()) {
                throw new B3PCatalogException("Geen rechten om metadata op te slaan op deze locatie");
            }

//            Document toBeSavedXmlDoc = DocumentHelper.getMetadataDocument(metadata);
//            boolean synchroniseDC = false;
//            if (synchroniseDC) {
//                toBeSavedXmlDoc = mdeXml2Html.dCtoISO19115Synchronizer(toBeSavedXmlDoc);
//            }
//            
//            boolean serviceMode = true;
//            boolean datasetMode = false;
//            mdeXml2Html.cleanUpMetadata(toBeSavedXmlDoc, serviceMode, datasetMode);
//            mdeXml2Html.removeEmptyNodes(toBeSavedXmlDoc);

          
            if (SDE_MODE.equals(mode)) {

                Object dataset = ArcSDEHelperProxy.getDataset(root, path);
                String oldMetadata = ArcSDEHelperProxy.getMetadata(dataset);
                ArcSDEHelperProxy.saveMetadata(dataset, sanitizeComments(oldMetadata, metadata));

            } else if (FILE_MODE.equals(mode)) {

                File mdFile = FileListHelper.getFileForPath(root, path);

                if (FGDBHelperProxy.isFGDBDirOrInsideFGDBDir(mdFile)) {
                    try {
                        FGDBHelperProxy.cleanerTrackObjectsInCurrentThread();
                        String oldMetadata = FGDBHelperProxy.getMetadata(mdFile, esriDTFeatureClass);
                        FGDBHelperProxy.setMetadata(mdFile, 5, sanitizeComments(oldMetadata, metadata));
                    } finally {
                        FGDBHelperProxy.cleanerReleaseAllInCurrentThread();
                    }
                } else {
                    mdFile = new File(mdFile.getCanonicalPath() + Extensions.METADATA);

                    Document oldMetadata = DocumentHelper.getMetadataDocument(mdFile);
                    metadata = sanitizeComments(oldMetadata, metadata);

                    OutputStream outputStream = new BufferedOutputStream(FileUtils.openOutputStream(mdFile));
                    outputStream.write(metadata.getBytes("UTF-8"));
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
        // metadata string must already have been preprocessed on the clientside
        Document doc = new SAXBuilder().build(new StringReader(metadata));

        if (path.toLowerCase().endsWith(".shp.xml")) {

            ShapefileSynchronizer.synchronizeFromLocalAccessJSON(doc, synchronizeData);

        } else if (path.toLowerCase().endsWith(".nc.xml")) {

            doc = NCMLSynchronizer.synchronizeNCML(doc, synchronizeData);
        }
        return new XmlResolution(doc);
    }

    public Resolution synchronize() {

        try {

            if (LOCAL_MODE.equals(mode)) {
                return synchronizeLocal();
            }

            determineRoot();

            // metadata string must already have been preprocessed on the clientside
            Document xmlDoc = new SAXBuilder().build(new StringReader(metadata));

            if (SDE_MODE.equals(mode)) {

                Object dataset = ArcSDEHelperProxy.getDataset(root, path);

                if (dataset instanceof ArcSDEJDBCDataset) {

                    ArcObjectsConfig cfg = CatalogAppConfig.getConfig().getArcObjectsConfig();

                    if (cfg.isEnabled()) {
                        dataset = ArcSDEHelperProxy.getArcObjectsDataset(root, path);
                        ArcGISSynchronizer.synchronize(xmlDoc, dataset, ArcGISSynchronizer.FORMAT_NAME_SDE);
                    } else if (cfg.isForkSynchroniser()) {
                        ArcSDEJDBCDataset ds = (ArcSDEJDBCDataset) dataset;

                        if (ds.getRoot().getArcobjectsConnection() == null) {
                            throw new Exception("ArcObjects niet geconfigureerd, synchroniseren niet mogelijk");
                        }
                        xmlDoc = ArcObjectsSynchronizerForker.synchronize(
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
                    ArcGISSynchronizer.synchronize(xmlDoc, dataset, ArcGISSynchronizer.FORMAT_NAME_SDE);
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
                            ArcGISSynchronizer.synchronize(xmlDoc, ds, ArcGISSynchronizer.FORMAT_NAME_FGDB);
                        } finally {
                            FGDBHelperProxy.cleanerReleaseAllInCurrentThread();
                        }
                    } else if (path.endsWith(Extensions.SHAPE)) {
                        try {
                            FGDBHelperProxy.cleanerTrackObjectsInCurrentThread();

                            Object ds = DatasetHelperProxy.getShapeDataset(dataFile);
                            ArcGISSynchronizer.synchronize(xmlDoc, ds, ArcGISSynchronizer.FORMAT_NAME_SHAPE);
                        } finally {
                            FGDBHelperProxy.cleanerReleaseAllInCurrentThread();
                        }
                    } else {
                        synchronizeRegularMetadata(xmlDoc, dataFile);
                    }
                } else if (cfg.isForkSynchroniser()) {
                    xmlDoc = ArcObjectsSynchronizerForker.synchronize(
                            getContext().getServletContext(),
                            FileListHelper.getFileForPath(root, path).getAbsolutePath(),
                            isFGDB ? ArcObjectsSynchronizerMain.TYPE_FGDB : ArcObjectsSynchronizerMain.TYPE_SHAPE,
                            null,
                            metadata
                    );
                }
            } else {
                throw new IllegalArgumentException("Invalid mode: " + mode);
            }
            return new XmlResolution(xmlDoc);
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
        log.debug("in importMD");
        try {
            //return new XmlResolution(filedata.getInputStream());
            String xml = IOUtils.toString(importXml.getInputStream(), "UTF-8");
            // jquery form plugin extracts the value from the textarea. unescaping done afterwards in js success callback
            String hackhackXml = "<textarea>" + StringEscapeUtils.escapeXml(xml) + "</textarea>";
            // must be text/html for IE
            StreamingResolution sr = new StreamingResolution("text/html", hackhackXml);
            sr.setCharacterEncoding("UTF-8");
            return sr;
        } catch (Exception e) {
            String message = "Could not import file.";
            log.error(message, e);
            return new HtmlErrorResolution(message, e);
        }
    }

    public Resolution export() {
        Resolution resolution = load();
        if (resolution instanceof XmlResolution) {
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
            XmlResolution xmlResolution = (XmlResolution) resolution;
            xmlResolution.setAttachment(true);
            xmlResolution.setFilename(exportName);
        }
        return resolution;
    }

    // Comments can be posted by anyone to any ".xml"-file that is a descendant of one of the roots.
    // that has <metadata/> or <gmd:MD_Metadata/> as root. This is by design.
    public Resolution postComment() {
        try {
            if (LOCAL_MODE.equals(mode)) {
                Document doc = DocumentHelper.getMetadataDocument(metadata);
                addComment(doc, comment);
                String commentedMD = DocumentHelper.getDocumentString(doc);
                return new XmlResolution(commentedMD);
            }

            determineRoot();

            if (rootAccess.getSecurityLevel() < AclAccess.COMMENT.getSecurityLevel()) {
                throw new B3PCatalogException("Geen rechten om commentaar aan metadata toe te voegen op deze locatie");
            }

            if (SDE_MODE.equals(mode)) {
                Object dataset = ArcSDEHelperProxy.getDataset(root, path);

                Document doc = DocumentHelper.getMetadataDocument(ArcSDEHelperProxy.getMetadata(dataset));
                addComment(doc, comment);
                String commentedMD = DocumentHelper.getDocumentString(doc);
                ArcSDEHelperProxy.saveMetadata(dataset, commentedMD);
                return new XmlResolution(commentedMD);
            } else if (FILE_MODE.equals(mode)) {

                File mdFile = FileListHelper.getFileForPath(root, path);

                if (FGDBHelperProxy.isFGDBDirOrInsideFGDBDir(mdFile)) {
                    try {
                        FGDBHelperProxy.cleanerTrackObjectsInCurrentThread();

                        Document doc = DocumentHelper.getMetadataDocument(FGDBHelperProxy.getMetadata(mdFile, esriDTFeatureClass));

                        addComment(doc, comment);

                        String commentedMD = DocumentHelper.getDocumentString(doc);
                        FGDBHelperProxy.setMetadata(mdFile, esriDTFeatureClass, commentedMD);

                        return new XmlResolution(commentedMD);
                    } finally {
                        FGDBHelperProxy.cleanerReleaseAllInCurrentThread();
                    }
                } else {
                    mdFile = new File(mdFile.getCanonicalPath() + Extensions.METADATA);

                    Document doc = DocumentHelper.getMetadataDocument(mdFile);

                    addComment(doc, comment);

                    OutputStream outputStream = new BufferedOutputStream(FileUtils.openOutputStream(mdFile));
                    new XMLOutputter(Format.getPrettyFormat()).output(doc, outputStream);
                    outputStream.close();

                    return new XmlResolution(new BufferedInputStream(FileUtils.openInputStream(mdFile)));
                }
            } else {
                throw new IllegalArgumentException("Invalid mode: " + mode);
            }
        } catch (Exception e) {
            String message = "Het is niet gelukt om het commentaar (" + comment + ") te posten in " + mode + " op lokatie \"" + path + "\"";
            log.error(message, e);
            return new HtmlErrorResolution(message, e);
        }
    }

    protected Document extractMD_MetadataAsDoc(String md) throws JDOMException, IOException, B3PCatalogException {
        Document doc = DocumentHelper.getMetadataDocument(md);
        Element MD_Metadata = DocumentHelper.getMD_Metadata(doc);

        MD_Metadata.detach();
        Document extractedDoc = new Document(MD_Metadata);

        return extractedDoc;
    }

    protected String extractMD_Metadata(String md) throws JDOMException, IOException, B3PCatalogException {
        Document extractedDoc = extractMD_MetadataAsDoc(md);

        return new XMLOutputter(Format.getPrettyFormat()).outputString(extractedDoc);
    }

    protected Document extractMD_MetadataAsDoc(File mdFile) throws JDOMException, IOException, B3PCatalogException {
        Document doc = DocumentHelper.getMetadataDocument(mdFile);
        Element MD_Metadata = DocumentHelper.getMD_Metadata(doc);

        MD_Metadata.detach();
        Document extractedDoc = new Document(MD_Metadata);

        return extractedDoc;
    }

    protected String extractMD_Metadata(File mdFile) throws JDOMException, IOException, B3PCatalogException {
        Document extractedDoc = extractMD_MetadataAsDoc(mdFile);

        return new XMLOutputter(Format.getPrettyFormat()).outputString(extractedDoc);
    }

    /**
     * replace sent comments with (safe, untampered) comments on disk.
     */
    protected String sanitizeComments(Document oldDoc, String md) throws Exception {
        Element comments = DocumentHelper.getComments(oldDoc);
        if (comments == null) {
            throw new B3PCatalogException("Xml Document is non-metadata xml. This is not allowed.");
        }
        Content safeComments = comments.detach();
        //log.debug("metadata1:\n\n" + md);
        Document doc = new SAXBuilder().build(new StringReader(md));
        //log.debug("metadata2:\n\n" + new XMLOutputter().outputString(doc));
        Element unsafeComments = DocumentHelper.getComments(doc);
        if (comments == null) {
            throw new B3PCatalogException("Xml Document is non-metadata xml. This is not allowed.");
        }
        Element b3pElem = unsafeComments.getParentElement();
        b3pElem.removeContent(unsafeComments);
        b3pElem.addContent(safeComments);

        return new XMLOutputter(Format.getPrettyFormat()).outputString(doc);
    }

    protected String sanitizeComments(String oldDoc, String md) throws Exception {
        return sanitizeComments(DocumentHelper.getMetadataDocument(oldDoc), md);
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
