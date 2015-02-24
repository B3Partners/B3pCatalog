/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package nl.b3p.catalog.stripes;

import java.util.ArrayList;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;
import net.sourceforge.stripes.action.DefaultHandler;
import net.sourceforge.stripes.action.ForwardResolution;
import net.sourceforge.stripes.action.Resolution;
import net.sourceforge.stripes.validation.Validate;
import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

/**
 *
 * @author Geert Plaisier
 */
public class GeoBrabantAction extends DefaultAction {
    
    private final static Log log = LogFactory.getLog(GeoBrabantAction.class);
    
    @Validate(required=false)
    private String searchString;

    @Validate(required=false)
    private String searchType;

    @Validate(required=false)
    private String uuid;
    
    private List<MapsBean> mapsList;
    
    @DefaultHandler
    public Resolution home() {
        return new ForwardResolution("/WEB-INF/jsp/geobrabant/home.jsp");
    }
    
    /* Static pages */
    public Resolution overgeobrabant() {
        return new ForwardResolution("/WEB-INF/jsp/geobrabant/overgeobrabant.jsp");
    }
    public Resolution diensten() {
        return new ForwardResolution("/WEB-INF/jsp/geobrabant/diensten.jsp");
    }
    public Resolution contact() {
        return new ForwardResolution("/WEB-INF/jsp/geobrabant/contact.jsp");
    }
    
    public Resolution kaarten() {
        // This JSON should be fetched from a server somewhere
        String mapsJson = "[" +
            "{ \"class\": \"wat-mag-waar\", \"title\": \"Wat mag waar?\", \"description\": \"Waar ligt dat stukje grond? Zou ik hier mogen bouwen? Vragen die u beantwoord zult zien worden via dit thema. Bekijk welk perceel waar ligt en wat je ermee mag doen.\", \"url\": \"http://acc.geobrabant.nl/viewer/app/RIN01/v1\" }," +
            "{ \"class\": \"bekendmakingen\", \"title\": \"Bekendmakingen\", \"description\": \"Via bekendmakingen kunt u zien welke vergunningaanvragen in uw buurt zijn ingediend of verleend zijn. Hierdoor blijft u op de hoogte van de ontwikkelingen bij u in de buurt.\", \"url\": \"http://acc.geobrabant.nl/viewer/app/RIN02/v1\" }," +
            "{ \"class\": \"bereikbaarheid\", \"title\": \"Bereikbaarheid\", \"description\": \"Via dit thema kunt u erachter komen hoe de beriekbaarheid van een bepaald gebied is. Zo vindt u bijvoorbeeld waar de dichtstbijzijnde parkeergarage is, waar u oplaadpalen aantreft en actuele informatie over verkeer en wegwerkzaamheden\", \"url\": \"http://acc.geobrabant.nl/viewer/app/RIN03/v1\" }," +
            "{ \"class\": \"veiligheid\", \"title\": \"Veiligheid\", \"description\": \"In dit thema vindt u informatie over de veiligheid in uw buurt. Waar zit de politie en brandweer, maar ook overstromingsrisico, waterkeringen en de veiligheidsregio staan hier.\", \"url\": \"http://acc.geobrabant.nl/viewer/app/RIN04/v1\" }," +
            "{ \"class\": \"zorg\", \"title\": \"Zorg\", \"description\": \"Ziekenhuizen, doktersposten en verzorgingshuizen. Alle data met betrekking tot de (medische) zorg staan in dit thema beschreven.\", \"url\": \"http://acc.geobrabant.nl/viewer/app/RIN05/v1\" }," +
            "{ \"class\": \"onderwijs-kinderopvang\", \"title\": \"Onderwijs &amp; Kinderopvang\", \"description\": \"In dit thema vindt u de locatie van alle scholen en kinderopvang.\", \"url\": \"http://acc.geobrabant.nl/viewer/app/RIN06/v1\" }," +
            "{ \"class\": \"wijkvoorzieningen\", \"title\": \"Wijkvoorzieningen\", \"description\": \"Waar bij mij in de buurt bevinden zich afvalbakken, hondenuitlaatplaatsen en de speeltuin? Dergelijke wijkvoorzieningen vindt u in dit thema, evenals buurthuizen, winkelcentra, etc.\", \"url\": \"http://acc.geobrabant.nl/viewer/app/RIN07/v1\" }," +
            "{ \"class\": \"recreatie\", \"title\": \"Recreatie\", \"description\": \"Waar kan ik bij mij in de buurt vrije tijd besteden? In dit thema ziet u waar u kunt sporten en ontspannen. Ook wandel- en fietspaden, natuurgebieden en horecagelegenheden vindt u hier terug.\", \"url\": \"http://acc.geobrabant.nl/viewer/app/RIN08/v1\" }," +
            "{ \"class\": \"kunst-cultuur\", \"title\": \"Kunst &amp; Cultuur\", \"description\": \"In dit thema vindt u alle informatie over cultuurhistorie en musea: gemeentelijke- en rijksmonumenten, maar ook archeologische monumenten.\", \"url\": \"http://acc.geobrabant.nl/viewer/app/RIN09/v1\" }," +
            "{ \"class\": \"werklocaties\", \"title\": \"Werklocaties\", \"description\": \"In dit thema vindt u alles over bedrijvigheid. Bedrijventerreinen en kantoorlocaties, maar ook winkelcentra bij u in de buurt.\", \"url\": \"http://acc.geobrabant.nl/viewer/app/RIN10/v1\" }" +
        "]";
        this.mapsList = new ArrayList<MapsBean>();
        try {
            JSONArray maps = new JSONArray(mapsJson);
            for (int i = 0; i < maps.length(); ++i) {
                JSONObject rec = maps.getJSONObject(i);
                MapsBean map = new MapsBean();
                map.setTitle(rec.getString("title"));
                map.setDescription(rec.getString("description"));
                map.setUrl(rec.getString("url"));
		map.setCssClass(rec.getString("class"));
                this.mapsList.add(map);
            }
        } catch (JSONException ex) {
            Logger.getLogger(GeoBrabantAction.class.getName()).log(Level.SEVERE, null, ex);
        }
        
        return new ForwardResolution("/WEB-INF/jsp/geobrabant/kaarten.jsp");
    }
    
