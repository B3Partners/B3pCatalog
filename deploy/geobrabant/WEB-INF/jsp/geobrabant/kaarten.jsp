<%-- 
    Document   : home
    Created on : Oct 15, 2014, 11:18:16 AM
    Author     : geertplaisier
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@include file="/WEB-INF/jsp/commons/taglibs.jsp" %>

<stripes:layout-render name="/WEB-INF/jsp/templates/geobrabant.jsp" pageTitle="Welkom bij GeoBrabant - Kaarten" activePage="kaarten" title="Kaartviewer">
    <stripes:layout-component name="content">
        <div class="buttons">
			<div class="logo"></div>
			<hr />
			<div class="sociallinks">
				<a href="#" class="fcbk"></a>
				<a href="#" class="twttr"></a>
				<a href="#" class="lnkdn"></a>
				<a href="#" class="gpls"></a>
			</div>
			<hr />
			<strong>Kies een thema:</strong>
			<c:forEach items="${actionBean.mapsList}" var="map">
				<a class="button ${map.cssClass}" data-url="${map.url}" title="${map.description}"><span>${map.title}</span></a>
			</c:forEach>
			<hr />
        </div>
        <div class="content">
            <iframe src="" frameborder="0"></iframe>
        </div>
    </stripes:layout-component>
    <stripes:layout-component name="footerscripts">
        <script src="${contextPath}/scripts/geobrabant/maps.js" type="text/javascript"></script>
    </stripes:layout-component>
</stripes:layout-render>
