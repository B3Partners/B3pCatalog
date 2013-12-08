/*
 * Copyright (C) 2012 B3Partners B.V.
 *
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program.  If not, see <http://www.gnu.org/licenses/>.
 */
package nl.b3p.catalog.xml;

import java.io.IOException;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.UUID;
import javax.xml.transform.Transformer;
import javax.xml.transform.TransformerConfigurationException;
import javax.xml.transform.TransformerException;
import javax.xml.transform.TransformerFactory;
import javax.xml.transform.stream.StreamSource;
import nl.b3p.catalog.B3PCatalogException;
import org.jdom.Attribute;
import org.jdom.Content;
import org.jdom.Document;
import org.jdom.Element;
import org.jdom.JDOMException;
import org.jdom.Namespace;
import org.jdom.transform.JDOMResult;
import org.jdom.transform.JDOMSource;
import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;

/**
 *
 * @author Chris van Lith
 */
public class mdeXml2Html {
    
    private final static Log log = LogFactory.getLog(mdeXml2Html.class);

    
    static Map<String, String> params = new HashMap();
    static {
        params.put("fcMode", "true");
        params.put("dcMode", "true");
        params.put("dcPblMode", "true");
        params.put("iso19115oneTab", "true");
        params.put("commentMode", "true");
        params.put("geoTabsMinimizable", "true");
        params.put("geoTabsMinimized", "true");
        params.put("viewMode", "false");
 
    }
    
    public static Document transform(Document doc) throws JDOMException, IOException, TransformerConfigurationException, TransformerException {
        TransformerFactory tf = TransformerFactory.newInstance();
        Transformer t = tf.newTransformer(new StreamSource(mdeXml2Html.class.getResourceAsStream("mdemain.xsl")));
        if (params != null) {
            for (Map.Entry<String, String> param : params.entrySet()) {
                t.setParameter(param.getKey(), param.getValue());
            }
        }

        JDOMResult result = new JDOMResult();
        t.transform(new JDOMSource(doc), result);
        
        return result.getDocument();
    }
    
    public static Document preprocess(Document doc) throws JDOMException, IOException, TransformerConfigurationException, TransformerException {
        TransformerFactory tf = TransformerFactory.newInstance();
        Transformer t = tf.newTransformer(new StreamSource(mdeXml2Html.class.getResourceAsStream("mdeXmlPreprocessor.xsl")));
        if (params != null) {
            for (Map.Entry<String, String> param : params.entrySet()) {
                t.setParameter(param.getKey(), param.getValue());
            }
        }

        JDOMResult result = new JDOMResult();
        t.transform(new JDOMSource(doc), result);
        
        return result.getDocument();
    }
    
    public static Document dCtoISO19115Synchronizer(Document doc) throws JDOMException, IOException, TransformerConfigurationException, TransformerException {
        TransformerFactory tf = TransformerFactory.newInstance();
        Transformer t = tf.newTransformer(new StreamSource(mdeXml2Html.class.getResourceAsStream("sync_ncml.xsl")));
        if (params != null) {
            for (Map.Entry<String, String> param : params.entrySet()) {
                t.setParameter(param.getKey(), param.getValue());
            }
        }

        JDOMResult result = new JDOMResult();
        t.transform(new JDOMSource(doc), result);
        
        return result.getDocument();
    }
    
    public static void addUUID(Document xmlDoc, boolean overwriteUUIDs) throws JDOMException {
        Element mdNode = XPathHelper.selectSingleElement(xmlDoc, "/*/gmd:MD_Metadata");
        if (mdNode==null) {
            return;
        }
        List<Element> mdChildren = mdNode.getChildren("fileIdentifier", Namespaces.GMD);
        boolean foundIdentifier = false;
        for (Element e : mdChildren) {
            if (foundIdentifier) {
                mdNode.removeContent(e);
            } else {
                foundIdentifier = true;
                Element fics = e.getChild("CharacterString", Namespaces.GCO);
             
                if (overwriteUUIDs || fics.getTextNormalize().isEmpty()) {
                    fics.setText(UUID.randomUUID().toString().toLowerCase());
                }
            }
        }
    }

    public static void addDateStamp(Document xmlDoc) throws JDOMException {
        Element dateNode = XPathHelper.selectSingleElement(xmlDoc, "/*/gmd:MD_Metadata/gmd:dateStamp/gco:Date");
        SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
        dateNode.setText( sdf.format(new Date()));
    }

