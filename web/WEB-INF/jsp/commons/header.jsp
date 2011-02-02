<%--
    Document   : header
    Created on : 16-sep-2010, 17:32:26
    Author     : Erik van de Pol
--%>

<%@include file="/WEB-INF/jsp/commons/taglibs.jsp" %>

<div class="ui-layout-ignore">
    <script type="text/javascript">
        $(document).ready(function() {
            $("#main-tabs > li").hover(function() {
                $(this).add("a", this).addClass("main-tab-hover");
            }, function() {
                $(this).add("a", this).removeClass("main-tab-hover");
            });

            $("#main-tabs > li > a").click(function() {
                showTab(this);
                return false;
            });

            showTab($("#main-tabs > li > a").first());
        });

        function showTab(aElem) {
            $("#main-tabs > li > a").each(function() {
                $(this).parent().removeClass("main-tab-selected");
                $($(this).attr("href")).hide();
            });
            $(aElem).parent().addClass("main-tab-selected");
            $($(aElem).attr("href")).show();

            if ($(aElem).attr("href") === "#search")
                searchTabShown();
        }
    </script>
</div>

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
            <ul id="main-tabs" class="ui-helper-reset">
                <li class="ui-corner-top">
                    <a href="#filetree">Verkennen</a>
                </li>
                <li class="ui-corner-top">
                    <a href="#search">Zoeken</a>
                </li>
            </ul>
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
