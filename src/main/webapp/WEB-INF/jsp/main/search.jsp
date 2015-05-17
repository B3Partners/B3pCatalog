<%-- 
    Document   : search
    Created on : 2-feb-2011, 16:20:35
    Author     : Erik van de Pol
--%>

<%@include file="/WEB-INF/jsp/commons/taglibs.jsp" %>

<%@page contentType="text/html" pageEncoding="UTF-8"%>

<div id="search" class="tab-definition">
    <script type="text/javascript">
        $(document).ready(function() {
            $("#searchForm input:text, #searchForm select").width("200px");
            $("#searchForm").ajaxForm({
                target: "#searchResultsContainer",
                beforeSerialize: function($form, options) {
                    $("#searchResultsContainer").html($("<img />", {
                        src: B3pCatalog.contextPath + "/styles/images/spinner.gif"
                    }));
                    // wrong Stripes action is called when searchstring is empty (!?). Workaround:
                    if ($.trim($("#searchStringBox").val()) === "") {
                        $("#searchStringBox").val("*");
                    }
                },
                global: false,
                error: function(jqXHR, textStatus, errorThrown) {
                    $("#searchResultsContainer").html($("<div/>", {
                        "class": "message_err",
                        html: jqXHR.responseText
                    }));
                }
            });
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
                    <td><stripes:text name="searchString" id="searchStringBox" value=""/></td>
                </tr>
                <tr>
                    <td>Waar:</td>
                    <td>
                        <!-- Hoofdletters in values verplicht wanneer je verbindt met Deegree bijv.!! -->
                        <stripes:select name="searchType">
                            <stripes:option value="AnyText">Overal</stripes:option>
                            <stripes:option value="Title">Titel</stripes:option>
                            <stripes:option value="Abstract">Samenvatting</stripes:option>
                            <stripes:option value="Identifier">Metadata UUID</stripes:option>
                        </stripes:select>
                    </td>
                </tr>
            </tbody>
        </table>
        <stripes:submit name="search" id="searchButton" value="Zoek" />
    </stripes:form>

    <div id="searchResultsContainer"></div>
</div>
