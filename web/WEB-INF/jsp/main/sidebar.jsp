<%-- 
    Document   : sidebar
    Created on : 2-feb-2011, 16:23:48
    Author     : Erik van de Pol
--%>

<%@include file="/WEB-INF/jsp/commons/taglibs.jsp" %>

<%@page contentType="text/html" pageEncoding="UTF-8"%>

<div id="sidebar" class="ui-layout-content">
    <%@include file="filetree.jsp" %>
    <%@include file="search.jsp" %>
    <%@include file="admin.jsp" %>
</div>

<div id="connect-local" class="ui-layout-content">
    <a href="#" onclick="B3pCatalog.connectDirectory()">Lokale map verkennen...</a>
    
    <div id="applet-container"></div>
</div>