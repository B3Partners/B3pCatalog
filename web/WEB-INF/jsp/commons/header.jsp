<%--
    Document   : header
    Created on : 16-sep-2010, 17:32:26
    Author     : Erik van de Pol
--%>

<%@include file="/WEB-INF/jsp/commons/taglibs.jsp" %>

<div class="ui-layout-content header">
    <div class="login-info-block">
        <div class="logged-in-as">
            <fmt:message key="loggedInAs"/>
            ${pageContext.request.remoteUser}
        </div>
        <stripes:link href="/logout.jsp" class="logout-link">Uitloggen</stripes:link>
    </div>
    <img src="<stripes:url value="${contextPath}/images/B3pCatalogLogo.png"/>" alt="B3pCatalog Logo" style="margin-left: 50px;" />
</div>
