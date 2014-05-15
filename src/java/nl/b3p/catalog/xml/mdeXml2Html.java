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
import java.util.ArrayList;
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
import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.jdom.Attribute;
import org.jdom.Content;
import org.jdom.Document;
import org.jdom.Element;
import org.jdom.JDOMException;
import org.jdom.Namespace;
import org.jdom.Parent;
import org.jdom.output.Format;
import org.jdom.output.XMLOutputter;
import org.jdom.transform.JDOMResult;
import org.jdom.transform.JDOMSource;
import org.jdom.xpath.XPath;
import org.json.JSONArray;
import org.json.JSONObject;

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
        params.put("globalReadonly", "false");
        params.put("serviceMode", "false");
        params.put("datasetMode", "true");
        params.put("synchroniseDC", "true");
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
                    // als endPath maar enkel element, dan toch aanmaken (altijd
                    // minimaal een element aanmaken in deze methode)
                    for (int i = 0; i < (pathList.length == 1 ? 1 : pathList.length - 1); i++) { // the last value must be created by the preprocessor (for picklists and stuff).
                        String tempNodeName = pathList[i];
                        // Verwijder xpath positie conditie van nieuw te maken
                        // node name (element[1] -> element)
                        if(tempNodeName.contains("[")) {
                            tempNodeName = tempNodeName.substring(0, tempNodeName.indexOf("["));
                        }
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
    
    public static void applySectionChange(Document xmlDoc, JSONObject change) throws Exception {
        
        String action = change.getString("action");
        String path = change.getString("path");
        
        if("add".equals(action)) {
            boolean above = change.getBoolean("above");
            String endPath = change.getString("endPath");
            
            addElementOrSection(xmlDoc, path, endPath, above);
        } else {
            deleteElementOrSection(xmlDoc, path);
        }
    }

    public static Element addElementOrSection(Document xmlDoc, String path, String endPath, boolean above) throws JDOMException, Exception {
//            var path = $elementOrSection.attr("ui-mde-repeatablepath");
//            var endPath = $elementOrSection.attr("ui-mde-fullpath");

        Element parent = getParentElement(xmlDoc, path);
        if (parent==null) {
            return null;
        }
        Element toBeDuplicatedNode = XPathHelper.selectSingleElement(xmlDoc, path);

        if (toBeDuplicatedNode == null) {
            log.debug("Path: '" + path + "' not found.");
            return null;
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
        return parent;
    }

    public static Element deleteElementOrSection(Document xmlDoc, String elementOrSectionPath) throws JDOMException, Exception {
        Element parent = getParentElement(xmlDoc, elementOrSectionPath);
        if (parent==null) {
            return null;
        }

        // find section in backend
        Element toBeDeletedNode = XPathHelper.selectSingleElement(xmlDoc, elementOrSectionPath);
        // get nr of same nodes in backend
        String eName = toBeDeletedNode.getName();        
        List<Element> elems = parent.getChildren(eName, toBeDeletedNode.getNamespace());
        if (elems.size() < 2) {
            throw new Exception("Laatste element mag niet worden verwijderd op pad " + elementOrSectionPath);
        }

        // delete section from xml backend
        parent.removeContent(toBeDeletedNode);
        return parent;
     }

    public static String getSavedValueOnServerSide(Document xmlDoc, String thePath, String attrName) throws JDOMException {
        Element xmlElement = XPathHelper.selectSingleElement(xmlDoc, thePath);
        String savedValue = xmlElement.getValue();
        // check if we have an attribute
        String attributeValue = null;
        if (attrName!=null) {
            Attribute a = xmlElement.getAttribute(attrName);
            if (a!=null) {
                attributeValue = a.getValue();
            }
        }

        // check if we are dealing with a picklist
        String codeListValue = xmlElement.getAttribute("codeListValue").getValue();
        if (codeListValue != null) {
            savedValue = codeListValue;
        } else if (attributeValue!= null) {
            savedValue = attributeValue;
        }
        return savedValue;
    };
    
    public static void applyElementChanges(Document xmlDoc, JSONArray changes) throws Exception {
        if(log.isDebugEnabled()) {
            log.debug("applyElementChanges(): before xml = " + DocumentHelper.getDocumentString(xmlDoc));
        }

        for(int i = 0; i < changes.length(); i++) {
            JSONObject change = changes.getJSONObject(i);

            updateElement(xmlDoc, change.getString("path"), change.getString("attrName"), change.getString("newValue"), change.getString("newText"));
        }
        
        if(log.isDebugEnabled()) {
            log.debug("applyElementChanges(): after xml = " + DocumentHelper.getDocumentString(xmlDoc));
        }
    }    

    public static void updateElement(Document xmlDoc, String xpath, String attrName, String newValue, String newText) throws JDOMException, Exception {

        Element targetNode = XPathHelper.selectSingleElement(xmlDoc, xpath);
        if (targetNode == null) {
            throw new Exception("Save path \"" + xpath + "\" in XML document not found");
        }
        
        if (targetNode.getAttribute("codeListValue") != null) {
            // is picklist item
            targetNode.setAttribute("codeListValue", newValue);
            
            if (newText==null) {
                newText = newValue;
            }
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
        List<Element> childrenToBeRemoved = new ArrayList<Element>();
        for (Element e : children) {
            if (removeEmptyNode(e)) {
                childrenToBeRemoved.add(e);
            } else {
                deleteOK = false;
            }
        }
        for (Element re : childrenToBeRemoved) {
                node.removeContent(re);
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

                    // codeListValue may be present but empty
                    String value = a.getValue();
                    if (n.equals("codeListValue")
                            && value != null 
                            && value.isEmpty()) {
                        continue;
                    }

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

    public static Document convertElem2Doc(Element e) {
        Document xmlDoc = e.getDocument();
        e.detach();
        xmlDoc.setRootElement(e);
        return xmlDoc;
    }
    
    public static String convertElement2Html(Element e) throws JDOMException, Exception {
        if (e==null) {
            return null;
        }
        Document eDoc = convertElem2Doc(e);
        Document htmlDoc = mdeXml2Html.transform(eDoc);
        return DocumentHelper.getDocumentString(htmlDoc);
    }

    public static String buildXPath(Element e) {
        Element e2 = e;
        String fullName = e.getName();
        if (e.getNamespacePrefix()!=null && !e.getNamespacePrefix().isEmpty()) {
            fullName = e.getNamespacePrefix() + ":" + fullName;
        }
        StringBuffer sb = new StringBuffer(fullName);
        Parent p = e.getParent();
        while (p!=null && p instanceof Element) {
            int i = p.indexOf(e2);
            if (i>0) {
                sb.append("[" + (i+1) + "]");
            }
            sb.insert(0,"/");
            e2 = (Element)p;
            fullName = e2.getName();
            if (e2.getNamespacePrefix()!=null && !e2.getNamespacePrefix().isEmpty()) {
                fullName = e2.getNamespacePrefix() + ":" + fullName;
            }
            p = p.getParent();
            sb.insert(0, fullName);
        }
        sb.insert(0,"/");
        return sb.toString();
    }
    
    public static void main(String [] args) throws Exception {
        Document mdDoc = DocumentHelper.getMetadataDocument(DocumentHelper.EMPTY_METADATA);
        
        Document ppDoc = mdeXml2Html.preprocess(mdDoc);
        addDateStamp(ppDoc);
        addUUID(ppDoc, true);

        Element parent = null;
        parent = addElementOrSection(ppDoc, "/metadata/gmd:MD_Metadata/gmd:fileIdentifier", "/metadata/gmd:MD_Metadata/gmd:fileIdentifier/gco:CharacterString", false);
        parent = addElementOrSection(ppDoc, "/metadata/gmd:MD_Metadata/gmd:fileIdentifier", "/metadata/gmd:MD_Metadata/gmd:fileIdentifier/gco:CharacterString", false);

        ppDoc = mdeXml2Html.preprocess(ppDoc);
        parent = deleteElementOrSection(ppDoc, "/metadata/gmd:MD_Metadata/gmd:fileIdentifier[2]");
        
        String attrName = null;
        String newValue = "brabants";
        String newText = null;
        updateElement(ppDoc, "/metadata/gmd:MD_Metadata/gmd:language/gmd:LanguageCode", attrName, newValue, newText);
        String value = getSavedValueOnServerSide(ppDoc, "/metadata/gmd:MD_Metadata/gmd:language/gmd:LanguageCode", attrName);
        
        Document htmlDoc = mdeXml2Html.transform(ppDoc);
        // this._addDateStamp(this.xmlDoc); 

//        parent = XPathHelper.selectSingleElement(htmlDoc, "//div[@ui-mde-fullpath=\"/gmd:MD_Metadata/gmd:fileIdentifier[1]/gco:CharacterString\"]");
//        parent = XPathHelper.selectSingleElement(htmlDoc, "/");
        
        String xpathString = "//div[@id=\"" + "algemeen" + "\" and @class=\"ui-mde-tab-definition\"]";
        XPath xpath = XPath.newInstance(xpathString);
        Object o = xpath.selectSingleNode(htmlDoc);
        String s = null;
        if (o!=null) {
            s = new XMLOutputter(Format.getPrettyFormat()).outputString((Element)o);
        }
        
        System.out.println("-----------------START--------------------");
          System.out.println(s);
//          System.out.println(convertElement2Html(parent));
 //           System.out.println(DocumentHelper.getDocumentString(htmlDoc));        
        System.out.println("-----------------END----------------------");
    }

      
}
