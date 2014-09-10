<%--
    Document   : filetree
    Created on : 4-aug-2010, 22:08:00
    Author     : Erik van de Pol
--%>
<%@include file="/WEB-INF/jsp/commons/taglibs.jsp" %>

<%@page contentType="text/html" pageEncoding="UTF-8"%>

<c:if test="${empty dirContent}">
    <c:set var="dirContent" value="${actionBean.dirContent}" scope="request"/>
</c:if>

<c:set var="dirs" value="${dirContent.dirs}" scope="page"/>
<c:set var="files" value="${dirContent.files}" scope="page"/>

<ul class="jqueryFileTree">
    <c:if test="${!empty dirs}">
        <c:forEach var="dir" items="${dirs}">
            <li class="directory collapsed ${dir.isFGDB ? 'fgdb' : ''}">
                <a href="#" rel="${dir.path}" title="${dir.name}">
                    ${dir.name}
                </a>
            </li>
        </c:forEach>
    </c:if>
    <c:if test="${!empty files}">
        <c:forEach var="file" items="${files}">
            <li class="file ext_${file.extension} ${file.type}">
                <a href="#" rel="${file.path}" title="${file.name}" isgeo="${file.isGeo}">
                    ${file.name}
                </a>
            </li>
        </c:forEach>
    </c:if>
</ul>
