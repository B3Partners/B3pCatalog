<%-- 
    Document   : home
    Created on : Oct 15, 2014, 11:18:16 AM
    Author     : geertplaisier
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@include file="/WEB-INF/jsp/commons/taglibs.jsp" %>

<stripes:layout-render name="/WEB-INF/jsp/templates/geobrabant.jsp" pageTitle="Welkom bij GeoBrabant" activePage="home">
    <stripes:layout-component name="content">
        <div class="scroll-wrapper">
            <div class="home-wrapper">
                <jsp:include page="/WEB-INF/jsp/geobrabant/socialmedia.jsp" />
                <div class="hero-unit">
                    <div class="logo"></div>
                </div>
                <div class="home-menu">
                    <div class="wrapper">
                        <a href="<stripes:url beanclass="nl.b3p.catalog.stripes.GeoBrabantAction" event="kaarten"/>">
                            <img src="${contextPath}/styles/geobrabant/images/kaartviewer_picture.png" alt="Kaartviewer" />
                        </a>
                        De GeoBrabant kaartviewer geeft op een inzichtelijke<br />
                        manier weer wat er bij u in de omgeving te vinden is.
                        <a href="<stripes:url beanclass="nl.b3p.catalog.stripes.GeoBrabantAction" event="kaarten"/>" class="hide-text button button-kaarten">Kaartviewer</a>
                    </div>
                    <div class="wrapper">
                        <a href="<stripes:url beanclass="nl.b3p.catalog.stripes.GeoBrabantAction" event="catalogus"/>">
                            <img src="${contextPath}/styles/geobrabant/images/catalogus_picture.png" alt="Catalogus" />
                        </a>
                        Via de catalogus krijgt u toegang tot alle datasets.<br />
                        Datasets zoeken, bekijken en downloaden.
                        <a href="<stripes:url beanclass="nl.b3p.catalog.stripes.GeoBrabantAction" event="catalogus"/>" class="hide-text button button-catalogus">Catalogus</a>
                    </div>
                </div>
                <div class="home-section">
                    <h1><span>Over <span class="brabant">GeoBrabant</span></span></h1>
                    <img src="${contextPath}/images/geobrabant/facebook.png" />
                    GeoBrabant is het verzamelknooppunt van de ruimtelijke informatie in de Brabantse regio. De provincie Noord-Brabant, de 3 Brabantse waterschappen en de Brabantse gemeenten werken samen aan deze voorziening. Hiermee wordt de basis neergelegd voor een gezamenlijke dienstverlening en bedrijfsvoering. Op een moderne manier biedt GeoBrabant provinciedekkende geodata en hulpmiddelen aan voor maatschappelijke organisaties en ondersteunt het de duurzame Brabantse thema’s, zoals Agrifood Capital. Het betreft nieuwe en op-maat diensten die in samenspraak met het bedrijfsleven en onderwijs ontwikkeld zullen worden.
                </div>
                <div class="home-section">
                    <h1><span>Diensten</span></h1>
                    <strong>1: </strong>Open data voor burgers, bedrijven en onderwijs<br />
                    <strong>2. </strong>Dataopslag en webviewer voor het regionaal programma Agrifood Capital (Noord Oost Brabant)<br />
                    <strong>3. </strong>Dataopslag en webviewer voor de Veiligheidsregio Brabant Noord<br />
                    <strong>4. </strong>Beschikbaar stellen van open data voor HAS Hogeschool opleiding Geo Media & Design<br />
                    <strong>5. </strong>Beschikbaar stellen van overheidsdata van de drie deelnemende overheden voor interne medewerkers<br />
                    <strong>6. </strong>Beschikbaar stellen van meer diensten en services en ontzorgen van andere overheden (groeitraject)<br />
                </div>
                <div class="home-section contact">
                    <h1><span>Contact</span></h1>
                    <div class="contact-col">
                        <a href="http://www.s-hertogenbosch.nl/" target="_new" class="contact-logo">
                            <img src="${contextPath}/styles/geobrabant/images/gemeente.png" alt="Gemeente 's Hertogenbosch" />
                        </a>
                        <div class="description">
                            Contactpersoon GeoBrabant<br />
                            Constant Botter
                            <span class="email">c.botter@s-hertogenbosch.nl</span>
                            <span class="phone">(0)6 21 14 59 24</span>
                        </div>
                    </div>
                    <div class="contact-col">
                        <a href="http://www.aaenmaas.nl/" target="_new" class="contact-logo">
                            <img src="${contextPath}/styles/geobrabant/images/waterschap_aa_en_maas.png" alt="Waterschap Aa en Maas" />
                        </a>
                        <div class="description">
                            Contactpersoon GeoBrabant<br />
                            Lambik Swinkels
                            <span class="email">LSwinkels@aaenmaas.nl</span>
                            <span class="phone">(0)6 13 95 41 62</span>
                        </div>
                    </div>
                    <div class="contact-col">
                        <a href="http://www.brabant.nl/" target="_new" class="contact-logo">
                            <img src="${contextPath}/styles/geobrabant/images/provincie.png" alt="Provincie Noord-Brabant" />
                        </a>
                        <div class="description">
                            Contactpersoon GeoBrabant<br />
                            Erik Dietvorst
                            <span class="email">EDietvorst@brabant.nl</span>
                            <span class="phone">(0)73 681 28 12</span>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </stripes:layout-component>
</stripes:layout-render>
