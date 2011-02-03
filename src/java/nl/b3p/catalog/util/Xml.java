package nl.b3p.catalog.util;

import java.util.HashMap;
import java.util.Map;
import javax.xml.transform.Transformer;
import javax.xml.transform.TransformerException;
import javax.xml.transform.TransformerFactory;
import javax.xml.transform.stream.StreamSource;
import org.jdom.Document;
import org.jdom.transform.JDOMResult;
import org.jdom.transform.JDOMSource;
//=============================================================================

public class Xml {

    public static Document transform(Document xmlDocument, String styleSheetPath) throws TransformerException {
        return transform(xmlDocument, styleSheetPath, null);
    }

    public static Document transform(Document xmlDocument, String styleSheetPath, String paramName, String paramValue) throws TransformerException {
        Map<String, String> params = new HashMap();
        params.put(paramName, paramValue);
        return transform(xmlDocument, styleSheetPath, params);
    }

    public static Document transform(Document xmlDocument, String styleSheetPath, Map<String, String> parameters) throws TransformerException {
        Transformer transformer =
                TransformerFactory.newInstance().newTransformer(new StreamSource(styleSheetPath));
        JDOMSource in = new JDOMSource(xmlDocument);
        JDOMResult out = new JDOMResult();
        if (parameters != null) {
            for (Map.Entry<String, String> param : parameters.entrySet()) {
                transformer.setParameter(param.getKey(), param.getValue());
            }
        }
        transformer.transform(in, out);
        return out.getDocument();
    }
}
