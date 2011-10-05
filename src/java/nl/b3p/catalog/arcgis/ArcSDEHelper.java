package nl.b3p.catalog.arcgis;

import com.esri.arcgis.geodatabase.IDataset;
import com.esri.arcgis.geodatabase.IEnumDataset;
import com.esri.arcgis.geodatabase.IMetadata;
import com.esri.arcgis.geodatabase.Workspace;
import com.esri.arcgis.geodatabase.XmlPropertySet;
import com.esri.arcgis.geodatabase.esriDatasetType;
import java.io.IOException;
import java.util.ArrayList;
import java.util.List;
import nl.b3p.catalog.filetree.ArcSDEPath;
import nl.b3p.catalog.filetree.ArcSDERoot;
import nl.b3p.catalog.filetree.Dir;

public class ArcSDEHelper {

    public static List<Dir> getFeatureDatasets(ArcSDERoot sdeRoot, String path) throws IOException {
        Workspace ws = sdeRoot.getWorkspace();

        try {
            List<Dir> dirs = new ArrayList<Dir>();

            IEnumDataset enumDataset = ws.getSubsets();
            IDataset ds;
            while ((ds = enumDataset.next()) != null) {
                if (ds.getType() == esriDatasetType.esriDTFeatureDataset) {
                    Dir d = new Dir(ds.getName(),path+ds.getName()+"/");
                    dirs.add(d);
                }
            }
            return dirs;
        } finally {
            ws.release();
        }
    }

    public static List<nl.b3p.catalog.filetree.File> getFeatureClasses(ArcSDERoot sdeRoot, String path) throws IOException {
        Workspace ws = sdeRoot.getWorkspace();

        try {
            return getDatasetEnumFeatureClassFiles(ws.getSubsets(), path);
        } finally {
            ws.release();
        }
    }

    public static List<nl.b3p.catalog.filetree.File> getFeatureClassesInDataset(ArcSDERoot sdeRoot, String path, String dataset) throws Exception {
        if(dataset == null) {
            throw new IllegalArgumentException("Invalid feature dataset specified");
        }

        Workspace ws = sdeRoot.getWorkspace();

        try {
            IEnumDataset enumDataset = ws.getSubsets();

            IDataset ds;
            while ((ds = enumDataset.next()) != null) {
                if (ds.getType() == esriDatasetType.esriDTFeatureDataset && ds.getName().equals(dataset)) {
                    break;
                }
            }
            if(ds == null) {
                throw new IllegalArgumentException("Dataset \"" + dataset + "\" not found");
            }

            return getDatasetEnumFeatureClassFiles(ds.getSubsets(), path);
        } finally {
            ws.release();
        }
    }

    private static List<nl.b3p.catalog.filetree.File> getDatasetEnumFeatureClassFiles(IEnumDataset enumDataset, String path) throws IOException {
        List<nl.b3p.catalog.filetree.File> files = new ArrayList<nl.b3p.catalog.filetree.File>();
        IDataset ds;
        while ((ds = enumDataset.next()) != null) {
            if(ds.getType() !=  esriDatasetType.esriDTFeatureDataset) {
                nl.b3p.catalog.filetree.File f = new nl.b3p.catalog.filetree.File(ds.getName(),path+ds.getName());
                f.setEsriType(ds.getType());
                f.setIsGeo(true);
                files.add(f);
            }
        }

        return files;
    }

    public static String getMetadata(IDataset dataset) throws IOException {
        IMetadata imd = (IMetadata)dataset.getFullName();
        return ((XmlPropertySet)imd.getMetadata()).getXml("/");
    }

    public static void saveMetadata(IDataset dataset, String metadata) throws IOException {
        IMetadata imd = (IMetadata)dataset.getFullName();
        XmlPropertySet mdPS = (XmlPropertySet)imd.getMetadata();
        mdPS.setXml(metadata);
        imd.setMetadata(mdPS);
    }
}
