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
package nl.b3p.catalog.config;

import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;
import javax.xml.bind.annotation.XmlAttribute;
import javax.xml.bind.annotation.XmlList;
import javax.xml.bind.annotation.XmlTransient;

/**
 *
 * @author Matthijs Laan
 */
public class ArcObjectsConfig {
    @XmlAttribute
    private boolean enabled;
    
    @XmlAttribute
    @XmlList
    private List<String> productCodes = new ArrayList<String>(Arrays.asList(new String[] {
        "ArcInfo", "ArcEditor", "ArcView", "ArcServer", "EngineGeoDB", "Engine"
    }));
    
    @XmlAttribute
    private String arcEngineHome;
    
    @XmlAttribute
    private boolean forkSynchroniser;

    //<editor-fold defaultstate="collapsed" desc="getters en setters">
    @XmlTransient
    public String getArcEngineHome() {
        return arcEngineHome;
    }

    public void setArcEngineHome(String arcEngineHome) {
        this.arcEngineHome = arcEngineHome;
    }

    @XmlTransient
    public boolean isEnabled() {
        return enabled;
    }

    public void setEnabled(boolean enabled) {
        this.enabled = enabled;
    }

    @XmlTransient
    public boolean isForkSynchroniser() {
        return forkSynchroniser;
    }

    public void setForkSynchroniser(boolean forkSynchroniser) {
        this.forkSynchroniser = forkSynchroniser;
    }

    @XmlTransient
    public List<String> getProductCodes() {
        return productCodes;
    }

    public void setProductCodes(List<String> productCodes) {
        this.productCodes = productCodes;
    }
    //</editor-fold>
}


