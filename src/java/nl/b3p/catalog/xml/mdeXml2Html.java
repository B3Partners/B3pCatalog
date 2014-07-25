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

import java.io.File;
import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.IOException;
import java.io.InputStream;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.UUID;
import javax.xml.transform.Templates;
import javax.xml.transform.Transformer;
import javax.xml.transform.TransformerConfigurationException;
import javax.xml.transform.TransformerException;
import javax.xml.transform.TransformerFactory;
import javax.xml.transform.stream.StreamSource;
import nl.b3p.catalog.B3PCatalogException;
import nl.b3p.catalog.config.CatalogAppConfig;
import org.apache.commons.lang.StringUtils;
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
    
    /**
     * cache of transformer templates to speed up xsl reading
     */
    private static TransformerFactory transformerFactory;
    private static Map<String, Templates> transformerTemplates = new HashMap<String, Templates>();

    /**
     * The following parameters should be present in mdeConfig
     * <li> fcMode_init: maak attributen tab (feature catalog)
     * <li> dcMode_init: maak dublin core tab
     * <li> dcPblMode_init: voeg speciale PBL extra's toe aan dublin core tab
     * <li> iso19115oneTab_init: zet alle metadata voor datasets op een enkele tab
     * <li> commentMode_init: maak tab met commentaar mogelijkheid
     * <li> globalReadonly_init: maak editor read-only, viewMode in js
     * <li> serviceModemaak_init: metadata voor services
     * <li> datasetModemaak_init: metadata voor datasets
     * <li> synchroniseDC_init: gebruik dc om md tags mee te vullen
     * <li> fillDefaults_init: gebruik defaults vooringevuld
     * <li> synchroniseEsri_init: gebruik esri tags om md mee te vullen TODO
     * 
     * Extra parameters will be passed to transformer automatically.
     * 
     * LET OP: synchroniseDC werkt niet goed icm service mode omdat de sync templates
     * hier niet op aangepast zijn.
     *
     * @param param
     * @return
     * @throws B3PCatalogException
     */
    public static Boolean getXSLParam(String param) throws B3PCatalogException {
        Map<String, String> params = CatalogAppConfig.getConfig().getMdeConfig();
        if (params == null) {
            throw new B3PCatalogException("Transformer params missing from configuration!");
        }
        String paramValue = params.get(param);
        if (paramValue == null) {
            return null;
        }
        return Boolean.valueOf(paramValue);
    }

    /**
     * The following transformers should be present in de configuration under
     * mdeConfig:
     * <li> mdemain
     * <li> mdeXmlPreprocessor
     * <li> ISO19115toDC
     * <li> DCtoISO19115
     * The next transformers may be present:
     * <li> extrapreprocessor1
     * <li> extrapreprocessor2
     * <li> extrasync1
     * <li> extrasync2
     * <li> extrapostprocessor1
     * 
     * @param xslName
     * @return inputstream to transformer
     * @throws TransformerConfigurationException
     * @throws FileNotFoundException 
     */
    private static InputStream getXslStream(String xslName) throws TransformerConfigurationException, FileNotFoundException  {
        CatalogAppConfig cfg = CatalogAppConfig.getConfig();
        Map<String, String> params = cfg.getMdeConfig();
        if (params == null) {
            throw new TransformerConfigurationException("Transformers are missing from configuration!");
        }
        String xslPath = params.get(xslName);
        if (xslPath == null) {
            return null;
        }
        File f = new File(xslPath);
        if(!f.isAbsolute()) {
            f = new File(cfg.getConfigFilePath(), xslPath);
        }
        
        return new FileInputStream(f);
    }

    private static Document transformIntern(Document doc, String xslName, Boolean viewMode, boolean ignoreAllowed) throws JDOMException, IOException, TransformerConfigurationException, TransformerException {
        Templates aTemplates = null;

        if (!transformerTemplates.containsKey(xslName)) {
            InputStream is = getXslStream(xslName);
            if (is!=null) {
                if (transformerFactory == null) {
                    transformerFactory = TransformerFactory.newInstance();
                }
                aTemplates = transformerFactory.newTemplates(new StreamSource(is));
            }
            transformerTemplates.put(xslName, aTemplates);
        } else {
            aTemplates = transformerTemplates.get(xslName);
        }

        if (aTemplates == null) {
            if (ignoreAllowed) {
                // ignore transformer
                return doc;
            } else {
                throw new TransformerConfigurationException("Transformer [" + xslName + "] is missing from configuration!");
            }
        }
        
        Transformer t = aTemplates.newTransformer();
        
        Map<String, String> params = CatalogAppConfig.getConfig().getMdeConfig();
        if (params != null) {
            for (Map.Entry<String, String> param : params.entrySet()) {
                t.setParameter(param.getKey(), param.getValue());
            }
            if (viewMode!=null) {
                t.setParameter("globalReadonly_init", viewMode.toString());
            }
        }

        JDOMResult result = new JDOMResult();
        t.transform(new JDOMSource(doc), result);
        
        return result.getDocument();
    }
    
    /**
     * Main transformer that converts xml to html for use in browser
     * @param doc
     * @return
     * @throws JDOMException
     * @throws IOException
     * @throws TransformerConfigurationException
     * @throws TransformerException 
     */
    public static Document transform(Document doc) throws JDOMException, IOException, TransformerConfigurationException, TransformerException {
        return transform(doc, null);
    }
    public static Document transform(Document doc, Boolean viewMode) throws JDOMException, IOException, TransformerConfigurationException, TransformerException {
        return transformIntern(doc, "mdemain", viewMode, false);
    }
 
    /**
     * Main preprocessor that adds all missing elements to xml to form a complete
     * metadata document according to standards
     * 
     * @param doc
     * @return
     * @throws JDOMException
     * @throws IOException
     * @throws TransformerConfigurationException
     * @throws TransformerException 
     */
    public static Document preprocess(Document doc) throws JDOMException, IOException, TransformerConfigurationException, TransformerException {
         return preprocess(doc, null);
    }

    public static Document preprocess(Document doc, Boolean viewMode) throws JDOMException, IOException, TransformerConfigurationException, TransformerException {
        return transformIntern(doc, "mdeXmlPreprocessor", viewMode, false);
    }
    
    /**
     * Preprocessor that syncs elements from the iso19115 branch to the
     * dublin core branche
     * 
     * @param doc
     * @return
     * @throws JDOMException
     * @throws IOException
     * @throws TransformerConfigurationException
     * @throws TransformerException 
     */
    public static Document iSO19115toDCSynchronizer(Document doc) throws JDOMException, IOException, TransformerConfigurationException, TransformerException {
        return iSO19115toDCSynchronizer(doc, null);
    }
    
    public static Document iSO19115toDCSynchronizer(Document doc, Boolean viewMode) throws JDOMException, IOException, TransformerConfigurationException, TransformerException {
        return transformIntern(doc, "ISO19115toDC", viewMode, true);
    }
    
    /**
     * Preprocessor that syncs elements from the dublin core branch to the
     * iso19115 branche
     * 
     * @param doc
     * @return
     * @throws JDOMException
     * @throws IOException
     * @throws TransformerConfigurationException
     * @throws TransformerException 
     */
    public static Document dCtoISO19115Synchronizer(Document doc) throws JDOMException, IOException, TransformerConfigurationException, TransformerException {
        return dCtoISO19115Synchronizer(doc, null);
    }
    
    public static Document dCtoISO19115Synchronizer(Document doc, Boolean viewMode) throws JDOMException, IOException, TransformerConfigurationException, TransformerException {
        return transformIntern(doc, "DCtoISO19115", viewMode, true);
    }
    
    /**
     * Extra sync transformer for client specific use
     * 
     * @param doc
     * @param viewMode
     * @return
     * @throws JDOMException
     * @throws IOException
     * @throws TransformerConfigurationException
     * @throws TransformerException 
     */
    public static Document extraSync1(Document doc) throws JDOMException, IOException, TransformerConfigurationException, TransformerException {
        return extraSync1(doc, null);
    }
    
    public static Document extraSync1(Document doc, Boolean viewMode) throws JDOMException, IOException, TransformerConfigurationException, TransformerException {
        return transformIntern(doc, "extrasync1", viewMode, true);
    }
    
    /**
     * Extra sync transformer for client specific use
     * 
     * @param doc
     * @param viewMode
     * @return
     * @throws JDOMException
     * @throws IOException
     * @throws TransformerConfigurationException
     * @throws TransformerException 
     */
    public static Document extraSync2(Document doc) throws JDOMException, IOException, TransformerConfigurationException, TransformerException {
        return extraSync2(doc, null);
    }
    
    public static Document extraSync2(Document doc, Boolean viewMode) throws JDOMException, IOException, TransformerConfigurationException, TransformerException {
        return transformIntern(doc, "extrasync2", viewMode, true);
    }

    /**
     * Extra preprocesser that works on xml and may add customer specific elements 
     * or defaults
     * 
     * @param doc
     * @return
     * @throws JDOMException
     * @throws IOException
     * @throws TransformerConfigurationException
     * @throws TransformerException 
     */
    public static Document extraPreprocessor1(Document doc) throws JDOMException, IOException, TransformerConfigurationException, TransformerException {
        return extraPreprocessor1(doc, null);
    }
    
    public static Document extraPreprocessor1(Document doc, Boolean viewMode) throws JDOMException, IOException, TransformerConfigurationException, TransformerException {
        return transformIntern(doc, "extrapreprocessor1", viewMode, true);
    }

    /**
     * Extra preprocesser that works on xml and may add customer specific elements 
     * or defaults
     * 
     * @param doc
     * @return
     * @throws JDOMException
     * @throws IOException
     * @throws TransformerConfigurationException
     * @throws TransformerException 
     */
    public static Document extraPreprocessor2(Document doc) throws JDOMException, IOException, TransformerConfigurationException, TransformerException {
        return extraPreprocessor2(doc, null);
    }
    
    public static Document extraPreprocessor2(Document doc, Boolean viewMode) throws JDOMException, IOException, TransformerConfigurationException, TransformerException {
        return transformIntern(doc, "extrapreprocessor2", viewMode, true);
    }

    /**
     * Extra postprocessor that works on transformed html and may change e.g. css
     * client specific.
     * 
     * @param doc
     * @return
     * @throws JDOMException
     * @throws IOException
     * @throws TransformerConfigurationException
     * @throws TransformerException 
     */
    public static Document extraPostprocessor1(Document doc) throws JDOMException, IOException, TransformerConfigurationException, TransformerException {
        return extraPostprocessor1(doc, null);
    }
    
    public static Document extraPostprocessor1(Document doc, Boolean viewMode) throws JDOMException, IOException, TransformerConfigurationException, TransformerException {
        return transformIntern(doc, "extrapostprocessor1", viewMode, true);
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

    public static void addDateStamp(Document xmlDoc, boolean overwrite) throws JDOMException {
        Element dateNode = XPathHelper.selectSingleElement(xmlDoc, "/*/gmd:MD_Metadata/gmd:dateStamp/gco:Date");
        SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
        if (overwrite || dateNode.getTextNormalize().isEmpty()) {
            dateNode.setText( sdf.format(new Date()));
        }
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
        List<String> elementsToBeRemoved = new ArrayList<String>();
        if (!serviceMode) {
            elementsToBeRemoved.add("SV_ServiceIdentification");
        }
        if (!datasetMode) {
            elementsToBeRemoved.add("MD_DataIdentification");
        }
        cleanUpMetadata(mdNode, elementsToBeRemoved);
    }
    
    public static void cleanUpMetadata(Element mdNode, List<String> elementsToBeRemoved) throws B3PCatalogException {
        List<Element> mdChildren = mdNode.getChildren();
        List<Element> childrenToBeRemoved = new ArrayList<Element>();
        for (Element e : mdChildren) {
            String localName = e.getName();
            boolean removed = false;
            for (String etbr : elementsToBeRemoved) {
                if (localName.equals(etbr)) {
                    childrenToBeRemoved.add(e);
                    //do not check children
                    removed = true;
                }
            }
            if (!removed) {
                cleanUpMetadata(e, elementsToBeRemoved);
            }
         }
         for (Element re : childrenToBeRemoved) {
             mdNode.removeContent(re);
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
            String value = StringUtils.deleteWhitespace(node.getText());
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
                            && (value == null || value.isEmpty())) {
                        continue;
                    }
                    
                    deleteOK = false;
                    break;
                }
             }
        }
        // if CI_RoleCode check if there is a
        // organisation name present, if not ignore
        if (!deleteOK && node.getName().equals("CI_RoleCode")) {
            deleteOK = true;
            Element oe = node.getParentElement().getParentElement();
            List<Element> oecs = oe.getChildren();
            for (Element e : oecs) {
                if (e.getName().equals("organisationName")) {
                    List<Element> ecs = e.getChildren();
                    for (Element o : ecs) {
                        if (o.getName().equals("CharacterString")) {
                            String value = StringUtils.deleteWhitespace(o.getText());
                            if (value != null && !value.isEmpty()) {
                                deleteOK = false;
                                break;
                            }
                        }
                    }
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
        return convertElement2Html(e, null);
        
    }
    public static String convertElement2Html(Element e, Boolean viewMode) throws JDOMException, Exception {
        if (e==null) {
            return null;
        }
        Document eDoc = convertElem2Doc(e);
        Document htmlDoc = mdeXml2Html.transform(eDoc, viewMode);
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
        addDateStamp(ppDoc, false);
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
