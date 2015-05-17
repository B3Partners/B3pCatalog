<%-- 
    Document   : admin
    Created on : 9-aug-2011, 14:26:13
    Author     : Erik van de Pol
--%>

<%@include file="/WEB-INF/jsp/commons/taglibs.jsp" %>

<%@page contentType="text/html" pageEncoding="UTF-8"%>

<div id="info" class="tab-definition info-tab">

    <h1>
        <i class="icon-info"></i>
    </h1>
    <p>
        Maak hier nieuwe metadata aan of
        laad metadata in.
    </p>
    
    <div id="infobuttons"></div>
    
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
