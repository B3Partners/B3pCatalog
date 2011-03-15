<%@include file="/WEB-INF/jsp/commons/taglibs.jsp" %>

<stripes:layout-render name="/loginPage.jsp" pageTitle="${title} | Inloggen">
    <stripes:layout-component name="content">
        <stripes:layout-render name="/loginForm.jsp"/>
    </stripes:layout-component>
</stripes:layout-render>