    public Resolution catalogus() {
        return new ForwardResolution("/WEB-INF/jsp/geobrabant/catalogus.jsp");
    }
    
    public Resolution zoeken() {
        return new ForwardResolution("/WEB-INF/jsp/geobrabant/zoeken.jsp");
    }

    public String getSearchString() {
        return searchString;
    }

    public void setSearchString(String searchString) {
        this.searchString = searchString;
    }

    public String getSearchType() {
        return searchType;
    }

    public void setSearchType(String searchType) {
        this.searchType = searchType;
    }

    public String getUuid() {
        return uuid;
    }

    public void setUuid(String uuid) {
        this.uuid = uuid;
    }

    public List<MapsBean> getMapsList() {
        return mapsList;
    }

    public void setMapsList(List<MapsBean> mapsList) {
        this.mapsList = mapsList;
    }
    
    public class MapsBean {
        
        private String title;
        
        private String description;
        
        private String url;
		
		private String cssClass;
        
        public MapsBean() {
            
        }

        public String getTitle() {
            return title;
        }

        public void setTitle(String title) {
            this.title = title;
        }

        public String getDescription() {
            return description;
        }

        public void setDescription(String description) {
            this.description = description;
        }
        
        public String getUrl() {
            return url;
        }

        public void setUrl(String url) {
            this.url = url;
        }

		public String getCssClass() {
			return cssClass;
		}

		public void setCssClass(String cssClass) {
			this.cssClass = cssClass;
		}

    }

}
