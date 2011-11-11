/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package nl.b3p.catalog.xml;

import java.io.BufferedInputStream;
import java.io.File;
import java.io.IOException;
import java.io.InputStream;
import java.io.StringReader;
import nl.b3p.catalog.B3PCatalogException;
import org.apache.commons.io.FileUtils;
import org.apache.commons.lang.StringUtils;
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
public class DocumentHelper {
    public static final String EMPTY_METADATA = "empty";

    public static String getDocumentString(Document xml) {
        return new XMLOutputter(Format.getPrettyFormat()).outputString(xml);
    }

    public static Document getMetadataDocument(File mdFile) throws IOException, JDOMException, B3PCatalogException {
        if (mdFile == null)
            throw new B3PCatalogException("Metadata file is null.");
        Document doc = null;
        if (mdFile.exists()) {
            InputStream inputStream = new BufferedInputStream(FileUtils.openInputStream(mdFile));
            doc = new SAXBuilder().build(inputStream);
            inputStream.close();
        } else {
            doc = new Document(new Element(Names.METADATA));
        }
        return doc;
    }

    public static Document getMetadataDocument(String md) throws IOException, JDOMException, B3PCatalogException {
        Document doc = null;
        if (StringUtils.isBlank(md) || EMPTY_METADATA.equals(md)) {
            doc = new Document(new Element(Names.METADATA));
        } else {
            doc = new SAXBuilder().build(new StringReader(md));
        }
        return doc;
    }

    public static Element getRoot(Document doc) throws B3PCatalogException {
        if (doc == null)
            throw new B3PCatalogException("Metadata document is null.");
        Element root = doc.getRootElement();

        boolean rootIsWrapper = root.getName().equals(Names.METADATA) && root.getNamespace().equals(Namespace.NO_NAMESPACE);
        boolean rootIs19139 = root.getName().equals(Names.GMD_MD_METADATA) && root.getNamespace().equals(Namespaces.GMD);
        if (!rootIsWrapper && !rootIs19139)
            throw new B3PCatalogException("Root element must be either <metadata/> (no ns) or <MD_Metadata/> (from ns \"http://www.isotc211.org/2005/gmd\"). Root name is: " + root.getName());

        // we need 19139 metadata to be in a wrapper to be able to add comments and other stuff:
        if (!rootIsWrapper && rootIs19139) {
            Element oldRoot = doc.detachRootElement();
            root = new Element(Names.METADATA);
            root.setContent(oldRoot);
            doc.setRootElement(root);
        }

        return root;
    }

    public static Element getMD_Metadata(Document doc) throws B3PCatalogException {
        return getOrCreateElement(getRoot(doc), Names.GMD_MD_METADATA, Namespaces.GMD);
    }

    public static Element getB3Partners(Document doc) throws B3PCatalogException {
        return getOrCreateElement(getRoot(doc), Names.B3P_B3PARTNERS, Namespaces.B3P);
    }

    public static Element getComments(Document doc) throws B3PCatalogException {
        return getOrCreateElement(getB3Partners(doc), Names.B3P_COMMENTS, Namespaces.B3P);
    }

    public static Element getMetadataPBL(Document doc) throws B3PCatalogException {
        return getOrCreateElement(getB3Partners(doc), Names.PBL_METADATA_PBL, Namespaces.PBL);
    }

    public static Element getOrCreateElement(Element parent, String name) throws B3PCatalogException {
        return getOrCreateElement(parent, name, Namespace.NO_NAMESPACE);
    }

    public static Element getOrCreateElement(Element parent, String name, Namespace ns) throws B3PCatalogException {
        if (parent == null)
            throw new B3PCatalogException("Parent element is null when trying to create element with name: " + name);

        Element child = parent.getChild(name, ns);
        if (child == null) {
            child = new Element(name, ns);
            parent.addContent(child);
        }
        return child;
    }


}
