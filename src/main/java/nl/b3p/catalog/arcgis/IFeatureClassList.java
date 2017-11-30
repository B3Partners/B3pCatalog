/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package nl.b3p.catalog.arcgis;

import com.esri.arcgis.geodatabase.IDataset;
import com.esri.arcgis.geodatabase.IEnumFeatureClass;
import com.esri.arcgis.geodatabase.IFeatureClass;
import com.esri.arcgis.geodatabase.IFeatureClassContainer;
import java.io.IOException;
import java.util.Iterator;

/**
 *
 * @author Erik van de Pol
 */
public class IFeatureClassList implements Iterable<IFeatureClass> {
    private final IDataset dataset;

    public IFeatureClassList(IDataset dataset) {
        this.dataset = dataset;
    }

    @Override
    public Iterator<IFeatureClass> iterator() {
        try {
            if (dataset instanceof IFeatureClassContainer) {
                return new IFeatureClassContainerIterator((IFeatureClassContainer)dataset);
            } else if (dataset instanceof IFeatureClass) {
                return new IFeatureClassIterator((IFeatureClass)dataset);
            } else {
                throw new IOException("Unrecognized dataset type. Does it contain FeatureClasses?");
            }
        } catch (IOException ex) {
            throw new RuntimeException(ex);
        }
    }

    private class IFeatureClassIterator implements Iterator<IFeatureClass> {
        private IFeatureClass featureClass;

        public IFeatureClassIterator(IFeatureClass featureClass) throws IOException {
            this.featureClass = featureClass;
        }

        @Override
        public boolean hasNext() {
            return featureClass != null;
        }

        @Override
        public IFeatureClass next() {
            IFeatureClass tempFeatureClass = featureClass;
            featureClass = null;
            return tempFeatureClass;
        }

        @Override
        public void remove() {
            throw new UnsupportedOperationException("Not supported.");
        }
    }


    private class IFeatureClassContainerIterator implements Iterator<IFeatureClass> {
        private final IEnumFeatureClass enumFeatureClass;
        private IFeatureClass nextFeatureClass;

        public IFeatureClassContainerIterator(IFeatureClassContainer featureClassContainer) throws IOException {
            enumFeatureClass = featureClassContainer.getClasses();
        }

        @Override
        public boolean hasNext() {
            try {
                nextFeatureClass = enumFeatureClass.next();
                return nextFeatureClass != null;
            } catch (IOException ex) {
                throw new RuntimeException(ex);
            }
        }

        @Override
        public IFeatureClass next() {
            try {
                if (nextFeatureClass != null) {
                    IFeatureClass tempFeatureClass = nextFeatureClass;
                    nextFeatureClass = null;
                    return tempFeatureClass;
                } else {
                    return enumFeatureClass.next(); // is null if not has next.
                }
            } catch (IOException ex) {
                throw new RuntimeException(ex);
            }
        }

        @Override
        public void remove() {
            throw new UnsupportedOperationException("Not supported.");
        }
    }
}
