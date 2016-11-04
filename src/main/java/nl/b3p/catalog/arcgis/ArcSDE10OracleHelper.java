/*
 * Copyright (C) 2011 B3Partners B.V.
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
package nl.b3p.catalog.arcgis;

import com.esri.arcgis.geodatabase.IDataset;
import com.esri.arcgis.geodatabase.IMetadata;
import com.esri.arcgis.geodatabase.XmlPropertySet;
import nl.b3p.catalog.config.SDERoot;

/**
 *
 * @author Chris van Lith
 */
public class ArcSDE10OracleHelper extends ArcSDE10JDBCHelper {
    
    public ArcSDE10OracleHelper(SDERoot root) {
        super(root);
        TABLE_ITEMS = "GDB_ITEMS_VW";
        TABLE_ITEMRELATIONSHIPS = "GDB_ITEMRELATIONSHIPS_VW";
    }
    
    @Override
    public void saveMetadata(ArcSDEJDBCDataset dataset, String metadata) throws Exception {
        IDataset ds = (IDataset)ArcSDEHelperProxy.getArcObjectsDataset(dataset.getRoot(), dataset.getAbsoluteName());
        
        IMetadata imd = (IMetadata)ds.getFullName();
        XmlPropertySet mdPS = (XmlPropertySet)imd.getMetadata();
        mdPS.setXml(metadata);
        imd.setMetadata(mdPS);
    }

}
