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
package nl.b3p.catalog.config;

import java.io.File;
import java.io.IOException;
import java.io.StringWriter;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.HashMap;
import java.util.HashSet;
import java.util.List;
import java.util.Locale;
import java.util.Map;
import java.util.Set;
import javax.servlet.ServletContextEvent;
import javax.servlet.ServletContextListener;
import javax.servlet.http.HttpServletRequest;
import javax.xml.bind.JAXBContext;
import javax.xml.bind.JAXBException;
import javax.xml.bind.Marshaller;
import javax.xml.bind.annotation.XmlAttribute;
import javax.xml.bind.annotation.XmlElement;
import javax.xml.bind.annotation.XmlElementWrapper;
import javax.xml.bind.annotation.XmlElements;
import javax.xml.bind.annotation.XmlList;
import javax.xml.bind.annotation.XmlRootElement;
import javax.xml.bind.annotation.XmlTransient;
import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;

/**
 *
 * @author Matthijs Laan
 */
@XmlRootElement
public class CatalogAppConfig implements ServletContextListener {
    private static final Log log = LogFactory.getLog(CatalogAppConfig.class);
    
    private static CatalogAppConfig config;
    
    private static final String CURRENT_VERSION = "1.0";
    
    @XmlAttribute
    private String version;
    
    private String configFilePath;
    
    @XmlElement(name="arcobjects")
    private ArcObjectsConfig arcObjectsConfig = new ArcObjectsConfig();
    
    @XmlElementWrapper(name="roots")
    @XmlElements({
        @XmlElement(name="fileRoot", type=FileRoot.class),
        @XmlElement(name="sdeRoot", type=SDERoot.class),
        @XmlElement(name="kbRoot", type=KBRoot.class)
    })
    private List<Root> roots = new ArrayList<Root>();
    
    @XmlList
    private Set<String> geoFileExtensions = new HashSet<String>(Arrays.asList(
            new String[] {"gml", "shp", "dxf", "dgn", "sdf", "sdl", "lyr", "ecw", "sid", "tif", "tiff", "asc", "mdb"}
    ));
    
    @XmlElementWrapper
    @XmlElements({
        @XmlElement(name="cswServer", required=false)
    })
    private List<CSWServerConfig> cswServers = new ArrayList<CSWServerConfig>();
   
    @XmlElementWrapper
    private Map<String, String> mdeConfig = new HashMap<String, String>();

    private String organizationsJsonFile = "organizations.json";

    //<editor-fold defaultstate="collapsed" desc="getters en setters">
    @XmlTransient
    public String getVersion() {
        return version;
    }

    public void setVersion(String version) {
        this.version = version;
    }

    public String getConfigFilePath() {
        return configFilePath;
    }

    public void setConfigFilePath(String configFilePath) {
        this.configFilePath = configFilePath;
    }
    
    @XmlTransient
    public ArcObjectsConfig getArcObjectsConfig() {
        return arcObjectsConfig;
    }

    public void setArcObjectsConfig(ArcObjectsConfig arcObjectsConfig) {
        this.arcObjectsConfig = arcObjectsConfig;
    }

    @XmlTransient
    public List<CSWServerConfig> getCswServers() {
        return cswServers;
    }
    
    public void setCswServers(List<CSWServerConfig> cswServers) {
        this.cswServers = cswServers;
    }

    @XmlTransient
    public List<Root> getRoots() {
        return roots;
    }

    public void setRoots(List<Root> roots) {
        this.roots = roots;
    }
    
    @XmlTransient
    public Set<String> getGeoFileExtensions() {
        return geoFileExtensions;
    }
    
    public void setGeoFileExtensions(Set<String> geoFileExtensions) {
        this.geoFileExtensions = geoFileExtensions;
    }

    @XmlTransient
    public Map<String, String> getMdeConfig() {
        return mdeConfig;
    }

    public void setMdeConfig(Map<String, String> mdeConfig) {
        this.mdeConfig = mdeConfig;
    }
    
    public String getOrganizationsJsonFile() {
        return organizationsJsonFile;
    }

    public void setOrganizationsJsonFile(String organizationsJsonFile) {
        this.organizationsJsonFile = organizationsJsonFile;
    }
    //</editor-fold>

