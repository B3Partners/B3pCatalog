<%-- 
    Document   : titlebar
    Created on : 23-jun-2011, 15:53:11
    Author     : Erik van de Pol
--%>
<%@include file="/WEB-INF/jsp/commons/taglibs.jsp" %>

<%-- can be overriden in deploy script --%>
<div id="header-logo">
    <h1>OpenMetadataMaker</h1>
    <h2><span class="icon-check"></span> Een eenvoudige metadatamaker voor lokale overheden</h2>
    <h2><span class="icon-check"></span> Open data vindbaar en duidelijk voor iedereen in drie stappen</h2>
</div>
<div class="sub-menu">
    <ul>
        <li><a href="#" class="dialog-link" data-target="over-openmetadatamaker">Over OpenMetadataMaker</a></li>
        <li><a href="#" class="dialog-link" data-target="over-open-source">Open Source</a></li>
    </ul>
</div>
<div id="over-openmetadatamaker" style="display: none;" title="Over OpenMetadataMaker">
    <p>
        De OpenMetadataMaker is in opdracht van Provincie Noord-Holland gemaakt in het kader van het Open Data Praktijkprogramma Noord-Holland Slimmer 2014. Lees meer hierover (<a href="http://www.noord-holland.nl/opendata/" target="_new">http://www.noord-holland.nl/opendata/</a>).
    </p>
    <p>
        De OpenMetadatMaker is ontworpen en gebouwd door B3Partners (technische realisatie en hosting) in samenwerking met The Green Land (uitvoerders van het Praktijkprogramma).
    </p>
    <p>
        Heeft u vragen over de OpenMetadataMaker dan kunt u contact opnemen met:
    </p>
    <p>
        Frank Verschoor<br />
        The Green Land<br />
        frank@thegreenland.eu<br />
        06 405 99679
    </p>
</div>
<div id="over-open-source" style="display: none;" title="Open Source">
    <p>
        De OpenMetadataMaker is een open source product. Dit betekent dat de broncode voor iedereen toegankelijk en herbruikbaar is. De code is beschikbaar via [naam/URL]
    </p>
    <p>
        De OpenMetadataMaker is gebouwd door B3Partners. B3Partners beheert de broncode van de OpenMetadataMaker. Heeft u (aanvullende) vragen over de broncode of het hergebruik ervan binnen uw eigen omgeving of anderszins, dan kunt u vanzelfsprekend ook contact opnemen met B3Partners via ... [B3P ZELF INVULLEN en zijn jullie het hiermee eens?]
    </p>
</div>
<script>
    $(document).ready(function() {
        $('#over-openmetadatamaker, #over-open-source').dialog({
            autoOpen: false,
            width: 500,
            height: 450
        });
        $('.dialog-link').click(function(e) {
            e.preventDefault();
            var target = '#' + $(this).data('target');
            $(target).show().dialog("open");
        });
    });
</script>