package nl.b3p.catalog.resolution;

import java.io.InputStream;
import java.io.Reader;
import java.util.Map;
import org.jdom2.Document;
import org.jdom2.output.XMLOutputter;

/**
 *
 * @author Erik
 */
public class HtmlResolution extends ExtraHeadersResolution {
    protected static String DEFAULT_CONTENT_TYPE = "text/html";

    public HtmlResolution(InputStream inputStream) {
        this(inputStream, null);
    }

    public HtmlResolution(Reader reader) {
        this(reader, null);
    }

    public HtmlResolution(String string) {
        this(string, null);
    }

    public HtmlResolution(Document doc) {
        this(doc, null);
    }

    public HtmlResolution(InputStream inputStream, Map<String, String> extraHeaders) {
        super(DEFAULT_CONTENT_TYPE, inputStream);
        init(extraHeaders);
    }

    public HtmlResolution(Reader reader, Map<String, String> extraHeaders) {
        super(DEFAULT_CONTENT_TYPE, reader, extraHeaders);
    }

    public HtmlResolution(String string, Map<String, String> extraHeaders) {
        super(DEFAULT_CONTENT_TYPE, string, extraHeaders);
    }

    public HtmlResolution(Document doc, Map<String, String> extraHeaders) {
        super(DEFAULT_CONTENT_TYPE, new XMLOutputter().outputString(doc), extraHeaders);
    }
}
