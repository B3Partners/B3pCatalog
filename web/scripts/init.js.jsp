<%-- 
    Document   : init.js
    Created on : 12-jan-2011, 16:40:49
    Author     : Erik van de Pol
--%>

<%@page contentType="text/javascript" pageEncoding="UTF-8"%>

<%@include file="/WEB-INF/jsp/commons/taglibs.jsp" %>
<%@include file="/WEB-INF/jsp/commons/urls.jsp" %>

if (typeof B3pCatalog == "undefined") B3pCatalog = {};

B3pCatalog.contextPath = "${contextPath}";
B3pCatalog.metadataUrl = "${metadataUrl}";
B3pCatalog.filetreeUrl = "${filetreeUrl}";
B3pCatalog.catalogUrl = "${catalogUrl}";

B3pCatalog.username = "${pageContext.request.remoteUser}";

B3pCatalog.title = "${title}";
B3pCatalog.titleSeparator = " | ";
B3pCatalog.customer = "${customer}";