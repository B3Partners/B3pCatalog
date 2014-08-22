/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package nl.b3p.catalog.xml;

import java.util.List;
import org.jdom.Element;
import org.jdom.JDOMException;
import org.jdom.Namespace;
import org.jdom.xpath.XPath;

/**
 *
 * @author Erik van de Pol
 */
public class XPathHelper {
    
    // Xpath for entries how they appear in the MDE.
    public final static String DOM_DC_TITLE = "/metadata/b3p:B3Partners/pbl:metadataPBL/dc:title";
    public final static String DOM_DS1_ORGANISATION_NAME = "/metadata/gmd:MD_Metadata/gmd:identificationInfo/gmd:MD_DataIdentification/gmd:pointOfContact/gmd:CI_ResponsibleParty/gmd:organisationName/gco:CharacterString";
    public final static String DOM_DS2_ORGANISATION_NAME = "/metadata/gmd:MD_Metadata/gmd:dataQualityInfo/gmd:DQ_DataQuality/gmd:lineage/gmd:LI_Lineage/gmd:source/gmd:LI_Source/gmd:sourceStep/gmd:LI_ProcessStep/gmd:processor/gmd:CI_ResponsibleParty/gmd:organisationName/gco:CharacterString";
    public final static String DOM_DS3_ORGANISATION_NAME = "/metadata/gmd:MD_Metadata/gmd:contact/gmd:CI_ResponsibleParty/gmd:organisationName/gco:CharacterString";
    
    public final static String DOM_DS1_ADDRESS = "/metadata/gmd:MD_Metadata/gmd:identificationInfo/gmd:MD_DataIdentification/gmd:pointOfContact/gmd:CI_ResponsibleParty/gmd:contactInfo/gmd:CI_Contact/gmd:address/gmd:CI_Address/gmd:deliveryPoint/gco:CharacterString" ;
    public final static String DOM_DS2_ADDRESS = "";
    public final static String DOM_DS3_ADDRESS = "";
    
    public final static String DOM_DS1_CITY = "/metadata/gmd:MD_Metadata/gmd:identificationInfo/gmd:MD_DataIdentification/gmd:pointOfContact/gmd:CI_ResponsibleParty/gmd:contactInfo/gmd:CI_Contact/gmd:address/gmd:CI_Address/gmd:city/gco:CharacterString";
    public final static String DOM_DS2_CITY = "";
    public final static String DOM_DS3_CITY = "";
    
    public final static String DOM_DS1_POSTCALCODE = "/metadata/gmd:MD_Metadata/gmd:identificationInfo/gmd:MD_DataIdentification/gmd:pointOfContact/gmd:CI_ResponsibleParty/gmd:contactInfo/gmd:CI_Contact/gmd:address/gmd:CI_Address/gmd:postalCode/gco:CharacterString";
    public final static String DOM_DS2_POSTCALCODE = "";
    public final static String DOM_DS3_POSTCALCODE = "";
    
    public final static String DOM_DS1_COUNTRY = "/metadata/gmd:MD_Metadata/gmd:identificationInfo/gmd:MD_DataIdentification/gmd:pointOfContact/gmd:CI_ResponsibleParty/gmd:contactInfo/gmd:CI_Contact/gmd:address/gmd:CI_Address/gmd:administrativeArea/gco:CharacterString" ;
    public final static String DOM_DS2_COUNTRY = "";
    public final static String DOM_DS3_COUNTRY = "";
    
    public final static String DOM_DS1_URL = "/metadata/gmd:MD_Metadata/gmd:identificationInfo/gmd:MD_DataIdentification/gmd:pointOfContact/gmd:CI_ResponsibleParty/gmd:contactInfo/gmd:CI_Contact/gmd:onlineResource/gmd:CI_OnlineResource/gmd:linkage/gmd:URL" ;
    public final static String DOM_DS2_URL = "";
    public final static String DOM_DS3_URL = "";
    
    public final static String DOM_DS1_EMAIL = "/metadata/gmd:MD_Metadata/gmd:identificationInfo/gmd:MD_DataIdentification/gmd:pointOfContact/gmd:CI_ResponsibleParty/gmd:contactInfo/gmd:CI_Contact/gmd:address/gmd:CI_Address/gmd:electronicMailAddress/gco:CharacterString" ;
    public final static String DOM_DS2_EMAIL = "";
    public final static String DOM_DS3_EMAIL = "";
    
    public final static String DOM_DS1_VOICE = "/metadata/gmd:MD_Metadata/gmd:identificationInfo/gmd:MD_DataIdentification/gmd:pointOfContact/gmd:CI_ResponsibleParty/gmd:contactInfo/gmd:CI_Contact/gmd:phone/gmd:CI_Telephone/gmd:voice/gco:CharacterString" ;
    public final static String DOM_DS2_VOICE = "";
    public final static String DOM_DS3_VOICE = "";
    
