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
import java.io.IOException;
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

    private static List<Integer> getProductCodeIntegers(List<String> productCodes) {
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
        return codes;
    }
   
    public static void initializeLicenseWithStringCodes(List<String> productCodes) throws Exception {
        List<Integer> codes = getProductCodeIntegers(productCodes);
        initializeLicense(codes);        
    }
    
    /**
     * Initialiseer licentie. De productCodes parameter is een lijst van te 
     * proberen product codes (indien een product code niet beschikbaar is wordt 
     * de volgende geprobeerd).
     * 
     * @param productCodes lijst van com.esri.arcgis.system.esriLicenseProductCode fields 
     * @throws Exception indien licentie niet kon worden geinitialiseerd
     */
    public static void initializeLicense(List<Integer> productCodes) throws Exception {
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
