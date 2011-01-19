<%--
    Document   : header
    Created on : 16-sep-2010, 17:32:26
    Author     : Erik van de Pol
--%>

<%@include file="/WEB-INF/jsp/commons/taglibs.jsp" %>

<div class="ui-layout-content">
    <div class="header">
        <div class="branding">
            <a title="Ga naar PBL homepagina" href="http://www.pbl.nl">
                <img src="<stripes:url value="${contextPath}/images/RO_PL_Logo_Homepage_nl.png"/>" alt="PBL logo" />
            </a>
        </div>
        <div class="nav-bar">
            <div class="title-bar">
                <h1>${title}</h1>
            </div>
            <div class="login-info-block">
                <div class="logged-in-as">
                    <fmt:message key="loggedInAs"/>
                    ${pageContext.request.remoteUser}
                </div>
                <stripes:link href="/logout.jsp" class="logout-link">Uitloggen</stripes:link>
            </div>
        </div>
    </div>
</div>
