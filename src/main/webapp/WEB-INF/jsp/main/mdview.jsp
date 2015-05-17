<%-- 
    Document   : main
    Created on : 23-dec-2010, 16:03:01
    Author     : Erik van de Pol
--%>
<%@include file="/WEB-INF/jsp/commons/taglibs.jsp" %>

<stripes:layout-render name="/WEB-INF/jsp/templates/simple.jsp" pageTitle="${title}">
    <stripes:layout-component name="content">
        <jsp:include page="/WEB-INF/jsp/main/mdview_center.jsp"/>
    </stripes:layout-component>
</stripes:layout-render>
