package nl.b3p.catalog.filetree;

import com.esri.arcgis.datasourcesGDB.SdeWorkspaceFactory;
import com.esri.arcgis.geodatabase.Workspace;
import java.io.IOException;

public class ArcSDERoot extends Root {
    protected int index;
    protected String connectionString;
    protected String ppString;
    
    public ArcSDERoot(int index, String connectionString, String prettyName) {
        super(null, prettyName);
        setPath("sde" + index + "/");
        this.connectionString = connectionString;
        this.index = index;
    }
    
    public String getConnectionString() {
        return connectionString;
    }

    public Workspace getWorkspace() throws IOException {
        SdeWorkspaceFactory factory = new SdeWorkspaceFactory();
        return new Workspace(factory.openFromString(connectionString, 0));
    }
}
