/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package nl.b3p.catalog.filetree;

import java.util.HashMap;
import java.util.Map;
import nl.b3p.catalog.B3PCatalogException;

/**
 *
 * @author Erik van de Pol
 */
public class ArcSDERoot extends Root {
    protected Map<String, String> connectionMap;
    protected String connectionString;
    protected String ppString;
    
    public ArcSDERoot(String connectionString, String prettyName) throws B3PCatalogException {
        super(connectionString, prettyName);
        connectionMap = new HashMap<String, String>();
        String[] kvPairs = connectionString.trim().split(";");
        for (String kvPair : kvPairs) {
            String[] keyAndValue = kvPair.trim().split("=");
            if (keyAndValue.length != 2)
                throw new B3PCatalogException("Connection string to ArcSDE db is incorrect. See web.xml.");
            connectionMap.put(keyAndValue[0].trim(), keyAndValue[1].trim());
        }
        // We can't expose the entire connection string to the user. It may contain a username and password.
        // is dit genoeg voor alle soorten db's? beter is misschien om dit soort dingen in een DB op te slaan en gewoon een row-id uit de DB door te geven.
        ppString = connectionMap.get("server") + 
                Rewrite.PRETTY_DIR_SEPARATOR + 
                (connectionMap.get("instance") != null ? connectionMap.get("instance") : "") + 
                Rewrite.PRETTY_DIR_SEPARATOR + 
                connectionMap.get("database");
    }
    
    @Override
    public String getPath() {
        return ppString;
    }
    
    public String getConnectionString() {
        return connectionString;
    }
    
}
