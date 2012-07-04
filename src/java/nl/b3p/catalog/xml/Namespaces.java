/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package nl.b3p.catalog.xml;

import java.util.Arrays;
import java.util.Collections;
import java.util.HashSet;
import java.util.Set;
import org.jdom.Namespace;

/**
 *
 * @author Erik van de Pol
 */
public class Namespaces {
    public final static Namespace GMD = Namespace.getNamespace("gmd", "http://www.isotc211.org/2005/gmd");
    public final static Namespace GCO = Namespace.getNamespace("gco", "http://www.isotc211.org/2005/gco");
    public final static Namespace GFC = Namespace.getNamespace("gfc", "http://www.isotc211.org/2005/gfc");
    public final static Namespace GMX = Namespace.getNamespace("gmx", "http://www.isotc211.org/2005/gmx");
    public final static Namespace B3P = Namespace.getNamespace("b3p", "http://www.b3partners.nl/xsd/metadata");
    public final static Namespace PBL = Namespace.getNamespace("pbl", "http://www.pbl.nl/xsd/metadata");
    public final static Namespace NC =  Namespace.getNamespace("nc", "http://www.unidata.ucar.edu/namespaces/netcdf/ncml-2.2");
   
    public static final Set<Namespace> allNamespaces = Collections.unmodifiableSet(new HashSet(Arrays.asList(new Namespace[] {
        GMD,
        GCO,
        GFC,
        GMX,
        B3P,
        PBL,
        NC
    })));
}

