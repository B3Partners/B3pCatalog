<%-- 
    Document   : home
    Created on : Oct 15, 2014, 11:18:16 AM
    Author     : geertplaisier
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@include file="/WEB-INF/jsp/commons/taglibs.jsp" %>

<stripes:layout-render name="/WEB-INF/jsp/templates/geobrabant.jsp" pageTitle="Welkom bij GeoBrabant - Zoekresultaat" activePage="zoeken">
    <stripes:layout-component name="content">
        <div class="col col-2 zoekresultaten"></div>
        <div class="col zoekresultaten_buttons">
            <h2>U wilt verder</h2>
            <a href="" class="button spacing mapbutton" target="_new">Bekijk de informatie op de kaart</a>
            <a href="" class="button spacing downloadbutton" target="_new">Download de data</a>
            <a href="" class="button spacing metadatabutton" target="_new">Bekijk metadata in detail</a>
        </div>
    </stripes:layout-component>
    <stripes:layout-component name="footerscripts">
        <script src="${contextPath}/scripts/mde/includes/jquery/jquery-latest.min.js" type="text/javascript"></script>
        <script src="${contextPath}/scripts/geobrabant/search.js" type="text/javascript"></script>
        <script>
            (function($) {
                function getValueOrDefault(value, defaultValue) {
                    if(value) {
                        return value;
                    }
                    return defaultValue;
                }
                GeoBrabant.SearchComponent.init({
                    contextPath: '${contextPath}',
                    searchString: '${actionBean.uuid}',
                    searchKey: 'uuid',
                    resultClass: 'zoekresultaat uuid',
                    searchUrl: '<stripes:url beanclass="nl.b3p.catalog.stripes.CatalogAction" event="load" />',
                    resultCallback: function(result) {
                        var resultObject = result.result[0];
                        var image = getValueOrDefault(resultObject.browseGraphicFileName, '${contextPath}/images/geobrabant/no-image.png');
                        var tags = getValueOrDefault(resultObject.keyWords, []);
                        var container = $('.zoekresultaat.uuid');
                        container.find('h2').after('<img src="' + image + '" />');
                        var tagCloud = $('<div class="tagcloud"></div>');
                        for(var i = 0; i < tags.length; i++) {
                            tagCloud.append('<span>' + tags[i] + '</span> ');
                        }
                        container.append(tagCloud);
                        container.append('<hr />');
                        container.append('<strong>Organisatie: </strong><span>' + resultObject.responsibleOrganisationName + '</span><br />');
                        container.append('<strong>Datum: </strong><span>' + resultObject.dateStamp + ' / ');
                        container.append('<strong>Standaard: </strong>' + resultObject.metadataStandardName + ' / ');
                        container.append('<strong>UUID: </strong>' + resultObject.uuid);
                        // Set button URL's
                        var catalogUrl = '${contextPath}/editor.jsp#uuid=' + resultObject.uuid;
                        $('.metadatabutton').attr('href', catalogUrl);
                        if(resultObject.urlDatasets) {
                            for(var j in resultObject.urlDatasets) {
                                if(!resultObject.urlDatasets.hasOwnProperty(j)) {
                                    continue;
                                }
                                var protocol = resultObject.urlDatasets[j].protocol;
                                if(protocol === 'website') {
                                    $('.mapbutton').attr('href', resultObject.urlDatasets[j].href).show();
                                }
                                else if(protocol === 'download') {
                                    $('.downloadbutton').attr('href', resultObject.urlDatasets[j].href).show();
                                }
                            }
                        }
                    }
                });
            }(jQuery));
        </script>
    </stripes:layout-component>
</stripes:layout-render>
