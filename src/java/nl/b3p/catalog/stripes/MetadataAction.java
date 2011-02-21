/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

package nl.b3p.catalog.stripes;

import java.io.BufferedInputStream;
import java.io.BufferedOutputStream;
import java.io.File;
import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStream;
import java.io.StringReader;
import java.text.DateFormat;
import java.text.SimpleDateFormat;
import java.util.Arrays;
import java.util.Date;
import java.util.HashMap;
import java.util.Map;
import net.sourceforge.stripes.action.Resolution;
import net.sourceforge.stripes.action.StreamingResolution;
import net.sourceforge.stripes.validation.Validate;
import nl.b3p.catalog.B3PCatalogException;
import nl.b3p.catalog.HtmlErrorResolution;
import nl.b3p.catalog.XmlResolution;
import nl.b3p.catalog.filetree.Rewrite;
import org.apache.commons.io.FileUtils;
import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.jdom.Content;
import org.jdom.Document;
import org.jdom.Element;
import org.jdom.JDOMException;
import org.jdom.Namespace;
import org.jdom.input.SAXBuilder;
import org.jdom.output.Format;
import org.jdom.output.XMLOutputter;

/**
 *
 * @author Erik van de Pol
 */
public class MetadataAction extends DefaultAction {
    private final static Log log = LogFactory.getLog(MetadataAction.class);

    private final static String METADATA_FILE_EXTENSION = ".xml";

    private final static Namespace GMD_NAMESPACE = Namespace.getNamespace("gmd", "http://www.isotc211.org/2005/gmd");
    private final static Namespace B3P_NAMESPACE = Namespace.getNamespace("b3p", "http://www.b3partners.nl/xsd/metadata");

    private final static String METADATA_NAME = "metadata";
    private final static String MD_METADATA_NAME = "MD_Metadata";
    private final static String B3PARTNERS_NAME = "B3Partners";
    private final static String COMMENTS_NAME = "comments";
    private final static String COMMENT_NAME = "comment";
    private final static String USERNAME_NAME = "username";
    private final static String DATE_TIME_NAME = "dateTime";
    private final static String CONTENT_NAME = "content";
    private final static String METADATA_PBL_NAME = "metadataPBL";

    //public final static String ROLE_VIEWER = "viewer";
    public final static String ROLE_EDITOR = "editor";


    private final static DateFormat DATETIME_FORMAT = new SimpleDateFormat("yyyy-MM-dd'T'HH:mm:ss");

    @Validate(required=true)
    private String filename;

    @Validate(required=true, on="save")
    private String metadata;

    @Validate(required=true, on="postComment")
    private String comment;

    public Resolution load() {
        File mdFile = null;
        try {
            //if (!getContext().getRequest().isUserInRole(ROLE_VIEWER))
            //    throw new B3PCatalogException("Only viewers can view metadata files");

            Map<String, String> extraHeaders = new HashMap<String, String>();
            if (!getContext().getRequest().isUserInRole(ROLE_EDITOR))
                extraHeaders.put("MDE_viewMode", "true");

            mdFile = Rewrite.getFileFromPPFileName(filename + METADATA_FILE_EXTENSION, getContext());
            if (!mdFile.exists()) {
                // create new metadata on client side:
                return new XmlResolution("empty", extraHeaders);
            } else {
                return new XmlResolution(new BufferedInputStream(FileUtils.openInputStream(mdFile)), extraHeaders);
            }
        } catch (Exception e) {
            String message = "Could not read file: " + (mdFile == null ? "none" : mdFile.getAbsolutePath());
            log.error(message, e);
            return new HtmlErrorResolution(message, e);
        }
    }

    public Resolution save() {
        File mdFile = null;
        try {
            if (!getContext().getRequest().isUserInRole(ROLE_EDITOR))
                throw new B3PCatalogException("Only editors can save metadata files");

            mdFile = Rewrite.getFileFromPPFileName(filename + METADATA_FILE_EXTENSION, getContext());

            // replace sent comments with (safe, untampered) comments on disk.
            Document oldDoc = getMetadataDocument(mdFile);

            Element comments = getComments(oldDoc);
            if (comments == null)
                throw new B3PCatalogException("Xml Document is non-metadata xml. This is not allowed.");
            Content safeComments = comments.detach();

            Document doc = new SAXBuilder().build(new StringReader(metadata));
            Element unsafeComments = getComments(doc);
            if (comments == null)
                throw new B3PCatalogException("Xml Document is non-metadata xml. This is not allowed.");
            Element b3pElem = unsafeComments.getParentElement();
            b3pElem.removeContent(unsafeComments);
            b3pElem.addContent(safeComments);

            OutputStream outputStream = new BufferedOutputStream(FileUtils.openOutputStream(mdFile));
            new XMLOutputter(Format.getPrettyFormat()).output(doc, outputStream);
            outputStream.close();
            
            return new StreamingResolution("text/plain", "success");
        } catch (Exception e) {
            String message = "Could not write file: " + (mdFile == null ? "none" : mdFile.getAbsolutePath());
            log.error(message, e);
            return new HtmlErrorResolution(message, e);
        }
    }

