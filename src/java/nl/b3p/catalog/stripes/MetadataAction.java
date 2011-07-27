/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

package nl.b3p.catalog.stripes;

import java.io.BufferedInputStream;
import java.io.BufferedOutputStream;
import java.io.File;
import java.io.IOException;
import java.io.InputStreamReader;
import java.io.OutputStream;
import java.io.StringReader;
import java.text.DateFormat;
import java.text.SimpleDateFormat;
import java.util.Arrays;
import java.util.Date;
import java.util.HashMap;
import java.util.Map;
import net.sourceforge.stripes.action.Before;
import net.sourceforge.stripes.action.DefaultHandler;
import net.sourceforge.stripes.action.FileBean;
import net.sourceforge.stripes.action.Resolution;
import net.sourceforge.stripes.action.StreamingResolution;
import net.sourceforge.stripes.controller.LifecycleStage;
import net.sourceforge.stripes.controller.StripesRequestWrapper;
import net.sourceforge.stripes.validation.Validate;
import nl.b3p.catalog.B3PCatalogException;
import nl.b3p.catalog.HtmlErrorResolution;
import nl.b3p.catalog.XmlResolution;
import nl.b3p.catalog.arcgis.ArcGISSynchronizer;
import nl.b3p.catalog.arcgis.FGDBHelperProxy;
import nl.b3p.catalog.filetree.Rewrite;
import nl.b3p.catalog.xml.DocumentHelper;
import nl.b3p.catalog.xml.Names;
import nl.b3p.catalog.xml.Namespaces;
import nl.b3p.catalog.xml.XPathHelper;
import org.apache.commons.io.FileUtils;
import org.apache.commons.io.IOUtils;
import org.apache.commons.lang.StringEscapeUtils;
import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.jdom.Content;
import org.jdom.Document;
import org.jdom.Element;
import org.jdom.JDOMException;
import org.jdom.input.SAXBuilder;
import org.jdom.output.Format;
import org.jdom.output.XMLOutputter;

/**
 *
 * @author Erik van de Pol
 */
public class MetadataAction extends DefaultAction {
    private final static Log log = LogFactory.getLog(MetadataAction.class);
    
    private final static String PREPROCESSOR_RELATIVE_PATH = "/scripts/mde/preprocessors/metadataEditorPreprocessor_merged.xsl";

    private final static String METADATA_FILE_EXTENSION = ".xml";
    private final static String SHAPE_FILE_EXTENSION = ".shp";

    //public final static String ROLE_VIEWER = "viewer";
    public final static String ROLE_EDITOR = "editor";


    private final static DateFormat DATETIME_FORMAT = new SimpleDateFormat("yyyy-MM-dd'T'HH:mm:ss");

    @Validate(required=true, on={"!importMD"})
    private String filename;

    @Validate(required=true, on={"!importMD"})
    private int esriType;

    @Validate(required=true, on={"save", "synchronize"})
    private String metadata;

    @Validate(required=true, on="postComment")
    private String comment;

    @Validate(required=true, on="export")
    private boolean strictISO19115 = false;
    
    private FileBean filedata;

    public Resolution load() {
        return getMetadataResolution();
    }