    // Makes sure that the path to a newly added elem/section is created (path of single elems).
    // This is necessary in some cases to prevent the preprocessor from creating an entirely new subtree.
    public static Element createPath(String path, String endPath) throws Exception {
        Element startNode = null;
        Element currentNode = null;
        if (path != null && endPath != null) {
            if (path.equals(endPath.substring(0, path.length()))) {
                String toBeCreatedPath = endPath.substring(path.length());
                if (toBeCreatedPath.length() > 0) {
                    if (toBeCreatedPath.indexOf("/")==0) {
                        toBeCreatedPath = toBeCreatedPath.substring(1);
                    }
                    String[] pathList = toBeCreatedPath.split("/");
                    for (int i = 0; i < pathList.length - 1; i++) { // the last value must be created by the preprocessor (for picklists and stuff).
                        String tempNodeName = pathList[i];
                        if (tempNodeName != null) {
                            Namespace tns = Namespaces.getFullNameSpace(tempNodeName);
                            Element tNode = new Element(Namespaces.getLocalName(tempNodeName), tns);
                            if (currentNode==null) {
                                startNode = tNode;
                            } else {
                                currentNode.addContent(tNode);
                            }
                            currentNode = tNode;
                        }
                    }
                }
            }
        }
        return startNode;
    }
    
    public static void cleanUpMetadata(Document doc, boolean serviceMode, boolean datasetMode) throws B3PCatalogException {
        Element mdNode = DocumentHelper.getMD_Metadata(doc);
        List<Element> mdChildren = mdNode.getChildren();
        for (Element e : mdChildren) {
            String localName = e.getName();
            if (!serviceMode && localName.equals("SV_ServiceIdentification")) {
                //remove srv:SV_ServiceIdentification (no dataset)
                mdNode.removeContent(e);
            }
            if (!datasetMode && localName.equals("MD_Distribution")) {
                //remove gmd:MD_Distribution (no service)
                mdNode.removeContent(e);
            }
        }
    }

    public static void addElementOrSection(Document xmlDoc, String path, String endPath, boolean above) throws JDOMException, Exception {
//            var path = $elementOrSection.attr("ui-mde-repeatablepath");
//            var endPath = $elementOrSection.attr("ui-mde-fullpath");

        Element parent = getParentElement(xmlDoc, path);
        if (parent==null) {
            return;
        }
        Element toBeDuplicatedNode = XPathHelper.selectSingleElement(xmlDoc, path);

        if (toBeDuplicatedNode == null) {
            log.debug("Path: '" + path + "' not found.");
            return;
        }

        Element newNode = createPath(calcParentPath(path), endPath);

        log.debug("Inserting node...");
        int currentIndex = 0;
        for (int i=0 ; i<parent.getContentSize(); i++) {
            Content c = parent.getContent(i);
            if (c.equals(toBeDuplicatedNode)) {
                currentIndex = i;
                break;
            }
        }
        if (!above) {
            currentIndex++;
        }
        parent.addContent(currentIndex, newNode);

        // create entirely new xhtml representation of xmlDoc and add it to the current page (must be done to get sequence of duplicated nodes right)
//            Document ppDoc = mdeXml2Html.preprocess(mdDoc);
//            Document htmlDoc = mdeXml2Html.transform(ppDoc);
//            // this._addDateStamp(this.xmlDoc); 
//
//            StringReader sr = new StringReader(DocumentHelper.getDocumentString(htmlDoc));
//            return new HtmlResolution(sr);
    }

    public void deleteElementOrSection(Document xmlDoc, String elementOrSectionPath, String notAllowedDeleteText) throws JDOMException, Exception {
        Element parent = getParentElement(xmlDoc, elementOrSectionPath);
        if (parent==null) {
            return;
        }

        // find section in backend
        Element toBeDeletedNode = XPathHelper.selectSingleElement(xmlDoc, elementOrSectionPath);
        // get nr of same nodes in backend
        String eName = toBeDeletedNode.getName();
        List<Element> elems = parent.getChildren(eName);
        if (elems.size() < 2) {
            throw new Exception(notAllowedDeleteText);
        }

        // delete section from xml backend
        parent.removeContent(toBeDeletedNode);

        // create entirely new xhtml representation of xmlDoc and add it to the current page (must be done to get sequence of duplicated nodes right)
        // no need for preprocessing, since we only removed elements
 //            Document ppDoc = mdeXml2Html.preprocess(mdDoc);
//            Document htmlDoc = mdeXml2Html.transform(ppDoc);
//            // this._addDateStamp(this.xmlDoc); 
//
//            StringReader sr = new StringReader(DocumentHelper.getDocumentString(htmlDoc));
//            return new HtmlResolution(sr);

     }

