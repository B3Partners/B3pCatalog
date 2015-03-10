<%-- 
    Document   : mde
    Created on : 23-dec-2010, 15:59:38
    Author     : Erik van de Pol
--%>
<%@include file="/WEB-INF/jsp/commons/taglibs.jsp" %>

<%@page contentType="text/html" pageEncoding="UTF-8"%>

<div class="ui-layout-content">
    <div id="infobuttons" class="content-center"></div>
    <div id="center-wrapper"></div>
    <div id="bottom-wrapper" class="content-center">
        <div class="checkbox-row">
            <input type="checkbox" class="nice-checkbox" value="natgeo" id="natgeo" />
            <label for="natgeo">
                publiceer in NationaalGeoregister.nl
                <span class="info">Vink aan als deze dataset een geo-dataset betreft en u wilt dat deze ook wordt opgenomen in het National Georegister. D&eacute; vindplaats van geo-informatie in Nederland.</span>
            </label>
        </div>
        <div class="checkbox-row">
            <input type="checkbox" class="nice-checkbox" value="dataoverheid" id="dataoverheid" />
            <label for="dataoverheid">
                publiceer in data.overheid.nl
                <span class="info">Vink aan als deze dataset ook wordt opgenomen in Data.overheid.nl. H&eacute;t open data portaal van de Nederlandse overheid.</span>
            </label>
        </div>
    </div>
    <script>
        $(document).ready(function() {
            var toolbar = $('#infobuttons');
            toolbar.append(
                $("<a />", {
                    href: "#",
                    id: "createNewMDi",
                    text: "Nieuw bestand maken",
                    title: "Nieuw metadatadocument maken.",
                    class: "wide-button",
                    click: function(event) {
                        $(this).removeClass("ui-state-hover");
                        B3pCatalog._addFile('', true);
                        return false;
                    }
                }).button({
                    icons: {
                        primary: "button-icon icon-plus"
                    }
                })
            );
            toolbar.append(
                $("<a />", {
                    href: "#",
                    id: "importMDi",
                    text: "Bestand laden",
                    title: "Metadatadocument importeren en over huidige metadatadocument heen kopiëren. Wordt nog niet opgeslagen.",
                    class: "wide-button",
                    click: function(event) {
                        $(this).removeClass("ui-state-hover");
                        B3pCatalog.importMetadata();
                        return false;
                    }
                }).button({
                    icons: {
                        primary: "button-icon icon-download"
                    }
                })
            );
            B3pCatalog._addFile('', true);
        });
    </script>
</div>