    protected Resolution getMetadataResolution() {
        File mdFile = null;
        try {
            Map<String, String> extraHeaders = new HashMap<String, String>();
            if (!getContext().getRequest().isUserInRole(ROLE_EDITOR))
                extraHeaders.put("MDE_viewMode", "true");

            mdFile = Rewrite.getFileFromPPFileName(filename, getContext());
            if (FGDBHelperProxy.isFGDBDirOrInsideFGDBDir(mdFile)) {
                String md = FGDBHelperProxy.getMetadata(mdFile, esriType);
                if (strictISO19115)
                    return new XmlResolution(extractMD_Metadata(md), extraHeaders);
                else
                    return new XmlResolution(md, extraHeaders);
            } else {
                mdFile = Rewrite.getFileFromPPFileName(filename + METADATA_FILE_EXTENSION, getContext());

                if (!mdFile.exists()) {
                    // create new metadata on client side or show this in exported file:
                    return new XmlResolution("empty", extraHeaders);
                } else {
                    if (strictISO19115)
                        return new XmlResolution(extractMD_Metadata(mdFile), extraHeaders);
                    else
                        return new XmlResolution(new BufferedInputStream(FileUtils.openInputStream(mdFile)), extraHeaders);
                }
            }
        } catch (Exception e) {
            String message = "Could not read file: " + (mdFile == null ? "none" : mdFile.getAbsolutePath());
            log.error(message, e);
            return new HtmlErrorResolution(message, e);
        }
    }

    protected String extractMD_Metadata(String md) throws JDOMException, IOException, B3PCatalogException {
        Document doc = DocumentHelper.getMetadataDocument(md);
        Element MD_Metadata = DocumentHelper.getMD_Metadata(doc);

        MD_Metadata.detach();
        Document extractedDoc = new Document(MD_Metadata);

        return new XMLOutputter(Format.getPrettyFormat()).outputString(extractedDoc);
    }

    protected String extractMD_Metadata(File mdFile) throws JDOMException, IOException, B3PCatalogException {
        Document doc = DocumentHelper.getMetadataDocument(mdFile);
        Element MD_Metadata = DocumentHelper.getMD_Metadata(doc);

        MD_Metadata.detach();
        Document extractedDoc = new Document(MD_Metadata);

        return new XMLOutputter(Format.getPrettyFormat()).outputString(extractedDoc);
    }

    public Resolution save() {
        File mdFile = null;
        try {
            if (!getContext().getRequest().isUserInRole(ROLE_EDITOR))
                throw new B3PCatalogException("Only editors can save metadata files");

            mdFile = Rewrite.getFileFromPPFileName(filename, getContext());
            if (FGDBHelperProxy.isFGDBDirOrInsideFGDBDir(mdFile)) {
                Document oldDoc = DocumentHelper.getMetadataDocument(FGDBHelperProxy.getMetadata(mdFile, esriType));
                Document newDoc = sanitizeComments(oldDoc, metadata);

                String sanitizedMD = new XMLOutputter(Format.getPrettyFormat()).outputString(newDoc);
                FGDBHelperProxy.setMetadata(mdFile, esriType, sanitizedMD);
            } else {
                mdFile = Rewrite.getFileFromPPFileName(filename + METADATA_FILE_EXTENSION, getContext());

                Document oldDoc = DocumentHelper.getMetadataDocument(mdFile);
                Document newDoc = sanitizeComments(oldDoc, metadata);

                OutputStream outputStream = new BufferedOutputStream(FileUtils.openOutputStream(mdFile));
                new XMLOutputter(Format.getPrettyFormat()).output(newDoc, outputStream);
                outputStream.close();
            }
            
            return new StreamingResolution("text/plain", "success");
        } catch (Exception e) {
            String message = "Could not write file: " + (mdFile == null ? "none" : mdFile.getAbsolutePath());
            log.error(message, e);
            return new HtmlErrorResolution(message, e);
        }
    }
    
