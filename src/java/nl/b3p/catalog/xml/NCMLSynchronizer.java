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
import java.io.StringReader;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.List;
import org.jdom.Document;
import org.jdom.Element;
import org.jdom.JDOMException;
import org.jdom.Namespace;
import org.jdom.input.SAXBuilder;

/**
 *
 * @author Matthijs Laan
 */
public class NCMLSynchronizer {
    
    public static void synchronizeNCML(Document doc, String ncmlString) throws JDOMException, IOException {
        
        Document ncml = new SAXBuilder().build(new StringReader(ncmlString));   
        // First remove any existing <netcdf> element
        doc.getRootElement().removeChildren("netcdf", Namespaces.NC);
        // Add the NCML as a child of the <metadata> root element
        doc.getRootElement().addContent(ncml.detachRootElement());
        Element netcdf = doc.getRootElement().getChild("netcdf", Namespaces.NC);
        
        // Synchronize NCML to ISO 19139 XML
        
        XPathHelper.applyXPathValuePair(doc, XPathHelper.DISTR_FORMAT_NAME, "NetCDF");   
        
        // First synchronize global NetCDF properties such as "title" which are 
        // required in the "NetCDF Climate and Forecast (CF) Metadata Conventions"
        // to ISO fields.

        copyGlobalAttribute(doc, netcdf, "title", XPathHelper.TITLE);
        copyGlobalAttribute(doc, netcdf, "source", XPathHelper.DQ_LI_STATEMENT);
        copyGlobalAttribute(doc, netcdf, "institution", XPathHelper.POC_RESPONSIBLE_PARTY_ORG);
        copyGlobalAttribute(doc, netcdf, "email", XPathHelper.POC_RESPONSIBLE_PARTY_EMAIL);
        
        copyGlobalAttribute(doc, netcdf, "terms_for_use", XPathHelper.RESOURCE_CONSTRAINTS_USELIMITATION);

        // Put some info in the abstract
        
        StringBuffer netcdfSummary = new StringBuffer("NetCDF metadata global attributes:\n");
        int initialLength = netcdfSummary.length();
        addGlobalAttributeSummary(netcdfSummary, netcdf, "references");
        addGlobalAttributeSummary(netcdfSummary, netcdf, "comment");
        addGlobalAttributeSummary(netcdfSummary, netcdf, "version");
        addGlobalAttributeSummary(netcdfSummary, netcdf, "disclaimer");
        addGlobalAttributeSummary(netcdfSummary, netcdf, "Conventions");
        addGlobalAttributeSummary(netcdfSummary, netcdf, "history");
        
        if(netcdfSummary.length() > initialLength) {
            XPathHelper.applyXPathValuePair(doc, XPathHelper.ABSTRACT, netcdfSummary.toString());    
        }        
        
        copyGlobalAttribute(doc, netcdf, "geospatial_lat_min", XPathHelper.BBOX_SOUTH);
        copyGlobalAttribute(doc, netcdf, "geospatial_lat_max", XPathHelper.BBOX_NORTH);
        copyGlobalAttribute(doc, netcdf, "geospatial_lon_min", XPathHelper.BBOX_WEST);
        copyGlobalAttribute(doc, netcdf, "geospatial_lon_max", XPathHelper.BBOX_EAST);
        
        copyGlobalDateAttribute(doc, netcdf, "time_coverage_start", XPathHelper.EX_TEMPORAL_BEGIN);
        copyGlobalDateAttribute(doc, netcdf, "time_coverage_end", XPathHelper.EX_TEMPORAL_END);
        
        // TODO: synchronize iso_dataset attributes!
        // For the standard used, see:http://adaguc.knmi.nl/contents/documents/ADAGUC_Standard.html
        
        // In the ADAGUC Standard, ISO metadata is saved in the "iso_dataset"
        // variable.
        // These will override the values set above.
    }
    
    private static void copyGlobalAttribute(Document doc, Element netcdf, String attributeName, String isoXPath) throws JDOMException {
        String attribute = getGlobalAttribute(netcdf, attributeName);
        if(attribute != null) {
            XPathHelper.applyXPathValuePair(doc, isoXPath, attribute);
        }
    }
    
    private static void copyGlobalDateAttribute(Document doc, Element netcdf, String attributeName, String isoXPath) {
        String date = getGlobalAttribute(netcdf, attributeName);
        if(date != null) {
            try {
                SimpleDateFormat df = new SimpleDateFormat("yyyy-MM-dd");
                Date d = df.parse(date);
                XPathHelper.applyXPathValuePair(doc, isoXPath, df.format(d));
            } catch (Exception e) {
            }
        }
    }
    
    private static String getGlobalAttribute(Element netcdf, String name) {
        for(Element attribute: (List<Element>)netcdf.getChildren("attribute", Namespaces.NC)) {
            if(attribute.getAttributeValue("name").equals(name)) {
                return attribute.getAttributeValue("value");
            }
        }
        return null;
    }
    
    private static void addGlobalAttributeSummary(StringBuffer summary, Element netcdf, String attributeName) {
        String attribute = getGlobalAttribute(netcdf, attributeName);
        if(attribute != null && attribute.trim().length() > 0) {
            summary.append(attributeName);
            summary.append(": ");
            summary.append(attribute);
            summary.append("\n");
        }           
    }
    
    
}
