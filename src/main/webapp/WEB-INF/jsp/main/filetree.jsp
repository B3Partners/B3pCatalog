<%--
    Document   : folderTree
    Created on : 23-dec-2010, 15:59:16
    Author     : Erik van de Pol
--%>

<%@include file="/WEB-INF/jsp/commons/taglibs.jsp" %>
<%@include file="/WEB-INF/jsp/commons/urls.jsp" %>

<%@page contentType="text/html" pageEncoding="UTF-8"%>


<div id="filetree" class="tab-definition">
    <div id="filetree-file"></div>
    <div id="filetree-sde"></div>
    <div id="filetree-kb"></div>
    <div id="filetree-local"></div>      
    <stripes:useActionBean beanclass="nl.b3p.catalog.stripes.AdminCheckActionBean" event="init" var="b"/>
    <c:if test="${b.admin}">
        &nbsp;&nbsp;&nbsp;<a href="#" onclick="B3pCatalog.addFile()">Nieuw bestand toevoegen</a>
    </c:if>   
</div>