    public Resolution synchronize() {
        File dataFile = null;
        try {
            dataFile = Rewrite.getFileFromPPFileName(filename, getContext());
            
            log.debug(metadata);
            // metadata string must already have been preprocessed on the clientside
            Document xmlDoc = new SAXBuilder().build(new StringReader(metadata));
            if (FGDBHelperProxy.isFGDBDirOrInsideFGDBDir(dataFile)) {
                // only instantiate ArcGISSynchronizer here, since a NoClassDefFoundError can occur if ArcGIS is not installed / incorrectly installed
                ArcGISSynchronizer arcGISSynchronizer = new ArcGISSynchronizer();
                arcGISSynchronizer.synchronizeFGDB(xmlDoc, dataFile, esriType);
            } else if (filename.endsWith(SHAPE_FILE_EXTENSION)) {
                try {
                    // only instantiate ArcGISSynchronizer here, since a NoClassDefFoundError can occur if ArcGIS is not installed / incorrectly installed
                    ArcGISSynchronizer arcGISSynchronizer = new ArcGISSynchronizer();
                    arcGISSynchronizer.synchronizeShapeFile(xmlDoc, dataFile);
                } catch(NoClassDefFoundError ncdfe) {
                    // ArcGIS not installed / incorrectly installed
                    synchronizeRegularMetadata(xmlDoc);
                }
            } else {
                synchronizeRegularMetadata(xmlDoc);
            }
            return new XmlResolution(xmlDoc);
        } catch (NoClassDefFoundError e) {
            String message = "Could not synchronize file: " + (dataFile == null ? "none" : dataFile.getAbsolutePath());
            log.error(message, e);
            return new HtmlErrorResolution(message);
        } catch (Exception e) {
            String message = "Could not synchronize file: " + (dataFile == null ? "none" : dataFile.getAbsolutePath());
            log.error(message, e);
            return new HtmlErrorResolution(message, e);
        }
    }
    
    private void synchronizeRegularMetadata(Document xmlDoc) throws IOException, JDOMException {
        String title = filename.substring(1 + filename.lastIndexOf(Rewrite.PRETTY_DIR_SEPARATOR));
        int dotIndex = title.lastIndexOf(".");
        if (dotIndex > 0) {
            title = title.substring(0, dotIndex);
        } else if (dotIndex == 0) {
            title = title.substring(1);
        }
        XPathHelper.applyXPathValuePair(xmlDoc, XPathHelper.TITLE, title);
        
        XPathHelper.applyXPathValuePair(xmlDoc, XPathHelper.URL_DATASET, Rewrite.getFileNameFromPPFileName(filename, getContext()));
        XPathHelper.applyXPathValuePair(xmlDoc, XPathHelper.NAME_DATASET, "");
        XPathHelper.applyXPathValuePair(xmlDoc, XPathHelper.PROTOCOL_DATASET, "download");
        XPathHelper.applyXPathValuePair(xmlDoc, XPathHelper.DESC_DATASET, "");
        
        //TODO: file type in md opslaan?
    }
    
    @SuppressWarnings("unused")
    @Before(stages = LifecycleStage.BindingAndValidation)
    private void rehydrate() {
        log.debug("in rehydrate");
        StripesRequestWrapper req = StripesRequestWrapper.findStripesWrapper(getContext().getRequest());
        try {
            if (req.isMultipart()) {
                filedata = req.getFileParameterValue("uploader");
            }
        } catch (Exception e) {
            log.error(e.getMessage(), e);
        }
    }
    
    @DefaultHandler
    public Resolution importMD() {
        log.debug("in importMD");
        try {
            if (filedata == null) {
                throw new Exception("Error during file upload.");
            }
            //return new XmlResolution(filedata.getInputStream());
            String xml = IOUtils.toString(filedata.getInputStream(), "UTF-8");
            // jquery form plugin extracts the value from the textarea. unescaping done afterwards in js success callback
            String hackhackXml = "<textarea>" + StringEscapeUtils.escapeXml(xml) + "</textarea>";
            // must be text/html for IE
            StreamingResolution sr = new StreamingResolution("text/html", hackhackXml);
            sr.setCharacterEncoding("UTF-8");
            return sr;
        } catch(Exception e) {
            String message = "Could not import file.";
            log.error(message, e);
            return new HtmlErrorResolution(message, e);
        }
    }

