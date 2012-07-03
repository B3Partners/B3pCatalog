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
import org.jdom.Document;
import org.jdom.JDOMException;
import org.jdom.Namespace;
import org.jdom.input.SAXBuilder;

/**
 *
 * @author Matthijs Laan
 */
public class NCMLSynchronizer {
    public static final String NCML_NAMESPACE = "http://www.unidata.ucar.edu/namespaces/netcdf/ncml-2.2";
    
    public static void synchronizeNCML(Document doc, String ncmlString) throws JDOMException, IOException {
        
        XPathHelper.applyXPathValuePair(doc, XPathHelper.DISTR_FORMAT_NAME, "NetCDF");   
        
        Document ncml = new SAXBuilder().build(new StringReader(ncmlString));   
        
        doc.getRootElement().removeChildren("netcdf", Namespace.getNamespace(NCML_NAMESPACE));
        doc.getRootElement().addContent(ncml.detachRootElement());
    }
    
}
