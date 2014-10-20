<%-- 
    Document   : home
    Created on : Oct 15, 2014, 11:18:16 AM
    Author     : geertplaisier
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@include file="/WEB-INF/jsp/commons/taglibs.jsp" %>

<stripes:layout-render name="/WEB-INF/jsp/templates/geobrabant.jsp" pageTitle="Welkom bij GeoBrabant - Zoekresultaat" activePage="zoeken">
    <stripes:layout-component name="content">
        <div class="col col-2 zoekresultaten">
            <h2>Titel van de informatiebron</h2>
            <p>
                Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod
                tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam,
                quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo
                consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse
                cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non
                proident, sunt in culpa qui officia deserunt mollit anim id est laborum.
            </p>
            <p>
                Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod
                tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam,
                quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo
                consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse
                cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non
                proident, sunt in culpa qui officia deserunt mollit anim id est laborum.
            </p>
        </div>
        <div class="col">
            <h2>U wilt verder</h2>
            <a href="" class="button spacing">Bekijk de informatie op de kaart</a>
            <a href="" class="button spacing">Download de data / Link naar de service</a>
            <a href="" class="button spacing">Bekijk metadata in detail</a>
        </div>
    </stripes:layout-component>
    <stripes:layout-component name="footerscripts">
        <script src="${contextPath}/scripts/mde/includes/jquery/jquery-latest.min.js" type="text/javascript"></script>
        <script src="${contextPath}/scripts/geobrabant/search.js" type="text/javascript"></script>
        <script>
            GeoBrabant.SearchComponent.init({
                contextPath: '${contextPath}',
                searchString: '${actionBean.uuid}',
                searchKey: 'uuid',
                resultClass: 'zoekresultaat uuid',
                searchUrl: '<stripes:url beanclass="nl.b3p.catalog.stripes.CatalogAction" event="load" />'
            });
        </script>
    </stripes:layout-component>
</stripes:layout-render>
