<%-- 
    Document   : home
    Created on : Oct 15, 2014, 11:18:16 AM
    Author     : geertplaisier
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@include file="/WEB-INF/jsp/commons/taglibs.jsp" %>

<stripes:layout-render name="/WEB-INF/jsp/templates/geobrabant.jsp" pageTitle="Welkom bij GeoBrabant - Contact" activePage="contact">
    <stripes:layout-component name="content">
        <h2>Contact</h2>
        <div class="contactitem">
            <a class="title" href="http://www.s-hertogenbosch.nl/" target="_new">
                Gemeente 's-Hertogenbosch
                <img src="${contextPath}/images/geobrabant/denbosch.png" alt="Logo 's Hertogenbosch" />
            </a>
            <p>Het algemene nummer van de gemeente is (073)  615 51 55</p>
            <p>Het correspondentieadres van de gemeente is:<br />Postbus 12345, 5200 GZ, 's-Hertogenbosch</p>
            <p>Het bezoekadres is:<br />Wolvenhoek 1, 's-Hertogenbosch.</p>
            <p>Contactpersoon GeoBrabant: Constant Botter, tel: (06) 21 14 59 24</p>
        </div>
        <div class="contactitem">
            <a class="title" href="http://www.aaenmaas.nl/" target="_new">
                Waterschap Aa en Maas
                <img src="${contextPath}/images/geobrabant/waterschap.png" alt="Logo Waterschap Aa en Maas" />
            </a>
            <p>Het algemene nummer van het waterschap is: (073) 615 66 66</p>
            <p>Het correspondentieadres van het waterschap is:<br />Postbus 5049, 5201 GA, 's-Hertogenbosch</p>
            <p>Het bezoekadres is:<br />Wolvenhoek 1, 's-Hertogenbosch</p>
            <p>Contactpersoon GeoBrabant: Lambik Swinkels, tel: (06) 13 95 41 62</p>
        </div>
        <div class="contactitem">
            <a class="title" href="http://www.brabant.nl/" target="_new">
                Provincie Noord Brabant
                <img src="${contextPath}/images/geobrabant/brabant.png" alt="Logo Provincie Noord Brabant" />
            </a>
            <p>Het algemene nummer van de provincie is (073)  681 28 12</p>
            <p>Het correspondentieadres van de provincie is:<br />Postbus 90151, 5200 MC 's-Hertogenbosch</p>
            <p>Het bezoekadres is:<br />Brabantlaan 1, 5216 TV 's-Hertogenbosch</p>
            <p>Contactpersoon GeoBrabant: Erik Dietvorst, tel: (073)  681 26 14</p>
        </div>
        <div class="contactitem">
            <a class="title" href="http://www.b3partners.nl/" target="_new">
                B3Partners
                <img src="${contextPath}/images/geobrabant/b3partners.png" alt="Logo B3Partners" />
            </a>
        </div>
            <div class="contactitem">
            <a class="title" href="http://www.hashogeschool.nl/" target="_new">
                HAS Hogeschool
                <img src="${contextPath}/images/geobrabant/has.png" alt="Logo HAS Hogeschool" />
            </a>
        </div>
    </stripes:layout-component>
</stripes:layout-render>
