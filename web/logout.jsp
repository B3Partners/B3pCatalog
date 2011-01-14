<%@include file="/WEB-INF/jsp/commons/taglibs.jsp" %>
<%@include file="/WEB-INF/jsp/commons/urls.jsp" %>


<% request.getSession().invalidate(); %>


<stripes:layout-render name="/loginPage.jsp" pageTitle="B3pCatalog | Uitgelogd">
    <stripes:layout-component name="messages">
        <div class="mod message_info">
            U bent uitgelogd.
        </div>
    </stripes:layout-component>
    <stripes:layout-component name="content">
        <stripes:layout-render name="/loginForm.jsp"/>
    </stripes:layout-component>
</stripes:layout-render>