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
import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;

/**
 * Deze class voegt arcobjects.jar toe aan de system classloader. Belangrijk is
 * dat de methode linkArcObjects() succesvol moet zijn aangeroepen voordat ook
 * maar een enkele class met een "import com.esri" statement wordt geladen.
 * 
 * arcobjects.ar kan namelijk niet meegeleverd worden met een applicatie. Als
 * in een applicatie ArcObjects optioneel is is het mogelijk om het laden van 
 * classes die ESRI packages importeren te vermijden.
 * 
 * Ook indien ArcObjects wel vereist is is het op deze manier linken van 
 * ArcObjects mogelijk op basis van environment variabelen van de ESRI 
 * installatie en is het mogelijk om foutmeldingen te geven. Het is ook simpeler
 * dan de -classpath parameter van de JVM of een Tomcat classloader in te stellen.
 * 
 * @author Matthijs Laan
 */
public class ArcObjectsLinker {
    private static final Log log = LogFactory.getLog(ArcObjectsLinker.class);
    
    private static List<String> homeEnvVars = Arrays.asList(new String[] {
        "AGSSERVERJAVA", "AGSENGINEJAVA", "AGSDESKTOPJAVA", "ARCGISHOME"});    
    
    public static void link() throws Exception {
        link(null);
    }
    
    public static void link(String arcObjectsHome) throws Exception {
        
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

        // Deze hack is afkomstig van ESRI voorbeelden...
        
        // Helps load classes and resources from a search path of URLs
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
