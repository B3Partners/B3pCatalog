package nl.b3p.catalog.filetree;

import com.esri.arcgis.geodatabase.IDataset;
import com.esri.arcgis.geodatabase.IEnumDataset;
import com.esri.arcgis.geodatabase.Workspace;
import com.esri.arcgis.geodatabase.esriDatasetType;
import java.io.IOException;
import net.sourceforge.stripes.action.ActionBeanContext;
import nl.b3p.catalog.arcgis.ArcSDEHelperProxy;

public class ArcSDEPath {

    private ArcSDERoot root = null;
    private String containingFeatureDatasetName;
    private String datasetName;

    public ArcSDEPath(String path, ActionBeanContext context) {
        String r = path.substring(0, path.indexOf("/")+1);
        path = path.substring(path.indexOf("/")+1);

        if(path.contains("/")) {
            containingFeatureDatasetName = path.substring(0,path.indexOf("/"));
            datasetName = path.substring(path.indexOf("/")+1);
        } else {
            datasetName = path.length() == 0 ? null : path;
        }
        root = ArcSDEHelperProxy.getRootsMap(context).get(r);

        if(root == null) {
            throw new IllegalArgumentException("Invalid SDE root specified: " + r);
        }
    }

    public IDataset getDataset() throws IOException {
        if(datasetName == null) {
            throw new IllegalArgumentException("Invalid dataset specified");
        }
        Workspace ws = root.getWorkspace();
        IEnumDataset enumDataset = ws.getSubsets();
        if(containingFeatureDatasetName != null) {
            IDataset ds;
            while ((ds = enumDataset.next()) != null) {
                if (ds.getType() == esriDatasetType.esriDTFeatureDataset && ds.getName().equals(containingFeatureDatasetName)) {
                    enumDataset = ds.getSubsets();
                    break;
                }
            }
            if(ds == null) {
                throw new IllegalArgumentException("Feature dataset \"" + containingFeatureDatasetName + "\" not found");
            }
        }
        IDataset ds;
        while ((ds = enumDataset.next()) != null) {
            if (ds.getType() != esriDatasetType.esriDTFeatureDataset && ds.getName().equals(datasetName)) {
                return ds;
            }
        }
        throw new IllegalArgumentException("Feature class \"" + datasetName + "\" not found");
    }

    // <editor-fold defaultstate="collapsed" desc="getters en setters">
    public String getContainingFeatureDatasetName() {
        return containingFeatureDatasetName;
    }

    public void setContainingFeatureDatasetName(String containingFeatureDatasetName) {
        this.containingFeatureDatasetName = containingFeatureDatasetName;
    }

    public String getDatasetName() {
        return datasetName;
    }

    public void setDatasetName(String datasetName) {
        this.datasetName = datasetName;
    }

    public ArcSDERoot getRoot() {
        return root;
    }

    public void setRoot(ArcSDERoot root) {
        this.root = root;
    }
    // </editor-fold>
}
