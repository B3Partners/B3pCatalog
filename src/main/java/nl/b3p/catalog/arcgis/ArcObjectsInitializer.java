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

import com.esri.arcgis.system.AoInitialize;
import com.esri.arcgis.system.EngineInitializer;
import com.esri.arcgis.system.esriLicenseProductCode;
import com.esri.arcgis.system.esriLicenseStatus;
import java.lang.reflect.Field;
import java.util.ArrayList;
import java.util.List;
import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;

/**
 *
 * @author Matthijs Laan
 */
public class ArcObjectsInitializer {
    private final static Log log = LogFactory.getLog(ArcObjectsInitializer.class);    
    
    private static AoInitialize aoInit = null;
        
    private static int[] getProductCodeIntegers(String[] productCodes) {
        Class clazz = esriLicenseProductCode.class;
        
        List<Integer> codes = new ArrayList<Integer>();
        for(String c: productCodes) {
            try {
                Field f = clazz.getDeclaredField("esriLicenseProductCode" + c);
                codes.add(f.getInt(null));
            } catch(Exception e) {
                log.warn("Invalid product code: " + c);
            }
        }
        int[] c = new int[codes.size()];
        for(int i = 0; i < c.length; i++) {
            c[i] = codes.get(i);
        }
        return c;
    }
   
    public static void initializeLicenseWithStringCodes(String[] productCodes) throws Exception {
        int[] codes = getProductCodeIntegers(productCodes);
        initializeLicense(codes);        
    }
    
    /** 
     * Will try to initialize, in order: ArcInfo, ArcEditor, ArcServer, ArcView, 
     * EngineGeoDB, Engine
     */
    public static void initializeEditOrViewLicense() throws Exception {
        initializeLicense(new int[] {
//            esriLicenseProductCode.esriLicenseProductCodeArcInfo,
//            esriLicenseProductCode.esriLicenseProductCodeArcEditor,
            esriLicenseProductCode.esriLicenseProductCodeArcServer,
//            esriLicenseProductCode.esriLicenseProductCodeArcView,
            esriLicenseProductCode.esriLicenseProductCodeEngineGeoDB,
            esriLicenseProductCode.esriLicenseProductCodeEngine
        });                
    }

    /**
     * Will try to initialize, in order: ArcInfo, ArcEditor, ArcServer(?)
     */
    public static void initializeEditLicense() throws Exception {
        initializeLicense(new int[] {
//            esriLicenseProductCode.esriLicenseProductCodeArcInfo,
//            esriLicenseProductCode.esriLicenseProductCodeArcEditor,
            esriLicenseProductCode.esriLicenseProductCodeArcServer
        });                
    }

    /**
     * Will try to initialize, in order: ArcView, EngineGeoDB, Engine
     */
    public static void initializeViewLicense() throws Exception {
        initializeLicense(new int[] {
//            esriLicenseProductCode.esriLicenseProductCodeArcView,
            esriLicenseProductCode.esriLicenseProductCodeEngineGeoDB,
            esriLicenseProductCode.esriLicenseProductCodeEngine
        });                
    }
    
    /**
     * Initialiseer licentie. De productCodes parameter is een lijst van te 
     * proberen product codes (indien een product code niet beschikbaar is wordt 
     * de volgende geprobeerd).
     * 
     * <b>WAARSCHUWING:</b> importeer geen com.esri packages in classes die 
     * worden geladen voordat ArcObjectsLinker.link() succesvol is aangeroepen!
     * 
     * @param productCodes lijst van com.esri.arcgis.system.esriLicenseProductCode fields 
     * @throws Exception indien licentie niet kon worden geinitialiseerd
     */
    public static void initializeLicense(int[] productCodes) throws Exception {
        //Initialize engine console application
        EngineInitializer.initializeEngine();

        //Initialize ArcGIS license
        aoInit = new AoInitialize();
        
        for(int code: productCodes) {
            String codeString = findStaticFieldByValue(esriLicenseProductCode.class, code);
            log.info("Checking for product code availability for " + codeString);
            int status = aoInit.isProductCodeAvailable(code);
            log.info("Status: " + findStaticFieldByValue(esriLicenseStatus.class, status));
            
            if(status == esriLicenseStatus.esriLicenseAvailable) {
                status = aoInit.initialize(code);
                log.info("Initialize result: " + findStaticFieldByValue(esriLicenseStatus.class, status));
                return;
            }
        }
        throw new Exception("No suitable ArcObjects license found");
    }

    public static void shutdown() throws Exception {
        //Ensure any ESRI libraries are unloaded in the correct order
        if (aoInit != null) {
            aoInit.shutdown();
        }
    }    
    
    private static String findStaticFieldByValue(Class clazz, Object value) {
        try {
            Field[] fields = clazz.getDeclaredFields();
            for(int i = 0; i < fields.length; i++) {
                if(fields[i].get(null).equals(value)) {
                    return fields[i].getName();
                }
            }
        } catch(Exception e) {
        }
        return value.toString();
    }
}
