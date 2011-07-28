/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package nl.b3p.catalog.xml;

import java.util.List;
import org.jdom.Element;
import org.jdom.JDOMException;
import org.jdom.xpath.XPath;

/**
 *
 * @author Erik van de Pol
 */
public class XPathHelper {
    public final static String TITLE = "/*/gmd:MD_Metadata/gmd:identificationInfo/gmd:MD_DataIdentification/gmd:citation/gmd:CI_Citation/gmd:title/gco:CharacterString";
    public final static String ALT_TITLE = "/*/gmd:MD_Metadata/gmd:identificationInfo/gmd:MD_DataIdentification/gmd:citation/gmd:CI_Citation/gmd:alternateTitle/gco:CharacterString";
    
    public final static String REF_CODESPACE = "/*/gmd:MD_Metadata/gmd:referenceSystemInfo/gmd:MD_ReferenceSystem/gmd:referenceSystemIdentifier/gmd:RS_Identifier/gmd:codeSpace/gco:CharacterString";
    public final static String REF_CODE = "/*/gmd:MD_Metadata/gmd:referenceSystemInfo/gmd:MD_ReferenceSystem/gmd:referenceSystemIdentifier/gmd:RS_Identifier/gmd:code/gco:CharacterString";
    public final static String BBOX_WEST = "/*/gmd:MD_Metadata/gmd:identificationInfo/gmd:MD_DataIdentification/gmd:extent/gmd:EX_Extent/gmd:geographicElement/gmd:EX_GeographicBoundingBox/gmd:westBoundLongitude/gco:Decimal";
    public final static String BBOX_EAST = "/*//gmd:MD_Metadata/gmd:identificationInfo/gmd:MD_DataIdentification/gmd:extent/gmd:EX_Extent/gmd:geographicElement/gmd:EX_GeographicBoundingBox/gmd:eastBoundLongitude/gco:Decimal";
    public final static String BBOX_NORTH = "/*/gmd:MD_Metadata/gmd:identificationInfo/gmd:MD_DataIdentification/gmd:extent/gmd:EX_Extent/gmd:geographicElement/gmd:EX_GeographicBoundingBox/gmd:northBoundLatitude/gco:Decimal";
    public final static String BBOX_SOUTH = "/*/gmd:MD_Metadata/gmd:identificationInfo/gmd:MD_DataIdentification/gmd:extent/gmd:EX_Extent/gmd:geographicElement/gmd:EX_GeographicBoundingBox/gmd:southBoundLatitude/gco:Decimal";
    
    public final static String SPATIAL_REPR = "/*/gmd:MD_Metadata/gmd:identificationInfo/gmd:MD_DataIdentification/gmd:spatialRepresentationType/gmd:MD_SpatialRepresentationTypeCode";

    public final static String URL_DATASET = "/*/gmd:MD_Metadata/gmd:distributionInfo/gmd:MD_Distribution/gmd:transferOptions/gmd:MD_DigitalTransferOptions/gmd:onLine[1]/gmd:CI_OnlineResource/gmd:linkage/gmd:URL";
    public final static String NAME_DATASET = "/*/gmd:MD_Metadata/gmd:distributionInfo/gmd:MD_Distribution/gmd:transferOptions/gmd:MD_DigitalTransferOptions/gmd:onLine[1]/gmd:CI_OnlineResource/gmd:name/gco:CharacterString";
    public final static String PROTOCOL_DATASET = "/*/gmd:MD_Metadata/gmd:distributionInfo/gmd:MD_Distribution/gmd:transferOptions/gmd:MD_DigitalTransferOptions/gmd:onLine[1]/gmd:CI_OnlineResource/gmd:protocol/gco:CharacterString";
    public final static String DESC_DATASET = "/*/gmd:MD_Metadata/gmd:distributionInfo/gmd:MD_Distribution/gmd:transferOptions/gmd:MD_DigitalTransferOptions/gmd:onLine[1]/gmd:CI_OnlineResource/gmd:description/gco:CharacterString";

    public final static String FEATURE_CATALOG = "/*/gfc:FC_FeatureCatalogue";

    public static void applyXPathValuePair(Object context, String xpathString, String value) throws JDOMException {
        Element element = selectSingleElement(context, xpathString);
        if (element != null) {
            element.setText(value);
        }
    }

    public static Element selectSingleElement(Object context, String xpathString) throws JDOMException {
        return (Element)selectSingleNode(context, xpathString);
    }
    
    public static Object selectSingleNode(Object context, String xpathString) throws JDOMException {
        return getXPath(xpathString).selectSingleNode(context);
    }

    public static List selectNodes(Object context, String xpathString) throws JDOMException {
        return getXPath(xpathString).selectNodes(context);
    }

    public static XPath getXPath(String xpathString) throws JDOMException {
        XPath xpath = XPath.newInstance(xpathString);
        xpath.addNamespace(Namespaces.GMD);
        xpath.addNamespace(Namespaces.GCO);
        xpath.addNamespace(Namespaces.GFC);
        return xpath;
    }

}