    public final static String DOM_DS1_CONTACTS1_EMAIL = "";
    public final static String DOM_DS2_CONTACTS1_EMAIL = "";
    
    
    // Xpath for entries in an XML file
    
    public final static String TITLE = "/*/gmd:MD_Metadata/gmd:identificationInfo/gmd:MD_DataIdentification/gmd:citation/gmd:CI_Citation/gmd:title/gco:CharacterString";
    public final static String ALT_TITLE = "/*/gmd:MD_Metadata/gmd:identificationInfo/gmd:MD_DataIdentification/gmd:citation/gmd:CI_Citation/gmd:alternateTitle/gco:CharacterString";
    
    public static final String ABSTRACT = "/*/gmd:MD_Metadata/gmd:identificationInfo/gmd:MD_DataIdentification/gmd:abstract/gco:CharacterString";
    public final static String REF_CODESPACE = "/*/gmd:MD_Metadata/gmd:referenceSystemInfo/gmd:MD_ReferenceSystem/gmd:referenceSystemIdentifier/gmd:RS_Identifier/gmd:codeSpace/gco:CharacterString";
    public final static String REF_CODE = "/*/gmd:MD_Metadata/gmd:referenceSystemInfo/gmd:MD_ReferenceSystem/gmd:referenceSystemIdentifier/gmd:RS_Identifier/gmd:code/gco:CharacterString";
    public final static String BBOX_WEST = "/*/gmd:MD_Metadata/gmd:identificationInfo/gmd:MD_DataIdentification/gmd:extent/gmd:EX_Extent/gmd:geographicElement/gmd:EX_GeographicBoundingBox/gmd:westBoundLongitude/gco:Decimal";
    public final static String BBOX_EAST = "/*//gmd:MD_Metadata/gmd:identificationInfo/gmd:MD_DataIdentification/gmd:extent/gmd:EX_Extent/gmd:geographicElement/gmd:EX_GeographicBoundingBox/gmd:eastBoundLongitude/gco:Decimal";
    public final static String BBOX_NORTH = "/*/gmd:MD_Metadata/gmd:identificationInfo/gmd:MD_DataIdentification/gmd:extent/gmd:EX_Extent/gmd:geographicElement/gmd:EX_GeographicBoundingBox/gmd:northBoundLatitude/gco:Decimal";
    public final static String BBOX_SOUTH = "/*/gmd:MD_Metadata/gmd:identificationInfo/gmd:MD_DataIdentification/gmd:extent/gmd:EX_Extent/gmd:geographicElement/gmd:EX_GeographicBoundingBox/gmd:southBoundLatitude/gco:Decimal";
    
    public final static String SPATIAL_REPR = "/*/gmd:MD_Metadata/gmd:identificationInfo/gmd:MD_DataIdentification/gmd:spatialRepresentationType/gmd:MD_SpatialRepresentationTypeCode";

    public final static String DISTR_FORMAT_NAME = "/*/gmd:MD_Metadata/gmd:distributionInfo/gmd:MD_Distribution/gmd:distributionFormat[1]/gmd:MD_Format/gmd:name/gco:CharacterString";
    public final static String DISTR_FORMAT_VERSION = "/*/gmd:MD_Metadata/gmd:distributionInfo/gmd:MD_Distribution/gmd:distributionFormat[1]/gmd:MD_Format/gmd:version/gco:CharacterString";

    public final static String URL_DATASET = "/*/gmd:MD_Metadata/gmd:distributionInfo/gmd:MD_Distribution/gmd:transferOptions/gmd:MD_DigitalTransferOptions/gmd:onLine[1]/gmd:CI_OnlineResource/gmd:linkage/gmd:URL";
    public final static String NAME_DATASET = "/*/gmd:MD_Metadata/gmd:distributionInfo/gmd:MD_Distribution/gmd:transferOptions/gmd:MD_DigitalTransferOptions/gmd:onLine[1]/gmd:CI_OnlineResource/gmd:name/gco:CharacterString";
    public final static String PROTOCOL_DATASET = "/*/gmd:MD_Metadata/gmd:distributionInfo/gmd:MD_Distribution/gmd:transferOptions/gmd:MD_DigitalTransferOptions/gmd:onLine[1]/gmd:CI_OnlineResource/gmd:protocol/gco:CharacterString";
    public final static String DESC_DATASET = "/*/gmd:MD_Metadata/gmd:distributionInfo/gmd:MD_Distribution/gmd:transferOptions/gmd:MD_DigitalTransferOptions/gmd:onLine[1]/gmd:CI_OnlineResource/gmd:description/gco:CharacterString";

    public final static String FEATURE_CATALOG = "/*/gfc:FC_FeatureCatalogue";
    public final static String FC_TITLE = "/*/gfc:FC_FeatureCatalogue/gmx:name/gco:CharacterString";

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
        for(Namespace ns: Namespaces.allNamespaces) {
            xpath.addNamespace(ns);
        }
        return xpath;
    }

}