    public CSWServerConfig getDefaultCswServer() {
       List<CSWServerConfig> csws = getCswServers();
        if (csws==null || csws.isEmpty()) {
            return null;
        }
        CSWServerConfig csw = csws.get(0);
        if (csw.getCswName()==null || csw.getCswName().isEmpty()) {
            return null;
        }
        return csw;
    }

    public static CatalogAppConfig getConfig() {
        return config;
    }
    
    public static CatalogAppConfig loadFromFile(File f) throws JAXBException, IOException {
        JAXBContext ctx = JAXBContext.newInstance(CatalogAppConfig.class);
        
        CatalogAppConfig cfg = (CatalogAppConfig)ctx.createUnmarshaller().unmarshal(f);
        cfg.setConfigFilePath(f.getParentFile().getCanonicalPath());
        return cfg;
    }

    @Override
    public void contextInitialized(ServletContextEvent sce) {
        
        String configParam = sce.getServletContext().getInitParameter("config");

        if(configParam == null) {
            throw new IllegalArgumentException("No config file specified in \"config\" context init parameter");
        }
        
        File f = new File(configParam);        
        if(!f.isAbsolute()) {
            String catalinaBase = System.getProperty("catalina.base");
            if(catalinaBase != null) {
                f = new File(catalinaBase, configParam);
            } else {
                // just use current directory whatever that may be
            }
        }         
        String canonicalPath = null;
        try {
            canonicalPath = f.getCanonicalPath();
        } catch(IOException e) {
            canonicalPath = "[IOException: " + e.getMessage() + "]";
        }
        log.info("Loading configuration from file " + canonicalPath);
        
        if(!f.exists() || !f.canRead()) {
            throw new IllegalArgumentException(
                    String.format(Locale.ENGLISH,
                            "Config file specified in \"config\" context init parameter with value \"%s\" (canonical path \"%s\") does not exist or cannot be read",
                            configParam,
                            canonicalPath
                    ));
        }

        try {
            config = loadFromFile(f);
            log.debug("Configuration loaded; marshalling for log");
        
            JAXBContext ctx = JAXBContext.newInstance(CatalogAppConfig.class);
            Marshaller m = ctx.createMarshaller();
            m.setProperty("jaxb.formatted.output", Boolean.TRUE);
        
            StringWriter sw = new StringWriter();
            m.marshal(config, sw);        
            log.info("Parsed configuration: \n" + sw.toString());
            
            if(!CURRENT_VERSION.equals(config.getVersion())) {
                throw new Exception(String.format(
                        Locale.ENGLISH,
                        "Wrong configuration file version: %s, must be %s",
                        config.getVersion(),
                        CURRENT_VERSION
                ));
            }
        } catch(Exception e) {
            log.error("Error loading configuration", e);
            throw new IllegalArgumentException("Error loading configuration from file \"" + canonicalPath + '"',e );
        }
        
        if(log.isDebugEnabled()) {
            config.getRoots().forEach((r) -> {
                log.debug(String.format(Locale.ENGLISH, "Role access list for root %s: %s", r.getName(), r.getRoleAccessList().toString()));
            });
        }        
    }
    
    public boolean isAddOnly(HttpServletRequest request) {
        if (roots==null || roots.isEmpty()) {
            return false;
        }
        boolean addOnly = false;
        for (Root root : roots) {
            AclAccess highest = root.getRequestUserHighestAccessLevel(request);
            if (highest.getSecurityLevel() == AclAccess.ADD.getSecurityLevel()) {
                addOnly = true;
            }
            if (highest.getSecurityLevel() != AclAccess.ADD.getSecurityLevel()) {
                return false;
            }
        }
        return addOnly;
    }
    
    public int getRequestUserHighestAccessLevel(HttpServletRequest request) {
        int highestAccess = AclAccess.NONE.getSecurityLevel();
        for (Root root : roots) {
            AclAccess highest = root.getRequestUserHighestAccessLevel(request);
            if (highest.getSecurityLevel() > highestAccess) {
                highestAccess = highest.getSecurityLevel();
            }
        }
        return highestAccess;
    }

    
    @Override
    public void contextDestroyed(ServletContextEvent sce) {
    }
}
