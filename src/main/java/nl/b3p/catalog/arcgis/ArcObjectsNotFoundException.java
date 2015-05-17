/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

package nl.b3p.catalog.arcgis;

import nl.b3p.catalog.B3PCatalogException;

/**
 *
 * @author Erik van de Pol
 */
public class ArcObjectsNotFoundException extends B3PCatalogException {

    public ArcObjectsNotFoundException(Throwable cause) {
        super(cause);
    }

    public ArcObjectsNotFoundException(String message, Throwable cause) {
        super(message, cause);
    }

    public ArcObjectsNotFoundException(String message) {
        super(message);
    }

    public ArcObjectsNotFoundException() {
    }

}