    public String getSavedValueOnServerSide(Document xmlDoc, String thePath, String attrName) throws JDOMException {
        Element xmlElement = XPathHelper.selectSingleElement(xmlDoc, thePath);
        String savedValue = xmlElement.getValue();
        // check if we have an attribute
        String attributeValue = xmlElement.getAttribute(attrName).getValue();

        // check if we are dealing with a picklist
        String codeListValue = xmlElement.getAttribute("codeListValue").getValue();
        if (codeListValue != null) {
            savedValue = codeListValue;
        } else if (attributeValue!= null) {
            savedValue = attributeValue;
        }
        return savedValue;
    };

    public void saveValueOnServerSide(Document xmlDoc, String path, String attrName, String newValue, String newText) throws JDOMException, Exception {

        Element targetNode = XPathHelper.selectSingleElement(xmlDoc, path);
        if (targetNode == null) {
            throw new Exception("Save path in XML document not found. Changes will not be saved.");
        }
        //this.log($targetNode);

        if (targetNode.getAttribute("codeListValue") != null) {
            // is picklist item
            targetNode.setAttribute("codeListValue", newValue);
            targetNode.setText(newText);
        } else if (targetNode.getAttribute(attrName) != null) {
            targetNode.setAttribute(attrName, newValue);
        } else {
            targetNode.setText(newValue);
        }
    }
    
    private static boolean removeEmptyNode(Element node) {
        boolean deleteOK = true;
        // check children
        List<Element> children = node.getChildren();
        for (Element e : children) {
            if (removeEmptyNode(e)) {
                node.removeContent(e);
            } else {
                deleteOK = false;
            }
        }
        // check node text
        if (deleteOK) {
            String value = node.getText();
            if (value != null && !value.isEmpty()) {
                deleteOK = false;
            }
        }
        // check relevant attributes
        if (deleteOK) {
            List<Attribute> attrs = node.getAttributes();
            for (Attribute a : attrs) {
                // codeList always has value, but only codeListValue is relevant
                // uom is not relevant
                // namespace is not relevant
                String n = a.getName();
                if (!n.equals("codeList") 
                        && !n.equals("uom") 
                        && !n.startsWith("xmlns:")) {
                    deleteOK = false;
                    break;
                }
            }
        }
        return deleteOK;
    }
        
   public static void removeEmptyNodes(Document xmlDoc) {
       Element e = xmlDoc.getRootElement();
       boolean deleteOK = removeEmptyNode(e); 
       if (deleteOK) {
        // remove e?
       }
   }

   public static String calcParentPath(String path) {
        if (path == null || path.isEmpty()) {
            return null;
        }
        int pos = path.lastIndexOf("/");
        if (pos<0) {
            return null;
        }
        return path.substring(0, pos);
    }
    
    public static Element getParentElement(Document xmlDoc, String path) throws JDOMException {
        String parentPath = calcParentPath(path);
        if (parentPath==null) {
            return null;
        }
        return XPathHelper.selectSingleElement(xmlDoc, parentPath);
    }


    public static void main(String [] args) throws Exception {
        Document mdDoc = DocumentHelper.getMetadataDocument(DocumentHelper.EMPTY_METADATA);
        
        Document ppDoc = mdeXml2Html.preprocess(mdDoc);
        addDateStamp(ppDoc);
        addUUID(ppDoc, true);
        
        addElementOrSection(ppDoc, "/metadata/gmd:MD_Metadata/gmd:fileIdentifier", "/metadata/gmd:MD_Metadata/gmd:fileIdentifier/gco:CharacterString", false);
        
        Document htmlDoc = mdeXml2Html.transform(ppDoc);
            // this._addDateStamp(this.xmlDoc); 


        System.out.println("-----------------START--------------------");
                System.out.println(DocumentHelper.getDocumentString(ppDoc));        
        System.out.println("-----------------END----------------------");
    }

      
}
