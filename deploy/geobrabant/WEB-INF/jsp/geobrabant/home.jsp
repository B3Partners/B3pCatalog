<%-- 
    Document   : home
    Created on : Oct 15, 2014, 11:18:16 AM
    Author     : geertplaisier
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@include file="/WEB-INF/jsp/commons/taglibs.jsp" %>

<stripes:layout-render name="/WEB-INF/jsp/templates/geobrabant.jsp" pageTitle="Welkom bij GeoBrabant" activePage="home">
    <stripes:layout-component name="content">
        <div id="slider">
            <img src="${contextPath}/images/geobrabant/slider1.jpg" title="Landschappen in Brabant" alt="Mooie foto met landschappen in Brabant" />
            <img src="${contextPath}/images/geobrabant/slider2.jpg" title="Landschappen in Brabant" alt="Mooie foto met landschappen in Brabant" />
            <img src="${contextPath}/images/geobrabant/slider3.jpg" title="Landschappen in Brabant" alt="Mooie foto met landschappen in Brabant" />
            <img src="${contextPath}/images/geobrabant/slider4.jpg" title="Landschappen in Brabant" alt="Mooie foto met landschappen in Brabant" />
            <img src="${contextPath}/images/geobrabant/slider5.jpg" title="Landschappen in Brabant" alt="Mooie foto met landschappen in Brabant" />
        </div>
        <div class="col">
            <h2>Direct naar de kaarten</h2>
            <img src="${contextPath}/images/geobrabant/kaarten.png" />
            <p>
                Hier kunt u direct toegang krijgen tot de kaartbeelden. Ingedeeld in een 8 tal thema’s waarmee we de meest gestelde vragen hopen te kunnen beantwoorden.
            </p>
            <p>
                <a href="<stripes:url beanclass="nl.b3p.catalog.stripes.GeoBrabantAction" event="kaarten"/>" class="button"><b class="icon-map"></b> Naar de kaarten</a>
            </p>
        </div>
        <div class="col">
            <h2>Help me bij het zoeken</h2>
            <img src="${contextPath}/images/geobrabant/catalogus.png" />
            <p>
                Hier vindt u onze Catalogus, waarmee u direct toegang krijgt tot het register met beschrijvingen van de datasets.  Via zoektermen is het mogelijk om de juiste informatie te vinden, te bekijken en te downloaden.
            </p>
            <p>
                <a href="<stripes:url beanclass="nl.b3p.catalog.stripes.GeoBrabantAction" event="catalogus"/>" class="button"><b class="icon-search"></b> Naar de catalogus</a>
            </p>
        </div>
        <div class="col feed">
            <h2>Populair op GEOBrabant</h2>
            <a class="twitter-timeline" href="https://twitter.com/B3Partners/b3partners" data-widget-id="349847499529400320" width="300" height="350" data-link-color="#ed1b24">Tweets from @B3Partners</a>
            <script>!function(d,s,id){var js,fjs=d.getElementsByTagName(s)[0],p=/^http:/.test(d.location)?'http':'https';if(!d.getElementById(id)){js=d.createElement(s);js.id=id;js.src=p+"://platform.twitter.com/widgets.js";fjs.parentNode.insertBefore(js,fjs);}}(document,"script","twitter-wjs");</script>
        </div>
    </stripes:layout-component>
    <stripes:layout-component name="footerscripts">
        <script src="${contextPath}/scripts/geobrabant/ideal-image-slider.min.js"></script>
        <script>
        var slider = new IdealImageSlider.Slider({
            selector: '#slider',
            height: 200,
            interval: 4000
        });
        slider.addCaptions();
        slider.start();
        </script>
    </stripes:layout-component>
</stripes:layout-render>
