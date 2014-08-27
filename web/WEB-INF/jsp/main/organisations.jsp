<%-- 
    Document   : organisations
    Created on : 9-aug-2011, 14:23:29
    Author     : Erik van de Pol
--%>

<%@include file="/WEB-INF/jsp/commons/taglibs.jsp" %>

<%@page contentType="text/html" pageEncoding="UTF-8"%>

<div style="padding: 1em">
    <p>
        Bewerk de toegestane organisaties en contactpersonen. Onthoud dat er altijd een correcte JSON datastructuur uit moet komen. Als dit niet het geval is, kan het zo zijn dat de hele site niet meer werkt.
    </p>
    <textarea id="organisationsJSON"><c:out value="${actionBean.organisations}"/></textarea>
</div>