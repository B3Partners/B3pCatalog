/*
 * Copyright (C) 2012 B3Partners B.V.
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
import java.io.FileInputStream;
import java.io.IOException;
import java.nio.ByteBuffer;
import java.nio.channels.FileChannel;
import java.util.Scanner;
import org.geotools.data.shapefile.dbf.DbaseFileHeader;
import org.geotools.data.shapefile.shp.ShapefileHeader;
import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

/**
 * @author Matthijs Laan
 */
public class Shapefiles {
    /** Returns a JSON object with shapefile and DBF metadata.
     * 
     * @param file the shapefile to read
     * @return a JSON object, read the code to find out which properties
     */
    public static String getMetadata(String file) throws IOException, JSONException {

        if(!file.toLowerCase().endsWith(".shp")) {
            throw new IllegalArgumentException("File does not end with .shp: " + file);
        }

        FileChannel channel = new FileInputStream(file).getChannel();
        ShapefileHeader header = new ShapefileHeader();
        ByteBuffer bb = channel.map(FileChannel.MapMode.READ_ONLY, 0, channel.size());
        header.read(bb, true);
        channel.close();
        channel = null;
        file = file.substring(0, file.length()-4) + ".dbf";

        JSONObject j = new JSONObject();
        j.put("type", header.getShapeType().name);
        j.put("version", header.getVersion());
        j.put("minX", header.minX());
        j.put("minY", header.minY());
        j.put("maxX", header.maxX());
        j.put("maxY", header.maxY());

        JSONObject dbf = new JSONObject();
        j.put("dbf", dbf);
        try {
            channel = new FileInputStream(file).getChannel();
            DbaseFileHeader dheader = new DbaseFileHeader();
            bb = channel.map(FileChannel.MapMode.READ_ONLY, 0, channel.size());
            dheader.readHeader(bb);
            dbf.put("numRecords", dheader.getNumRecords());
            JSONArray fields = new JSONArray();
            dbf.put("fields", fields);
            for(int i = 0; i < dheader.getNumFields(); i++) {
                JSONObject field = new JSONObject();
                fields.put(field);
                field.put("name", dheader.getFieldName(i));
                field.put("length", dheader.getFieldLength(i));
                field.put("decimalCount", dheader.getFieldDecimalCount(i));
                field.put("class", dheader.getFieldClass(i).getName().toString());
                field.put("type", dheader.getFieldType(i) + "");
            }
        } catch(Exception e) {
            dbf.put("error", e.toString());
        } finally {
            if(channel != null) {
                channel.close();
            }
        }

        file = file.substring(0, file.length()-4) + ".prj";
        File f = new File(file);
        String prj = null;
        if(f.exists()) {
            Scanner s = new Scanner(f);
            prj = "";
            try {
                while(s.hasNextLine()) {
                    if(prj.length() > 0) {
                        prj += "\n";
                    }
                    prj += s.nextLine();
                }
            } finally {
                s.close();
            }
        }
        j.put("prj", prj);

        return j.toString();
    }
}
