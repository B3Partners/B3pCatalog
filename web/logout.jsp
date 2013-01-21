<%@include file="/WEB-INF/jsp/commons/taglibs.jsp" %>
<%@include file="/WEB-INF/jsp/commons/customization.jsp" %>
<%@include file="/WEB-INF/jsp/commons/urls.jsp" %>


<% request.getSession().invalidate(); %>


<stripes:layout-render name="/loginPage.jsp" pageTitle="${title} | Uitgelogd">
    <stripes:layout-component name="messages">
        <div class="mod message_info">
            U bent uitgelogd.
        </div>
    </stripes:layout-component>
    <stripes:layout-component name="content">
        <p>
        <a href="${contextPath}">Klik om opnieuw in te loggen</a>
    </stripes:layout-component>
</stripes:layout-render>