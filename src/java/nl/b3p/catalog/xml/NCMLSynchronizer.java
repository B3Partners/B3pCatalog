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
import javax.xml.transform.Transformer;
import javax.xml.transform.TransformerConfigurationException;
import javax.xml.transform.TransformerException;
import javax.xml.transform.TransformerFactory;
import javax.xml.transform.stream.StreamSource;
import org.jdom.Document;
import org.jdom.JDOMException;
import org.jdom.input.SAXBuilder;
import org.jdom.transform.JDOMResult;
import org.jdom.transform.JDOMSource;

/**
 *
 * @author Matthijs Laan
 */
public class NCMLSynchronizer {
    
    public static Document synchronizeNCML(Document doc, String ncmlString) throws JDOMException, IOException, TransformerConfigurationException, TransformerException {
        
        Document ncml = new SAXBuilder().build(new StringReader(ncmlString));   
        // First remove any existing <netcdf> element
        doc.getRootElement().removeChildren("netcdf", Namespaces.NC);
        // Add the NCML as a child of the <metadata> root element
        doc.getRootElement().addContent(ncml.detachRootElement());

        XPathHelper.applyXPathValuePair(doc, XPathHelper.DISTR_FORMAT_NAME, "NetCDF");   
        XPathHelper.applyXPathValuePair(doc, XPathHelper.DISTR_FORMAT_VERSION, "3");   
        
        // Synchronize using a XSLT instead of using XPathHelper
        TransformerFactory tf = TransformerFactory.newInstance();
        Transformer t = tf.newTransformer(new StreamSource(NCMLSynchronizer.class.getResourceAsStream("sync_ncml.xsl")));
        JDOMResult result = new JDOMResult();
        t.transform(new JDOMSource(doc), result);
        
        return result.getDocument();
    }
}