    public Resolution export() {
        Resolution resolution = getMetadataResolution();
        if (resolution instanceof XmlResolution) {
            String exportName = null;
            try {
                File file = Rewrite.getFileFromPPFileName(filename, getContext());
                exportName = file.getName();
                if (!exportName.endsWith(".xml"))
                    exportName = exportName + ".xml";
            } catch (IOException ex) {
                exportName = "metadata.xml";
            }
            XmlResolution xmlResolution = (XmlResolution)resolution;
            xmlResolution.setAttachment(true);
            xmlResolution.setFilename(exportName);
        }
        return resolution;
    }

    // Comments can be posted by anyone to any ".xml"-file that is a descendant of one of the roots.
    // that has <metadata/> or <gmd:MD_Metadata/> as root. This is by design.
    public Resolution postComment() {
        try {
            File mdFile = Rewrite.getFileFromPPFileName(filename, getContext());
            if (FGDBHelperProxy.isFGDBDirOrInsideFGDBDir(mdFile)) {
                Document doc = DocumentHelper.getMetadataDocument(FGDBHelperProxy.getMetadata(mdFile, esriType));

                addComment(doc, comment);

                String commentedMD = new XMLOutputter(Format.getPrettyFormat()).outputString(doc);
                FGDBHelperProxy.setMetadata(mdFile, esriType, commentedMD);

                return new XmlResolution(commentedMD);
            } else {
                mdFile = Rewrite.getFileFromPPFileName(filename + METADATA_FILE_EXTENSION, getContext());

                Document doc = DocumentHelper.getMetadataDocument(mdFile);

                addComment(doc, comment);

                OutputStream outputStream = new BufferedOutputStream(FileUtils.openOutputStream(mdFile));
                new XMLOutputter(Format.getPrettyFormat()).output(doc, outputStream);
                outputStream.close();

                return new XmlResolution(new BufferedInputStream(FileUtils.openInputStream(mdFile)));
            }
        } catch(Exception e) {
            String message = "Het is niet gelukt om het commentaar (" + comment + ") te posten in file \"" + filename + METADATA_FILE_EXTENSION + "\"";
            log.error(message, e);
            return new HtmlErrorResolution(message, e);
        }
    }

    /**
     * replace sent comments with (safe, untampered) comments on disk.
     */
    protected Document sanitizeComments(Document oldDoc, String md) throws Exception {
        Element comments = DocumentHelper.getComments(oldDoc);
        if (comments == null)
            throw new B3PCatalogException("Xml Document is non-metadata xml. This is not allowed.");
        Content safeComments = comments.detach();
        //log.debug("metadata1:\n\n" + md);
        Document doc = new SAXBuilder().build(new StringReader(md));
        //log.debug("metadata2:\n\n" + new XMLOutputter().outputString(doc));
        Element unsafeComments = DocumentHelper.getComments(doc);
        if (comments == null)
            throw new B3PCatalogException("Xml Document is non-metadata xml. This is not allowed.");
        Element b3pElem = unsafeComments.getParentElement();
        b3pElem.removeContent(unsafeComments);
        b3pElem.addContent(safeComments);

        return doc;
    }

    private void addComment(Document doc, String comment) throws B3PCatalogException {
        Element comments = DocumentHelper.getComments(doc);
        if (comments == null)
            throw new B3PCatalogException("Xml Document is non-metadata xml. This is not allowed.");

        Element newComment = new Element(Names.COMMENT, Namespaces.B3P).addContent(Arrays.asList(
            new Element(Names.USERNAME, Namespaces.B3P).setText(getContext().getRequest().getRemoteUser()),
            new Element(Names.DATE_TIME, Namespaces.B3P).setText(DATETIME_FORMAT.format(new Date())),
            new Element(Names.CONTENT, Namespaces.B3P).setText(comment)
        ));
        comments.addContent(newComment);
    }
    
    public String getFilename() {
        return filename;
    }

    public void setFilename(String filename) {
        this.filename = filename;
    }

    public int getEsriType() {
        return esriType;
    }

    public void setEsriType(int esriType) {
        this.esriType = esriType;
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

}
