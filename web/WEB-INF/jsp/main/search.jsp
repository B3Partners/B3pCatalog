<%-- 
    Document   : search
    Created on : 2-feb-2011, 16:20:35
    Author     : Erik van de Pol
--%>

<%@include file="/WEB-INF/jsp/commons/taglibs.jsp" %>

<%@page contentType="text/html" pageEncoding="UTF-8"%>

<div id="search">
    <script type="text/javaScript">
        $(document).ready(function() {
            $("#searchButton").button();
            searchTabShown();
            $("#searchForm input:text, #searchForm select").width("200px");
        });

        function searchTabShown() {
            $("#searchStringBox").select();
        }
    </script>

    <stripes:form beanclass="nl.b3p.catalog.stripes.CatalogAction" id="searchForm">
        <!-- IE fix: IE submit niet als je op enter drukt in een textfield als het enige tf is in het form. Oplossing: invisible textfield! -->
        <!--[if IE]>
            <input type="text" style="display: none;" disabled="disabled" size="1" />
        <![endif]-->

        <table>
            <thead/>
            <tbody>
                <tr>
                    <td>Zoekterm:</td>
                    <td><stripes:text name="searchString" id="searchStringBox"/></td>
                </tr>
                <tr>
                    <td>Waar:</td>
                    <td>
                        <stripes:select name="searchType">
                            <stripes:option value="anyText">Overal</stripes:option>
                            <stripes:option value="title">Titel</stripes:option>
                            <stripes:option value="abstract">Samenvatting</stripes:option>
                            <stripes:option value="identifier">Metadata UUID</stripes:option>
                        </stripes:select>
                    </td>
                </tr>
            </tbody>
        </table>
        <stripes:submit name="search" id="searchButton">Zoek</stripes:submit>
    </stripes:form>

    <div id="searchResultsContainer"></div>
</div>
