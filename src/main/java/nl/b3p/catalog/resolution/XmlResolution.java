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
public class XmlResolution extends ExtraHeadersResolution {
    protected static String DEFAULT_CONTENT_TYPE = "text/xml";

    public XmlResolution(InputStream inputStream) {
        this(inputStream, null);
    }

    public XmlResolution(Reader reader) {
        this(reader, null);
    }

    public XmlResolution(String string) {
        this(string, null);
    }

    public XmlResolution(Document doc) {
        this(doc, null);
    }

    public XmlResolution(InputStream inputStream, Map<String, String> extraHeaders) {
        super(DEFAULT_CONTENT_TYPE, inputStream);
        init(extraHeaders);
    }

    public XmlResolution(Reader reader, Map<String, String> extraHeaders) {
        super(DEFAULT_CONTENT_TYPE, reader);
    }

    public XmlResolution(String string, Map<String, String> extraHeaders) {
        super(DEFAULT_CONTENT_TYPE, string);
    }

    public XmlResolution(Document doc, Map<String, String> extraHeaders) {
        super(DEFAULT_CONTENT_TYPE, new XMLOutputter().outputString(doc));
    }
}
