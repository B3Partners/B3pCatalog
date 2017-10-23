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

import java.io.BufferedReader;
import java.io.File;
import java.io.FilenameFilter;
import java.io.InputStreamReader;
import java.io.StringWriter;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;
import javax.servlet.ServletContext;
import nl.b3p.catalog.xml.DocumentHelper;
import org.apache.commons.lang.StringUtils;
import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.jdom2.Document;

/**
 *
 * @author Matthijs Laan
 */
public class ArcObjectsSynchronizerForker {
    private static final Log log = LogFactory.getLog(ArcObjectsSynchronizerForker.class);
    
    public static Document synchronize(ServletContext context,/* HttpServletResponse response,*/ String dataset, String type, String sdeConnectionString, String metadata) throws Exception {
    
        String workingDir = context.getRealPath("/WEB-INF");

        String cp = buildClasspath(context);
        String mainClass = ArcObjectsSynchronizerMain.class.getName();
        
        List<String> args = new ArrayList<String>();
        
        args.addAll(Arrays.asList(
            "java",
            "-classpath",
            cp,
            mainClass,
            "-type",
            type,
            "-dataset",
            dataset
        ));
        if(metadata != null && !"".equals(metadata)) {
            args.add("-stdin");
        }
        
        if("sde".equals(type)) {
            if(sdeConnectionString == null) {
                throw new IllegalArgumentException("SDE connection string is required");
            }
            args.add("-sde");
            args.add(sdeConnectionString);
        }
        
        final StringWriter output = new StringWriter();
        final StringWriter errors = new StringWriter(); // response.getWriter();
        errors.write(String.format("Werkdirectory: %s\nUitvoeren synchronizer proces: %s\n\n", workingDir, StringUtils.join(args,' ')));
        //errors.flush();
        int result;
        
        try {
            Process p = Runtime.getRuntime().exec(args.toArray(new String[] {}), null, new File(workingDir));

            final BufferedReader stderr = new BufferedReader(new InputStreamReader(p.getErrorStream()));
            final BufferedReader stdout = new BufferedReader(new InputStreamReader(p.getInputStream()));

            if(metadata != null && !"".equals(metadata)) {
                try {
                    p.getOutputStream().write(metadata.getBytes("UTF-8"));
                    p.getOutputStream().flush();
                    p.getOutputStream().close();
                } catch(Exception e) {
                    errors.write("Fout tijdens schrijven metadata XML met alle elementen naar stdin: " + e.getClass() + ": " + e.getMessage() + "\n");
                }
            }
            
            // Threads vereist omdat streams blocken en pas verder gaan nadat je uit
            // de andere stream hebt gelezen

            Thread stderrReader = new Thread() {
                @Override public void run() {
                    String line;
                    try {
                        while ((line = stderr.readLine()) != null) {
                           errors.write(line + "\r\n");
                           //errors.flush();
                        }
                        stderr.close();
                    } catch (Exception e) {throw new Error(e);}
                }
            };

            Thread stdoutReader = new Thread() {
                @Override public void run() {
                    String line;
                    try {
                        while ((line = stdout.readLine()) != null) {
                            output.write(line + "\r\n");
                        }
                        stdout.close();
                    } catch (Exception e) {throw new Error(e);}
                }
            };

            stderrReader.start();
            stdoutReader.start();

            result = p.waitFor();

            stderrReader.join();
            stdoutReader.join();

            errors.write("Resultaat: " + (result == 0 ? "succesvol gesynchroniseerd" : "fout opgetreden") + "\n\n");
        } catch(Exception e) {
            throw new Exception("Fout tijdens aanroepen extern proces voor synchroniseren, output: \n" + errors.toString(), e);
        }
        
        if(log.isDebugEnabled()) {
            log.debug("Synchroniseren via apart proces succesvol; output: " + errors.toString());
        }
        if(result == 0) {
            return DocumentHelper.getMetadataDocument(output.toString());
        } else {
            throw new Exception("Synchroniseren via apart process geeft error code " + result + "; output: \n" + errors.toString());
        }
    }
    
    private static String buildClasspath(ServletContext context) {
        StringBuilder cp = new StringBuilder();
        cp.append("classes");
        
        File lib = new File(context.getRealPath("/WEB-INF/lib"));
        File[] jarFiles = lib.listFiles(new FilenameFilter() {
            public boolean accept(File dir, String name) {
                return name.endsWith(".jar");
            }
        });

        for(File f: jarFiles) {
            cp.append(File.pathSeparator);
            cp.append("lib");
            cp.append(File.separatorChar);
            cp.append(f.getName());
        }
        return cp.toString();
    }
}
