/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package nl.b3p.catalog.arcgis;

import com.esri.arcgis.datasourcesGDB.SdeWorkspaceFactory;
import com.esri.arcgis.geodatabase.Workspace;
import java.io.IOException;

/**
 *
 * @author Erik van de Pol
 */
public class ArcSDEHelper {
    private static Workspace getWorkspace(String sdeConnectionString) throws IOException {
        SdeWorkspaceFactory factory = new SdeWorkspaceFactory();
        return new Workspace(factory.openFromString(sdeConnectionString, 0));
    }

}
