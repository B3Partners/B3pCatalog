<%-- 
    Document   : main
    Created on : 23-dec-2010, 16:03:01
    Author     : Erik van de Pol
--%>
<%@include file="/WEB-INF/jsp/commons/taglibs.jsp" %>

<stripes:layout-render name="/WEB-INF/jsp/templates/default.jsp" pageTitle="${title}">
    <stripes:layout-component name="west">
        <jsp:include page="/WEB-INF/jsp/main/sidebar.jsp"/>
    </stripes:layout-component>
    <stripes:layout-component name="content">
        <jsp:include page="/WEB-INF/jsp/main/mde.jsp"/>
    </stripes:layout-component>
</stripes:layout-render>
