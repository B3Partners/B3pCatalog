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

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.geotools.geometry.jts.ReferencedEnvelope;
import org.geotools.referencing.CRS;
import org.jdom.Document;
import org.jdom.Element;
import org.jdom.JDOMException;
import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;
import org.opengis.referencing.crs.CoordinateReferenceSystem;

/**
 *
 * @author Matthijs Laan
 */
public class ShapefileSynchronizer {
    private static final Log log = LogFactory.getLog(ShapefileSynchronizer.class);

    public static void synchronizeFromLocalAccessJSON(Document doc, String json) throws JDOMException, JSONException {

        XPathHelper.applyXPathValuePair(doc, XPathHelper.DISTR_FORMAT_NAME, "ESRI Shapefile");
        XPathHelper.applyXPathValuePair(doc, XPathHelper.SPATIAL_REPR, "vector");

        JSONObject md = new JSONObject(json);

        if(md.has("title")) {
            String title = md.getString("title");
            XPathHelper.applyXPathValuePair(doc, XPathHelper.TITLE, title);
            XPathHelper.applyXPathValuePair(doc, XPathHelper.FC_TITLE, title);
        }

        double minX = md.getDouble("minX");
        double minY = md.getDouble("minY");
        double maxX = md.getDouble("maxX");
        double maxY = md.getDouble("maxY");

        String prj = md.optString("prj");
        if(prj != null) {
            try {
                CoordinateReferenceSystem sourceCRS = CRS.parseWKT(prj);
                CoordinateReferenceSystem targetCRS = CRS.decode("EPSG:4326");

                ReferencedEnvelope envelope = new ReferencedEnvelope(minX, maxX, minY, maxY, sourceCRS);
                log.debug("Transforming shapefile envelope " + envelope.toString());
                envelope = envelope.transform(targetCRS, true, 50);
                log.debug("Transformed shapefile envelope " + envelope.toString());

                minX = envelope.getMinimum(1);
                minY = envelope.getMinimum(0);
                maxX = envelope.getMaximum(1);
                maxY = envelope.getMaximum(0);

                Integer epsgCode = CRS.lookupEpsgCode(sourceCRS, true);
                if(epsgCode != null) {
                    XPathHelper.applyXPathValuePair(doc, XPathHelper.REF_CODESPACE, "EPSG");
                    XPathHelper.applyXPathValuePair(doc, XPathHelper.REF_CODE, "" + epsgCode);
                    log.debug(String.format("looked up EPSG code %d for WKT string %s", epsgCode, prj));
                } else {
                    log.info(String.format("Failed to lookup EPSG code for WKT string %s", prj));
                }
            } catch(Exception e) {
                log.error("Fout transformeren bbox shapefile van projectie string " + prj, e);
            }
        }

        XPathHelper.applyXPathValuePair(doc, XPathHelper.BBOX_WEST, "" + minX);
        XPathHelper.applyXPathValuePair(doc, XPathHelper.BBOX_EAST, "" + maxX);
        XPathHelper.applyXPathValuePair(doc, XPathHelper.BBOX_SOUTH, "" + minY);
        XPathHelper.applyXPathValuePair(doc, XPathHelper.BBOX_NORTH, "" + maxY);

        // jbd. Debugging. Fills in tab Datasets(1) with test values.
//        XPathHelper.applyXPathValuePair(doc, XPathHelper.TITLE, "" + "DS1_Title_FORCED");
//        XPathHelper.applyXPathValuePair(doc, XPathHelper.ALT_TITLE, "" + "DS1_Alt_Title_FORCED");

        if(md.has("dbf")) {
            JSONArray fields = md.getJSONObject("dbf").getJSONArray("fields");

            Element gfc_FC_FeatureCatalogue = XPathHelper.selectSingleElement(doc, XPathHelper.FEATURE_CATALOG);
            if(gfc_FC_FeatureCatalogue == null) {
                // XXX ook gmx:name aanmaken? mogelijk verplicht in schema
                gfc_FC_FeatureCatalogue = new Element(Names.GFC_FC_FEATURE_CATALOG, Namespaces.GFC);
                doc.getRootElement().addContent(gfc_FC_FeatureCatalogue);
            } else {
                gfc_FC_FeatureCatalogue.removeChildren(Names.GFC_FEATURE_TYPE, Namespaces.GFC);
            }

            Element gfc_featureType = new Element(Names.GFC_FEATURE_TYPE, Namespaces.GFC);
            Element gfc_FC_FeatureType = new Element(Names.GFC_FC_FEATURE_TYPE, Namespaces.GFC);
            gfc_featureType.addContent(gfc_FC_FeatureType);
            gfc_FC_FeatureCatalogue.addContent(gfc_featureType);

            addAttribute(gfc_FC_FeatureType, "SHAPE", md.getString("type"));
            for(int i = 0; i < fields.length(); i++) {
                JSONObject field = fields.getJSONObject(i);

                String name = field.getString("name");
                String type = field.getString("class");
                if(type.startsWith("java.lang.")) {
                    type = type.substring("java.lang.".length());
                }

                addAttribute(gfc_FC_FeatureType, name, type);
            }
        }
    }


    public static void addAttribute(Element gfc_FC_FeatureType, String name, String type) {

        Element gfc_carrierOfCharacteristics = new Element(Names.GFC_CARRIER_OF_CHARACTERISTICS, Namespaces.GFC);
        Element gfc_FC_FeatureAttribute = new Element(Names.GFC_FC_FEATURE_ATTRIBUTE, Namespaces.GFC);

        Element gfc_memberName = new Element(Names.GFC_MEMBER_NAME, Namespaces.GFC);
        Element field_gco_LocalName = new Element(Names.GCO_LOCAL_NAME, Namespaces.GCO);
        field_gco_LocalName.setText(name);
        gfc_memberName.addContent(field_gco_LocalName);

        gfc_FC_FeatureAttribute.addContent(gfc_memberName);

        Element gfc_valueType = new Element(Names.GFC_VALUE_TYPE, Namespaces.GFC);
        Element gco_TypeName = new Element(Names.GCO_TYPE_NAME, Namespaces.GCO);
        Element gco_aName = new Element(Names.GCO_A_NAME, Namespaces.GCO);
        Element gco_CharacterString = new Element(Names.GCO_CHARACTER_STRING, Namespaces.GCO);
        gco_CharacterString.setText(type);
        gco_aName.addContent(gco_CharacterString);
        gco_TypeName.addContent(gco_aName);
        gfc_valueType.addContent(gco_TypeName);

        gfc_FC_FeatureAttribute.addContent(gfc_valueType);

        gfc_carrierOfCharacteristics.addContent(gfc_FC_FeatureAttribute);
        gfc_FC_FeatureType.addContent(gfc_carrierOfCharacteristics);
    }
}
