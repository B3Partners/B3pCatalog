/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

package nl.b3p.catalog;

import java.io.InputStream;
import java.io.Reader;
import net.sourceforge.stripes.action.StreamingResolution;

/**
 *
 * @author Erik
 */
public class XmlResolution extends StreamingResolution {
    protected final static String DEFAULT_CONTENT_TYPE = "text/xml";
    protected final static String DEFAULT_ENCODING = "UTF-8";

    public XmlResolution(InputStream inputStream) {
        super(DEFAULT_CONTENT_TYPE, inputStream);
        init();
    }

    public XmlResolution(Reader reader) {
        super(DEFAULT_CONTENT_TYPE, reader);
        init();
    }

    public XmlResolution(String string) {
        super(DEFAULT_CONTENT_TYPE, string);
        init();
    }

    private void init() {
        setCharacterEncoding(DEFAULT_ENCODING);
    }

}
