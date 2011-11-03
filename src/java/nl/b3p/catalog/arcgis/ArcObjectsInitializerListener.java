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

import java.io.File;
import java.lang.reflect.Method;
import java.net.URL;
import java.net.URLClassLoader;
import java.util.Arrays;
import java.util.List;
import javax.servlet.ServletContextEvent;
import javax.servlet.ServletContextListener;
import nl.b3p.catalog.config.ArcObjectsConfig;
import nl.b3p.catalog.config.CatalogAppConfig;
import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;

/**
 * Initialiseert ArcObjects. Moet in web.xml staan onder CatalogAppConfig.
 *
 * @author Matthijs Laan
 */
public class ArcObjectsInitializerListener implements ServletContextListener {
    private final static Log log = LogFactory.getLog(ArcObjectsInitializerListener.class);

    private ArcObjectsInitializer initializer;

    public boolean isInitialized() {
        return initializer != null;
    }
    
    public void contextInitialized(ServletContextEvent sce) {
        
        CatalogAppConfig cfg = CatalogAppConfig.getConfig();
        
        if(cfg == null || cfg.getArcObjectsConfig() == null || !cfg.getArcObjectsConfig().isEnabled()) {
            log.info("ArcObjects is disabled by config");
            return;
        }
        ArcObjectsConfig aoCfg = cfg.getArcObjectsConfig();
        try {
            log.info("Attempting to add ArcObjects jar to classpath...");
            linkArcObjects(aoCfg.getArcEngineHome());
            log.info("OK, initializing license");

            ArcObjectsInitializer.initializeLicenseWithStringCodes(aoCfg.getProductCodes());

        } catch (Exception e) {
            log.error("Error initializing ArcObjects", e);
            initializer = null;
        }        
    }
    
    public void contextDestroyed(ServletContextEvent sce) {
        try {
            ArcObjectsInitializer.shutdown();
        } catch(Exception e) {
            log.error("Error shutting down ArcObjects", e);
        }
    }
    
    private static List<String> homeEnvVars = Arrays.asList(new String[] {
        "AGSENGINEJAVA", "AGSDESKTOPJAVA", "ARCGISHOME"});    
    
    private void linkArcObjects(String arcObjectsHome) throws Exception {
        
        if(arcObjectsHome == null) {
            for(String s: homeEnvVars) {
                arcObjectsHome = System.getenv(s);
                if(arcObjectsHome != null) {
                    break;
                }
            }
        }
        if (arcObjectsHome == null) {
            throw new Exception("Could not find ArcObjects home in environment variables " + homeEnvVars + ". "
                        + (System.getProperty("os.name").toLowerCase().indexOf("win") > -1
                        ? "ArcGIS Engine Runtime or ArcGIS Desktop must be installed"
                        : "ArcGIS Engine Runtime must be installed"));
        }   
        
        String jarPath = arcObjectsHome + File.separator + "java" + File.separator + "lib" + File.separator + "arcobjects.jar";
        File jarFile = new File(jarPath);

        if(!jarFile.exists()) {
            throw new Exception("Error: could not find arcobjects.jar at path \"" + jarFile.getAbsolutePath() + "\"");
        }        
        

        log.info(String.format("Using ArcObjects home \"%s\"", arcObjectsHome));

        //Helps load classes and resources from a search path of URLs
        URLClassLoader sysloader = (URLClassLoader) ClassLoader.getSystemClassLoader();
        Class<URLClassLoader> sysclass = URLClassLoader.class;

        try {
            Method method = sysclass.getDeclaredMethod("addURL", new Class[]{URL.class});
            method.setAccessible(true);
            method.invoke(sysloader, new Object[]{jarFile.toURI().toURL()});
        } catch (Throwable throwable) {
            throw new Exception("Could not add arcobjects.jar to system classloader", throwable);
        }               
    }    
}
