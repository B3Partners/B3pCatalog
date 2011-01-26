/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

package nl.b3p.catalog.stripes;

import java.io.File;
import java.io.IOException;
import java.text.DateFormat;
import java.text.SimpleDateFormat;
import java.util.Arrays;
import java.util.Date;
import net.sourceforge.stripes.action.Resolution;
import net.sourceforge.stripes.action.StreamingResolution;
import net.sourceforge.stripes.validation.Validate;
import nl.b3p.catalog.filetree.Rewrite;
import org.apache.commons.io.FileUtils;
import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.jdom.Document;
import org.jdom.Element;
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
    private final static Namespace GCO_NAMESPACE = Namespace.getNamespace("gco", "http://www.isotc211.org/2005/gco");

    private final static String METADATA_NAME = "metadata";
    private final static String MD_METADATA_NAME = "MD_Metadata";
    private final static String B3PARTNERS_NAME = "B3Partners";
    private final static String COMMENTS_NAME = "comments";
    private final static String COMMENT_NAME = "comment";
    private final static String USERNAME_NAME = "username";
    private final static String DATE_TIME_NAME = "dateTime";
    private final static String CONTENT_NAME = "content";


    private final static DateFormat DATETIME_FORMAT = new SimpleDateFormat("yyyy-MM-dd'T'HH:mm:ss");

    @Validate(required=true)
    private String filename;

    @Validate(required=true, on="save")
    private String metadata;

    @Validate(required=true, on="postComment")
    private String comment;

    // TODO: check permissie om file te loaden!!
    // TODO: foutafhandeling!
    public Resolution load() {
        File mdFile = null;
        try {
            mdFile = Rewrite.getFileFromPPFileName(filename + METADATA_FILE_EXTENSION, getContext());
            if (!mdFile.exists()) {
                //try {
                    //mdFile.createNewFile();
                    return new StreamingResolution("text/plain", "");
                /*} catch (IOException ex) {
                    log.warn("Could not create file: " + mdFile.getAbsolutePath(), ex);
                    return new StreamingResolution("text/plain", "");
                }*/
            }

            StreamingResolution res = new StreamingResolution("text/xml", FileUtils.openInputStream(mdFile));
            //res.setCharacterEncoding("UTF-8");
            return res;
        } catch (IOException ex) {
            log.warn("Could not read file: " + mdFile == null ? "none" : mdFile.getAbsolutePath(), ex);
            return new StreamingResolution("text/plain", "");
        }
    }

    // TODO: check permissie om file te saven!!
    // TODO: gooi alle comments uit geüploadede xml weg en voeg de comments uit xml op schijf toe. Dan pas wegschrijven.
    public Resolution save() {
        File mdFile = null;
        try {
            mdFile = Rewrite.getFileFromPPFileName(filename + METADATA_FILE_EXTENSION, getContext());
            // remove comments: they could be tampered with.
            FileUtils.writeStringToFile(mdFile, metadata, "UTF-8");
            return new StreamingResolution("text/plain", "success");
        } catch (IOException ex) {
            log.warn("Could not write file: " + mdFile == null ? "none" : mdFile.getAbsolutePath(), ex);
            return new StreamingResolution("text/plain", "Het is niet gelukt om de metadata op te slaan:\n\n" + ex.getLocalizedMessage());
        }
    }

    // Comments can be posted by anyone to any ".xml"-file that is a descendant of one of the roots.
    // that has <metadata/> or <gmd:MD_Metadata/> as root. This is by design.
    public Resolution postComment() {
        try {
            File mdFile = Rewrite.getFileFromPPFileName(filename + METADATA_FILE_EXTENSION, getContext());
            
            Document doc = null;
            if (mdFile.exists())
                doc = new SAXBuilder().build(FileUtils.openInputStream(mdFile));
            else
                doc = new Document(new Element(METADATA_NAME));
            Element root = doc.getRootElement();

            boolean rootIsWrapper = root.getName().equals(METADATA_NAME) && root.getNamespace().equals(Namespace.NO_NAMESPACE);
            boolean rootIs19139 = root.getName().equals(MD_METADATA_NAME) && root.getNamespace().equals(GMD_NAMESPACE);
            if (!rootIsWrapper && !rootIs19139) {
                return new StreamingResolution("text/plain", "Trying to insert comment in non-metadata xml. This is not allowed.");
            }

            // we need 19139 metadata to be in a wrapper to be able to add comments:
            if (!rootIsWrapper && rootIs19139) {
                Element oldRoot = doc.detachRootElement();
                root = new Element(METADATA_NAME);
                root.setContent(oldRoot);
                doc.setRootElement(root);
            }

            Element b3partners = root.getChild(B3PARTNERS_NAME);
            if (b3partners == null) {
                b3partners = new Element(B3PARTNERS_NAME);
                root.addContent(b3partners);
            }

            Element comments = b3partners.getChild(COMMENTS_NAME);
            if (comments == null) {
                comments = new Element(COMMENTS_NAME);
                b3partners.addContent(comments);
            }

            Element newComment = new Element(COMMENT_NAME).addContent(Arrays.asList(
                new Element(USERNAME_NAME).setText(getContext().getRequest().getRemoteUser()),
                new Element(DATE_TIME_NAME, GCO_NAMESPACE).setText(DATETIME_FORMAT.format(new Date())),
                new Element(CONTENT_NAME).setText(comment)
            ));
            comments.addContent(newComment);

            new XMLOutputter(Format.getPrettyFormat()).output(doc, FileUtils.openOutputStream(mdFile));
            
            return new StreamingResolution("text/xml", FileUtils.openInputStream(mdFile));
        } catch(Exception ex) {
            return new StreamingResolution("text/plain", "Het is niet gelukt om het commentaar (" + comment + ") te posten in file \"" + filename + METADATA_FILE_EXTENSION + "\":\n\n" + ex.getLocalizedMessage());
        }
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
