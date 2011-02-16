/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

package nl.b3p.catalog;

import java.io.InputStream;
import java.io.Reader;
import java.util.Map;
import javax.servlet.http.HttpServletResponse;
import net.sourceforge.stripes.action.StreamingResolution;

/**
 *
 * @author Erik
 */
public class XmlResolution extends StreamingResolution {
    protected final static String DEFAULT_CONTENT_TYPE = "text/xml";
    protected final static String DEFAULT_ENCODING = "UTF-8";

    protected Map<String, String> extraHeaders;

    public XmlResolution(InputStream inputStream) {
        this(inputStream, null);
    }

    public XmlResolution(Reader reader) {
        this(reader, null);
    }

    public XmlResolution(String string) {
        this(string, null);
    }

    public XmlResolution(InputStream inputStream, Map<String, String> extraHeaders) {
        super(DEFAULT_CONTENT_TYPE, inputStream);
        init(extraHeaders);
    }

    public XmlResolution(Reader reader, Map<String, String> extraHeaders) {
        super(DEFAULT_CONTENT_TYPE, reader);
        init(extraHeaders);
    }

    public XmlResolution(String string, Map<String, String> extraHeaders) {
        super(DEFAULT_CONTENT_TYPE, string);
        init(extraHeaders);
    }

    private void init(Map<String, String> extraHeaders) {
        setCharacterEncoding(DEFAULT_ENCODING);
        this.extraHeaders = extraHeaders;
    }

    @Override
    protected void applyHeaders(HttpServletResponse response) {
        super.applyHeaders(response);
        if (extraHeaders != null) {
            for (Map.Entry<String, String> entry : extraHeaders.entrySet()) {
                response.setHeader(entry.getKey(), entry.getValue());
            }
        }
    }

}
