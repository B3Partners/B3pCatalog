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

import org.jdom2.input.SAXBuilder;
import nl.b3p.catalog.config.Root;
import com.esri.arcgis.datasourcesGDB.SdeWorkspaceFactory;
import com.esri.arcgis.geodatabase.IDataset;
import com.esri.arcgis.geodatabase.IEnumDataset;
import com.esri.arcgis.geodatabase.IWorkspaceFactory;
import com.esri.arcgis.geodatabase.Workspace;
import com.esri.arcgis.geodatabase.esriDatasetType;
import java.io.File;
import java.util.regex.Pattern;
import org.apache.commons.cli.CommandLine;
import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.jdom2.Document;
import org.jdom2.output.Format;
import org.jdom2.output.XMLOutputter;

import static nl.b3p.catalog.arcgis.ArcObjectsSynchronizerMain.*;

/**
 *
 * @author Matthijs Laan
 */
public class ArcObjectsSynchronizerWorker {
    private static final Log log = LogFactory.getLog(ArcObjectsSynchronizerWorker.class);

    public static void synchronize(CommandLine cl) throws Exception {

        String type = cl.getOptionValue("type");
        String dataset = cl.getOptionValue("dataset");

        IDataset ds = null;
        String formatName = null;

        Document metadataAllElements = null;
        if(cl.hasOption("stdin")) {
            System.err.println("Reading XML document from stdin");
            metadataAllElements = new SAXBuilder().build(System.in);
        }

        if(TYPE_SDE.equals(type) || TYPE_SDEFILE.equals(type)) {
            formatName = ArcGISSynchronizer.FORMAT_NAME_SDE;
            Workspace ws;
            if(TYPE_SDE.equals(type)) {
                String connectionString = cl.getOptionValue(TYPE_SDE);
                if(connectionString == null) {
                    throw new IllegalArgumentException(TYPE_SDE + " option is required");
                }

                // XXX wachtwoord mogelijk zichtbaar in output
                log.info("Opening SDE workspace using connection string " + connectionString);
                SdeWorkspaceFactory factory = new SdeWorkspaceFactory();
                ws = new Workspace(factory.openFromString(connectionString, 0));
            } else {
                String file = cl.getOptionValue(TYPE_SDEFILE);
                if(file == null) {
                    throw new IllegalArgumentException(TYPE_SDEFILE + " option is required");
                }
                log.info("Opening SDE workspace from connection file " + file);
                IWorkspaceFactory factory = new SdeWorkspaceFactory();
                ws = new Workspace(factory.openFromFile(file, 0));
            }
            log.info("SDE workspace open, looking for dataset " + dataset);
            ds = findSDEDataset(ws, dataset);

        } else if(TYPE_FGDB.equals(type)) {
            formatName = ArcGISSynchronizer.FORMAT_NAME_FGDB;
            ds = FGDBHelper.getTargetDataset(new File(dataset), esriDatasetType.esriDTFeatureClass);
        } else {
            throw new IllegalArgumentException("Invalid type: " + type);
        }

        log.info("Dataset found, synchronizing");
        Document doc;
        if(metadataAllElements == null) {
            doc = ArcGISSynchronizer.synchronize(ds, formatName);
        } else {
            System.err.println("Synchronizing using stdin document");
            ArcGISSynchronizer.synchronize(metadataAllElements, ds, formatName);
            doc = metadataAllElements;
        }
        new XMLOutputter(Format.getPrettyFormat()).output(doc, System.out);
    }

    private static IDataset findSDEDataset(Workspace ws, String datasetName) throws Exception {
        IEnumDataset eds = ws.getSubsets();

        String[] parts = datasetName.split(Pattern.quote(Root.SEPARATOR));
        if(parts.length > 2) {
            throw new IllegalArgumentException("Invalid dataset: " + datasetName);
        }
        String featureDataset = null;
        String dataset = parts[0];

        if(parts.length == 2) {
            featureDataset = parts[0];
            dataset = parts[1];
            log.info("Looking for feature dataset \"" + featureDataset + "\"");
            eds = findFeatureDataset(eds, featureDataset);
            if(eds == null) {
                throw new IllegalArgumentException("Feature dataset \"" + featureDataset + "\" not found");
            }
        }

        log.info("Looking for dataset \"" + dataset + "\"");
        IDataset ds = findFeatureClass(eds, dataset);
        if(ds == null) {
            throw new IllegalArgumentException("Dataset \"" + dataset + "\" not found");
        }
        return ds;
    }

    private static IDataset findFeatureClass(IEnumDataset eds, String name) throws Exception {
        IDataset ds;
        while((ds = eds.next()) != null) {
            if(ds.getType() != esriDatasetType.esriDTFeatureDataset && ds.getName().equals(name)) {
                return ds;
            }
        }
        return null;
    }

    private static IEnumDataset findFeatureDataset(IEnumDataset eds, String name) throws Exception {
        IDataset ds;
        while((ds = eds.next()) != null) {
            if(ds.getType() == esriDatasetType.esriDTFeatureDataset && ds.getName().equals(name)) {
                return ds.getSubsets();
            }
        }
        return null;
    }
}
