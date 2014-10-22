<%-- 
    Document   : home
    Created on : Oct 15, 2014, 11:18:16 AM
    Author     : geertplaisier
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@include file="/WEB-INF/jsp/commons/taglibs.jsp" %>

<stripes:layout-render name="/WEB-INF/jsp/templates/geobrabant.jsp" pageTitle="Welkom bij GeoBrabant - Diensten" activePage="diensten">
    <stripes:layout-component name="content">
        <h2>Diensten</h2>
        <ol class="spaced">
            <li>Open data voor burgers, bedrijven en onderwijs</li>
            <li>
                Dataopslag en webviewer voor het regionaal programma Agrifood Capital (Noord Oost Brabant)<br />
                <img src="${contextPath}/images/geobrabant/agrifood.png" alt="Logo Agrifood Capital" />
            </li>
            <li>
                Dataopslag en webviewer voor de Veiligheidsregio Brabant Noord<br />
                <img src="${contextPath}/images/geobrabant/veiligheidsregio.png" alt="Logo Veiligheidsregio Brabant Noord" />
            </li>
            <li>
                Beschikbaar stellen van open data voor HAS Hogeschool opleiding Geo Media & Design<br />
                <img src="${contextPath}/images/geobrabant/has.png" alt="Logo HAS Hogeschool" />
            </li>
            <li>
                Beschikbaar stellen van overheidsdata van de drie deelnemende overheden voor interne medewerkers<br />
                <img src="${contextPath}/images/geobrabant/denbosch.png" alt="Logo 's Hertogenbosch" />
                <img src="${contextPath}/images/geobrabant/waterschap.png" alt="Logo Waterschap Aa en Maas" />
                <img src="${contextPath}/images/geobrabant/brabant.png" alt="Logo Provincie Noord Brabant" />
            </li>
            <li>
                Beschikbaar stellen van meer diensten en services en ontzorgen van andere overheden (groeitraject)<br />
                <img src="${contextPath}/images/geobrabant/rin-knooppunt.png" alt="RIN Het knooppunt" />
                <img src="${contextPath}/images/geobrabant/groeitraject.png" alt="Groeitraject" />
            </li>
        </ol>	
    </stripes:layout-component>
</stripes:layout-render>
