/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

package nl.b3p.catalog.arcgis;

import com.esri.arcgis.system.AoInitialize;
import com.esri.arcgis.system.EngineInitializer;
import com.esri.arcgis.system.esriLicenseProductCode;
import com.esri.arcgis.system.esriLicenseStatus;
import java.io.File;
import java.lang.reflect.Method;
import java.net.URL;
import java.net.URLClassLoader;
import javax.servlet.ServletContextEvent;
import javax.servlet.ServletContextListener;
import org.apache.catalina.loader.WebappClassLoader;
import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;

/**
 *
 * @author Erik
 */
public class ArcGISConnector implements ServletContextListener {
    private final static Log log = LogFactory.getLog(ArcGISConnector.class);

    // Store as Object because we don't know this Class until bootstrapping
    private Object aoInit = null;

    public void contextInitialized(ServletContextEvent sce) {
        try {
            log.info("ArcObjects bootstrap started.");
            bootstrapArcobjectsJar();
            log.info("ArcObjects bootstrap successful.");

            //Initialize engine console application
            EngineInitializer.initializeEngine();

            //Initialize ArcGIS license
            AoInitialize aoInitTemp = new AoInitialize();
            aoInit = aoInitTemp;
            initializeArcGISLicenses(aoInitTemp);

            //Get DEVKITHOME Home
            /*String devKitHome = System.getenv("AGSDEVKITJAVA");

            //Data access setup
            String inFGDB = devKitHome + "java" + File.separator + "samples" + File.separator
                    + "data" + File.separator + "usa" + File.separator
                    + "usa.gdb";
            System.out.println("Input is " + inFGDB);*/

        } catch (Exception e) {
            log.error("Error connecting to ArcGIS.", e);
        }
    }

    private void bootstrapArcobjectsJar() throws Exception {
        //Get the ArcGIS Engine runtime, if it is available
        String arcObjectsHome = System.getenv("AGSENGINEJAVA");

        //If the ArcGIS Engine runtime is not available, then we can try ArcGIS Desktop runtime
        if (arcObjectsHome == null) {
            arcObjectsHome = System.getenv("AGSDESKTOPJAVA");
        }

        //If no runtime is available, exit application gracefully
        if (arcObjectsHome == null) {
            if (System.getProperty("os.name").toLowerCase().indexOf("win") > -1) {
                throw new Exception("You must have ArcGIS Engine Runtime or ArcGIS Desktop " +
                        "installed in order to execute this sample.\n" +
                        "Install one of the products above, then re-run this sample.");
            } else {
                throw new Exception("You must have ArcGIS Engine Runtime " +
                        "installed in order to execute this sample.\n" +
                        "Install one of the products above, then re-run this sample.");
            }
        }

        //Obtain the relative path to the arcobjects.jar file
        String jarPath = arcObjectsHome + "java" + File.separator + "lib"
                + File.separator + "arcobjects.jar";

        //Create a new file
        File jarFile = new File(jarPath);

        //Test for file existence
        if (!jarFile.exists()) {
            throw new Exception("The arcobjects.jar was not found in the following location: " + jarFile.getParent() + "\n" +
                    "Verify that arcobjects.jar can be located in the specified folder." +
                    "If not present, try uninstalling your ArcGIS software and reinstalling it.");
        }

        //Helps load classes and resources from a search path of URLs
        URLClassLoader sysloader = (URLClassLoader) ClassLoader.getSystemClassLoader();
        log.debug(sysloader);
        /*URLClassLoader*/ sysloader = (URLClassLoader) Thread.currentThread().getContextClassLoader();
        log.debug(sysloader);
        Class<URLClassLoader> sysclass = URLClassLoader.class;

        try {
            Method method = sysclass.getDeclaredMethod("addURL", new Class[]{URL.class});
            method.setAccessible(true);
            method.invoke(sysloader, new Object[]{jarFile.toURI().toURL()});
        } catch (Throwable throwable) {
            throw new Exception("Could not add arcobjects.jar to system classloader", throwable);
        }
    }


    private void initializeArcGISLicenses(AoInitialize aoInit) throws Exception {
        if (aoInit.isProductCodeAvailable(esriLicenseProductCode.esriLicenseProductCodeArcEditor)
                == esriLicenseStatus.esriLicenseAvailable) {
            log.info("ArcGIS License used: ArcEditor");
            aoInit.initialize(esriLicenseProductCode.esriLicenseProductCodeArcEditor);
        } else if (aoInit.isProductCodeAvailable(esriLicenseProductCode.esriLicenseProductCodeEngine)
                == esriLicenseStatus.esriLicenseAvailable) {
            log.info("ArcGIS License used: Engine");
            aoInit.initialize(esriLicenseProductCode.esriLicenseProductCodeEngine);
        } else if (aoInit.isProductCodeAvailable(esriLicenseProductCode.esriLicenseProductCodeArcView)
                == esriLicenseStatus.esriLicenseAvailable) {
            log.info("ArcGIS License used: ArcView");
            aoInit.initialize(esriLicenseProductCode.esriLicenseProductCodeArcView);
        } else if (aoInit.isProductCodeAvailable(esriLicenseProductCode.esriLicenseProductCodeEngineGeoDB)
                == esriLicenseStatus.esriLicenseAvailable) {
            log.info("ArcGIS License used: EngineGeoDB");
            aoInit.initialize(esriLicenseProductCode.esriLicenseProductCodeEngineGeoDB);
        } else if (aoInit.isProductCodeAvailable(esriLicenseProductCode.esriLicenseProductCodeArcInfo)
                == esriLicenseStatus.esriLicenseAvailable) {
            log.info("ArcGIS License used: ArcInfo");
            aoInit.initialize(esriLicenseProductCode.esriLicenseProductCodeArcInfo);
        } else if (aoInit.isProductCodeAvailable(esriLicenseProductCode.esriLicenseProductCodeArcServer)
                == esriLicenseStatus.esriLicenseAvailable) {
            log.info("ArcGIS License used: ArcServer");
            aoInit.initialize(esriLicenseProductCode.esriLicenseProductCodeArcServer);
        } else {
            throw new Exception("Could not initialize any ESRI license.");
        }
    }


    public void contextDestroyed(ServletContextEvent sce) {
        try {
            //Ensure any ESRI libraries are unloaded in the correct order
            if (aoInit != null && aoInit instanceof AoInitialize)
                ((AoInitialize)aoInit).shutdown();
        } catch (Exception e) {
            log.error("Error shutting down ArcGIS connection", e);
        }
    }

}
