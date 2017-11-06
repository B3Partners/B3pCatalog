package nl.b3p.catalog.resolution;

import java.io.InputStream;
import java.io.Reader;
import java.util.Map;
import javax.servlet.http.HttpServletResponse;
import net.sourceforge.stripes.action.StreamingResolution;
import org.jdom2.Document;
import org.jdom2.output.XMLOutputter;

/**
 *
 * @author Erik
 */
public class ExtraHeadersResolution extends StreamingResolution {
    protected final static String DEFAULT_ENCODING = "UTF-8";

    protected Map<String, String> extraHeaders;

    public ExtraHeadersResolution(String contentType, InputStream inputStream) {
        this(contentType, inputStream, null);
    }

    public ExtraHeadersResolution(String contentType, Reader reader) {
        this(contentType, reader, null);
    }

    public ExtraHeadersResolution(String contentType, String string) {
        this(contentType, string, null);
    }

    public ExtraHeadersResolution(String contentType, Document doc) {
        this(contentType, doc, null);
    }

    public ExtraHeadersResolution(String contentType, InputStream inputStream, Map<String, String> extraHeaders) {
        super(contentType, inputStream);
        init(extraHeaders);
    }

    public ExtraHeadersResolution(String contentType, Reader reader, Map<String, String> extraHeaders) {
        super(contentType, reader);
        init(extraHeaders);
    }

    public ExtraHeadersResolution(String contentType, String string, Map<String, String> extraHeaders) {
        super(contentType, string);
        init(extraHeaders);
    }

    public ExtraHeadersResolution(String contentType, Document doc, Map<String, String> extraHeaders) {
        super(contentType, new XMLOutputter().outputString(doc));
        init(extraHeaders);
    }

    protected void init(Map<String, String> extraHeaders) {
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
