package nl.b3p.catalog.stripes;

import java.util.List;
import net.sourceforge.stripes.action.ActionBeanContext;
import net.sourceforge.stripes.action.ForwardResolution;
import net.sourceforge.stripes.action.Resolution;
import net.sourceforge.stripes.action.StrictBinding;
import net.sourceforge.stripes.validation.Validate;
import nl.b3p.catalog.B3PCatalogException;
import nl.b3p.catalog.config.AclAccess;
import nl.b3p.catalog.config.CatalogAppConfig;
import nl.b3p.catalog.config.FileRoot;
import nl.b3p.catalog.config.Root;
import nl.b3p.catalog.config.SDERoot;
import nl.b3p.catalog.filetree.Dir;
import nl.b3p.catalog.filetree.DirContent;
import nl.b3p.catalog.resolution.HtmlErrorResolution;
import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;

@StrictBinding
public class FiletreeAction extends DefaultAction {
    private final static Log log = LogFactory.getLog(FiletreeAction.class);

    private final static String DIRCONTENTS_JSP = "/WEB-INF/jsp/main/file/filetreeConnector.jsp";

    private DirContent dirContent;

    @Validate
    private String dir;   
    
    /* TODO: eigenlijk moet er voor front-end geen verschil zijn tussen listDir 
     * en listSDEDir. JavaScript code is nogal hairy om meteen aan te passen
     */
    
    public Resolution listDir() {
        log.debug("listDir: " + dir);
        return list(FileRoot.class);
    }    
    
    public Resolution listSDEDir() {
        log.debug("listDir: " + dir);
        return list(SDERoot.class);
    }    
    
    private static int getRootIndex(String dir) {
        int i = dir.indexOf(DirContent.SEPARATOR);
        return Integer.parseInt(dir.substring(0,i));
    }
    
    static Root getRoot(ActionBeanContext context, String dir, AclAccess minimumAccessLevel) throws B3PCatalogException {
        Root r = CatalogAppConfig.getConfig().getRoots().get(getRootIndex(dir));
        if(r.isRequestUserAuthorizedFor(context.getRequest(), minimumAccessLevel)) {
            return r;
        } else {
            throw new B3PCatalogException("Not authorized for required minimum access level " + minimumAccessLevel.name());
        }
    }
    
    static String getPath(String dir) {
        return dir.substring(dir.indexOf(DirContent.SEPARATOR)+1);
    }
        
    private Resolution list(Class clazz) {
        try {
            if(dir == null) {
                dirContent = getRoots(clazz);
            } else {
                int index = getRootIndex(dir);
                Root r = getRoot(getContext(), dir, AclAccess.READ);
                String path = getPath(dir);
               
                dirContent = r.getDirContent(index + "" + DirContent.SEPARATOR, path);
                dirContent.sort();                
            }

            return new ForwardResolution(DIRCONTENTS_JSP);
        } catch(Exception ex) {
            String message = "Niet gelukt directory inhoud te tonen";
            log.error(message, ex);
            return new HtmlErrorResolution(message, ex);
        }
    }

    private DirContent getRoots(Class clazz) {
        DirContent dc = new DirContent();
        List<Root> roots = CatalogAppConfig.getConfig().getRoots();
            
        for(int i = 0; i < roots.size(); i++) {
            Root r = roots.get(i);
            if(r.getClass().equals(clazz) && r.isRequestUserAuthorizedFor(getContext().getRequest(), AclAccess.READ)) {
                Dir d = new Dir();
                d.setPath(i + "" + DirContent.SEPARATOR);
                d.setName(roots.get(i).getName());
                dc.getDirs().add(d);
            }
        }
        return dc;        
    }   

    public String getDir() {
        return dir;
    }

    public void setDir(String dir) {
        this.dir = dir;
    }

    public DirContent getDirContent() {
        return dirContent;
    }

    public void setDirContent(DirContent dirContent) {
        this.dirContent = dirContent;
    }
}
