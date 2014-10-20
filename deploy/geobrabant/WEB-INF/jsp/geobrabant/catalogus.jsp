<%-- 
    Document   : home
    Created on : Oct 15, 2014, 11:18:16 AM
    Author     : geertplaisier
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@include file="/WEB-INF/jsp/commons/taglibs.jsp" %>

<stripes:layout-render name="/WEB-INF/jsp/templates/geobrabant.jsp" pageTitle="Welkom bij GeoBrabant - Catalogus" activePage="catalogus">
    <stripes:layout-component name="content">
        <div class="col col-2">
            <h2>Zoekresultaten</h2>
            <div class="zoekresultaten">Zoek aan de rechterkant</div>
        </div>
        <div class="col">
            <h2>Zoeken in de Catalogus</h2>
            <fieldset>
                <stripes:form beanclass="nl.b3p.catalog.stripes.GeoBrabantAction" class="searchform">
                    <input type="search" placeholder="Zoeken" name="searchString" value="${actionBean.searchString}" />
                    <stripes:select name="searchType" value="${actionBean.searchType}">
                        <stripes:option value="AnyText">Overal</stripes:option>
                        <stripes:option value="Title">Titel</stripes:option>
                        <stripes:option value="Abstract">Samenvatting</stripes:option>
                        <stripes:option value="Identifier">Metadata UUID</stripes:option>
                    </stripes:select>
                    <input type="submit" name="catalogus" value="Zoek"/>
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
                resultUrl: '<stripes:url beanclass="nl.b3p.catalog.stripes.GeoBrabantAction" event="zoeken"/>&uuid='
            });
            $('.searchform').bind('submit', function(e) {
                e.preventDefault();
                searchComponent.search($(this).find('input[name=searchString]').val(), $(this).find('select[name=searchType]').val());
            });
        </script>
    </stripes:layout-component>
</stripes:layout-render>
