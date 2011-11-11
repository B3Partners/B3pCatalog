/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package nl.b3p.catalog.arcgis;

import nl.b3p.catalog.B3PCatalogException;
import nl.b3p.catalog.config.Root;
import nl.b3p.catalog.config.SDERoot;
import nl.b3p.catalog.filetree.DirContent;
import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;

/**
 * Why proxy? See FGDBHelperProxy.
 * @author Erik van de Pol
 */
public class ArcSDEHelperProxy {
    private final static Log log = LogFactory.getLog(ArcSDEHelperProxy.class);

    static void rethrow(NoClassDefFoundError ncdfex) throws B3PCatalogException {
        String message = "ArcObjects is niet goed geinitialiseerd. Om metadata te bekijken en weg te schrijven in ArcSDE is dit nodig.";
        log.warn(message, ncdfex);
        throw new ArcObjectsNotFoundException(message, ncdfex);
    }

    public static DirContent getDirContent(Root r, String fullPath) throws Exception {
        try {
            SDERoot root = (SDERoot)r;
            if(root.getJndiDataSource() != null) {
                return root.getJDBCHelper().getDirContent(fullPath);
            } else {
                return ArcSDEHelper.getDirContent(root, fullPath);
            }
        } catch(NoClassDefFoundError ncdfex) {
            rethrow(ncdfex); return null;
        }
    }    
    
    public static Object getDataset(Root r, String path) throws Exception {
        try {
            SDERoot root = (SDERoot)r;
            if(root.getJndiDataSource() != null) {
                return root.getJDBCHelper().getDataset(path);
            } else {
                return ArcSDEHelper.getDataset(root, path);
            }
        } catch(NoClassDefFoundError ncdfex) {
            rethrow(ncdfex); return null;
        }
    }   
    
    public static Object getArcObjectsDataset(Root r, String path) throws Exception {
        try {
            return ArcSDEHelper.getDataset((SDERoot)r, path);
        } catch(NoClassDefFoundError ncdfex) {
            rethrow(ncdfex); return null;
        }
    }        
    
    public static String getMetadata(Object dataset) throws Exception {
        try {
            if(dataset instanceof  ArcSDEJDBCDataset) {
                return ((ArcSDEJDBCDataset)dataset).getRoot().getJDBCHelper().getMetadata((ArcSDEJDBCDataset)dataset);
            } else {
                return ArcSDEHelper.getMetadata(dataset);
            }
        } catch(NoClassDefFoundError ncdfex) {
            rethrow(ncdfex); return null;
        }
    }
    
    public static String getMetadata(Root r, String path) throws Exception {
        try {
            SDERoot root = (SDERoot)r;
            if(root.getJndiDataSource() != null) {
                return ArcSDEJDBCHelper.getMetadata(root, path);
            } else {
                return ArcSDEHelper.getMetadata(ArcSDEHelper.getDataset(root, path));
            }
        } catch(NoClassDefFoundError ncdfex) {
            rethrow(ncdfex); return null;
        }
    }

    public static void saveMetadata(Object dataset, String metadata) throws Exception {
        try {
            if(dataset instanceof  ArcSDEJDBCDataset) {
                ((ArcSDEJDBCDataset)dataset).getRoot().getJDBCHelper().saveMetadata((ArcSDEJDBCDataset)dataset, metadata);            
            } else {
                ArcSDEHelper.saveMetadata(dataset, metadata);
            }
        } catch(NoClassDefFoundError ncdfex) {
            rethrow(ncdfex);
        }
    }
}
