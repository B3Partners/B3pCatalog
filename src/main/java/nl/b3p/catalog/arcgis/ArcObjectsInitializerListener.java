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

    private boolean initialized;

    public void contextInitialized(ServletContextEvent sce) {
        
        CatalogAppConfig cfg = CatalogAppConfig.getConfig();
        
        if(cfg != null && !cfg.getArcObjectsConfig().isEnabled()) {
            log.info("ArcObjects is not enabled by config");
            return;
        }
        ArcObjectsConfig aoCfg = cfg.getArcObjectsConfig();
        try {
            log.info("Attempting to add ArcObjects jar to classpath...");
            ArcObjectsLinker.link(aoCfg.getArcEngineHome());
            log.info("OK, initializing license");

            ArcObjectsInitializer.initializeLicenseWithStringCodes(aoCfg.getProductCodes().toArray(new String[]{}));
            initialized = true;
        } catch (Exception e) {
            log.error("Error initializing ArcObjects", e);
        }        
    }
    
    public void contextDestroyed(ServletContextEvent sce) {
        try {
            if(initialized) {
                ArcObjectsInitializer.shutdown();
            }
        } catch(Exception e) {
            log.error("Error shutting down ArcObjects", e);
        }
    }  
}
