/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package nl.b3p.catalog.kaartenbalie;

import nl.b3p.catalog.config.Root;
import nl.b3p.catalog.config.KBRoot;
import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;

/**
  * @author Chris van Lith
 */
public class KbJDBCHelperProxy {
    private final static Log log = LogFactory.getLog(KbJDBCHelperProxy.class);
    
    public static String getMetadata(Root r, String fullPath) throws Exception {
        KBRoot root = (KBRoot) r;
        return root.getJDBCHelper().getMetadata(fullPath);
    }

    public static void saveMetadata(Root r, String fullPath, String metadata) throws Exception {
        KBRoot root = (KBRoot) r;
        root.getJDBCHelper().saveMetadata(fullPath, metadata);
    }
    
    public static String syncMetadata(Root r, String fullPath, String metadata) throws Exception {
        KBRoot root = (KBRoot) r;
        return root.getJDBCHelper().syncMetadata(fullPath, metadata);
    }

}
