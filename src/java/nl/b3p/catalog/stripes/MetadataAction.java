/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

package nl.b3p.catalog.stripes;

import net.sourceforge.stripes.action.Resolution;

/**
 *
 * @author Erik van de Pol
 */
public class MetadataAction extends DefaultAction {
    private String filename;

    // TODO: check permissie om file te loaden!!
    public Resolution load() {
        throw new UnsupportedOperationException();
    }

    // TODO: check permissie om file te saven!!
    public Resolution save() {
        throw new UnsupportedOperationException();
    }

    public String getFilename() {
        return filename;
    }

    public void setFilename(String filename) {
        this.filename = filename;
    }

}
