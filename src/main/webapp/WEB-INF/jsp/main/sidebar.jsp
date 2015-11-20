<%-- 
    Document   : sidebar
    Created on : 2-feb-2011, 16:23:48
    Author     : Erik van de Pol
--%>

<%@include file="/WEB-INF/jsp/commons/taglibs.jsp" %>

<%@page contentType="text/html" pageEncoding="UTF-8"%>

<div id="sidebar" class="ui-layout-content">
	<stripes:useActionBean beanclass="nl.b3p.catalog.stripes.AdminCheckActionBean" event="init" var="b"/>
    <stripes:useActionBean beanclass="nl.b3p.catalog.stripes.AppConfigCheckActionBean" event="init" var="c"/>
    <c:choose>
        <c:when test="${c.addOnly}">
            <%@include file="info.jsp" %>
        </c:when>
        <c:otherwise>
            <%@include file="filetree.jsp" %>
        </c:otherwise>
    </c:choose>
    <c:if test="${!empty c.config.defaultCswServer && c.config.defaultCswServer.url != null}">
        <%@include file="search.jsp" %>
    </c:if>
    <c:if test="${b.admin}">
        <%@include file="admin.jsp" %>
    </c:if>
</div>
<%--
<div id="connect-local" class="ui-layout-content">
    <a href="#" onclick="B3pCatalog.connectDirectory()">Lokale map verkennen</a>
    <div id="applet-container"></div>                
</div>
--%>