    // Comments can be posted by anyone to any ".xml"-file that is a descendant of one of the roots.
    // that has <metadata/> or <gmd:MD_Metadata/> as root. This is by design.
    public Resolution postComment() {
        try {
            if (/*!getContext().getRequest().isUserInRole(ROLE_VIEWER) &&*/
                !getContext().getRequest().isUserInRole(ROLE_EDITOR))
                throw new B3PCatalogException("Only viewers or editors can pos comments in metadata files");

            File mdFile = Rewrite.getFileFromPPFileName(filename + METADATA_FILE_EXTENSION, getContext());

            Document doc = getMetadataDocument(mdFile);

            Element comments = getComments(doc);
            if (comments == null)
                throw new B3PCatalogException("Xml Document is non-metadata xml. This is not allowed.");

            Element newComment = new Element(COMMENT_NAME, B3P_NAMESPACE).addContent(Arrays.asList(
                new Element(USERNAME_NAME, B3P_NAMESPACE).setText(getContext().getRequest().getRemoteUser()),
                new Element(DATE_TIME_NAME, B3P_NAMESPACE).setText(DATETIME_FORMAT.format(new Date())),
                new Element(CONTENT_NAME, B3P_NAMESPACE).setText(comment)
            ));
            comments.addContent(newComment);

            OutputStream outputStream = new BufferedOutputStream(FileUtils.openOutputStream(mdFile));
            new XMLOutputter(Format.getPrettyFormat()).output(doc, outputStream);
            outputStream.close();

            return new XmlResolution(new BufferedInputStream(FileUtils.openInputStream(mdFile)));
        } catch(Exception e) {
            String message = "Het is niet gelukt om het commentaar (" + comment + ") te posten in file \"" + filename + METADATA_FILE_EXTENSION + "\"";
            log.error(message, e);
            return new HtmlErrorResolution(message, e);
        }
    }

    private Document getMetadataDocument(File mdFile) throws IOException, JDOMException, B3PCatalogException {
        if (mdFile == null)
            throw new B3PCatalogException("Metadata file is null.");
        Document doc = null;
        if (mdFile.exists()) {
            InputStream inputStream = new BufferedInputStream(FileUtils.openInputStream(mdFile));
            doc = new SAXBuilder().build(inputStream);
            inputStream.close();
        } else {
            doc = new Document(new Element(METADATA_NAME));
        }
        return doc;
    }

    private Element getRoot(Document doc) throws B3PCatalogException {
        if (doc == null)
            throw new B3PCatalogException("Metadata document is null.");
        Element root = doc.getRootElement();

        boolean rootIsWrapper = root.getName().equals(METADATA_NAME) && root.getNamespace().equals(Namespace.NO_NAMESPACE);
        boolean rootIs19139 = root.getName().equals(MD_METADATA_NAME) && root.getNamespace().equals(GMD_NAMESPACE);
        if (!rootIsWrapper && !rootIs19139)
            throw new B3PCatalogException("Root element must be either <metadata/> (no ns) or <MD_Metadata/> (from ns \"http://www.isotc211.org/2005/gmd\"). Root name is: " + root.getName());

        // we need 19139 metadata to be in a wrapper to be able to add comments and other stuff:
        if (!rootIsWrapper && rootIs19139) {
            Element oldRoot = doc.detachRootElement();
            root = new Element(METADATA_NAME);
            root.setContent(oldRoot);
            doc.setRootElement(root);
        }

        return root;
    }

    private Element getB3Partners(Document doc) throws B3PCatalogException {
        return getOrCreateElement(getRoot(doc), B3PARTNERS_NAME, B3P_NAMESPACE);
    }

    private Element getComments(Document doc) throws B3PCatalogException {
        return getOrCreateElement(getB3Partners(doc), COMMENTS_NAME, B3P_NAMESPACE);
    }

    private Element getMetadataPBL(Document doc) throws B3PCatalogException {
        return getOrCreateElement(getB3Partners(doc), METADATA_PBL_NAME);
    }

    private Element getOrCreateElement(Element parent, String name) throws B3PCatalogException {
        return getOrCreateElement(parent, name, Namespace.NO_NAMESPACE);
    }

    private Element getOrCreateElement(Element parent, String name, Namespace ns) throws B3PCatalogException {
        if (parent == null)
            throw new B3PCatalogException("Parent element is null when trying to create element with name: " + name);

        Element child = parent.getChild(name, ns);
        if (child == null) {
            child = new Element(name, ns);
            parent.addContent(child);
        }
        return child;
    }

    public String getFilename() {
        return filename;
    }

    public void setFilename(String filename) {
        this.filename = filename;
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

}
