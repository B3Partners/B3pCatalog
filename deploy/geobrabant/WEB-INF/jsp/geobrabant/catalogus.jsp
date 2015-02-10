<%-- 
    Document   : home
    Created on : Oct 15, 2014, 11:18:16 AM
    Author     : geertplaisier
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@include file="/WEB-INF/jsp/commons/taglibs.jsp" %>

<stripes:layout-render name="/WEB-INF/jsp/templates/geobrabant.jsp" pageTitle="Welkom bij GeoBrabant - Catalogus" activePage="catalogus">
    <stripes:layout-component name="header">
        <header>
            <a href="<stripes:url beanclass="nl.b3p.catalog.stripes.GeoBrabantAction" />" class="pull-left">Home</a>
            <a href="#">Catalogus</a>
            <a href="<stripes:url beanclass="nl.b3p.catalog.stripes.GeoBrabantAction" event="kaarten"/>" class="pull-right">Kaartviewer</a>
        </header>
    </stripes:layout-component>
    <stripes:layout-component name="content">
        <h2>Zoeken in de Catalogus</h2>
        <div class="col col-2">
            <div class="zoekresultaten">
                <div class="zoeken-uitleg">
                    U bevindt zich nu in onze catalogus.
                    Hiermee krijgt u direct toegang tot het register met beschrijvingen van de datasets.
                    Via zoektermen is het mogelijk om de juiste informatie te vinden, te bekijken en te downloaden.
                    Vul rechts bij 'Zoeken' een zoekterm in klik op zoeken.
                    Hier verschijnen dan de zoekresultaten.
                </div>
                <div class="zoeken-afbeelding">
                    <img src="${contextPath}/images/geobrabant/woordweb.png" alt="Zoeksuggesties bijv. ruimte economie zorg veiligheid milieu" />
                </div>
            </div>
        </div>
        <div class="col">
            <fieldset>
                <stripes:form beanclass="nl.b3p.catalog.stripes.GeoBrabantAction" class="searchform">
                    <div class="submit">    
                        <input type="submit" name="catalogus" value="Zoeken"/>
                    </div>
                    <div class="inputfield">
                        <input type="search" placeholder="Zoeken" name="searchString" value="${actionBean.searchString}" />
                        <input type="hidden" name="searchType" value="AnyText" />
                    </div>
                </stripes:form>
            </fieldset>
        </div>
    </stripes:layout-component>
    <stripes:layout-component name="footerscripts">
        <script src="${contextPath}/scripts/mde/includes/jquery/jquery-latest.min.js" type="text/javascript"></script>
        <script src="${contextPath}/scripts/geobrabant/search.js" type="text/javascript"></script>
        <script>
            var searchComponent = GeoBrabant.SearchComponent.init({
                contextPath: '${contextPath}',
                searchString: '${actionBean.searchString}',
                searchType: '${actionBean.searchType}',
                searchUrl: '<stripes:url beanclass="nl.b3p.catalog.stripes.CatalogAction" event="search" />',
                resultUrl: '<stripes:url beanclass="nl.b3p.catalog.stripes.GeoBrabantAction" event="zoeken"/>&uuid=',
                summaryLength: 300
            });
            $('.searchform').bind('submit', function(e) {
                e.preventDefault();
                searchComponent.search($(this).find('input[name=searchString]').val(), $(this).find('input[name=searchType]').val());
            });
            $('input[name=searchString]').focus();
        </script>
    </stripes:layout-component>
</stripes:layout-render>
