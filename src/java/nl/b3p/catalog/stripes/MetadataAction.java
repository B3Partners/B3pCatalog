/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

package nl.b3p.catalog.stripes;

import java.io.File;
import java.io.IOException;
import net.sourceforge.stripes.action.Resolution;
import net.sourceforge.stripes.action.StreamingResolution;
import net.sourceforge.stripes.validation.Validate;
import nl.b3p.catalog.filetree.Rewrite;
import org.apache.commons.io.FileUtils;
import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;

/**
 *
 * @author Erik van de Pol
 */
public class MetadataAction extends DefaultAction {
    private final static Log log = LogFactory.getLog(MetadataAction.class);

    private final static String METADATA_FILE_EXTENSION = ".xml";

    @Validate(required=true)
    private String filename;

    @Validate(required=true, on="save")
    private String metadata;

    // TODO: check permissie om file te loaden!!
    // TODO: foutafhandeling!
    public Resolution load() {
        File mdFile = Rewrite.getFileFromPPFileName(filename + METADATA_FILE_EXTENSION, getContext());
        if (!mdFile.exists()) {
            //try {
                //mdFile.createNewFile();
                return new StreamingResolution("text/plain", "");
            /*} catch (IOException ex) {
                log.warn("Could not create file: " + mdFile.getAbsolutePath(), ex);
                return new StreamingResolution("text/plain", "");
            }*/
        }

        try {
            StreamingResolution res = new StreamingResolution("text/xml", FileUtils.openInputStream(mdFile));
            res.setCharacterEncoding("UTF-8");
            return res;
        } catch (IOException ex) {
            log.warn("Could not read file: " + mdFile.getAbsolutePath(), ex);
            return new StreamingResolution("text/plain", "");
        }
    }

    // TODO: check permissie om file te saven!!
    public Resolution save() {
        File mdFile = Rewrite.getFileFromPPFileName(filename + METADATA_FILE_EXTENSION, getContext());
        try {
            FileUtils.writeStringToFile(mdFile, metadata, "UTF-8");
            return new StreamingResolution("text/plain", "success");
        } catch (IOException ex) {
            log.warn("Could not write file: " + mdFile.getAbsolutePath(), ex);
            return new StreamingResolution("text/plain", "Het is niet gelukt om de metadata op te slaan:\n\n" + ex.getLocalizedMessage());
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

}
