<%--
    Document   : header
    Created on : 16-sep-2010, 17:32:26
    Author     : Erik van de Pol
--%>

<%@include file="/WEB-INF/jsp/commons/taglibs.jsp" %>

<div class="ui-layout-ignore">
    <script type="text/javascript">
        $(document).ready(function() {
            var tabs = $("#main-tabs > li");
            tabs.hover(function() {
                $(this).add("a", this).toggleClass("main-tab-hover");
            }).click(function() {
                showTab($(this).find("a"));
                return false;
            }).find("> a").click(function() {
                showTab(this);
                return false;
            });
            if(tabs.length === 1) {
                tabs.hide();
            }
            if ($("#main-tabs > li.main-tab-selected").length == 0)
                showTab($("#main-tabs > li > a").first());
            
            $(".logout-link").click(function() {
                B3pCatalog.logout();
                return false;
            });
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
        <%@include file="branding.jsp" %>
        <div class="nav-bar">
            <div class="title-bar">
                <%@include file="titlebar.jsp" %>
                
                <c:if test="${!empty pageContext.request.remoteUser}">
                    <div class="login-info-block">
                        <div class="logged-in">
                            <fmt:message key="loggedIn"/>
                        </div>
                        <div class="logged-in-as">
                            <fmt:message key="loggedInAs"/>:
                        </div>
                        <div class="logged-in-as-user">
                            ${pageContext.request.remoteUser}
                        </div>
                        <a href="#" class="logout-link">Uitloggen</a>
                    </div>
                </c:if>
                <c:if test="${empty pageContext.request.remoteUser}">
                    <div class="login-info-block">
                        <div class="logged-in">
                            <fmt:message key="notLoggedIn"/>
                        </div>
                        <stripes:link class="login-link" href="/login.jsp">Inloggen</stripes:link>
                    </div>
                </c:if>                
            </div>
            <ul id="main-tabs" class="ui-helper-reset">
                <stripes:useActionBean beanclass="nl.b3p.catalog.stripes.AdminCheckActionBean" event="init" var="b"/>
                <stripes:useActionBean beanclass="nl.b3p.catalog.stripes.AppConfigCheckActionBean" event="init" var="c"/>
                <c:if test="${!c.config.isNoWritableRoots(pageContext.request)}">
                    <li class="ui-corner-top">
                        <a href="#info">Informatie</a>
                    </li>
                    <li class="ui-corner-top">
                        <a href="#filetree">Metadata bewerken</a>
                    </li>
                </c:if>
                <c:if test="${!empty c.config.defaultCswServer && c.config.defaultCswServer.url != null}">
                    <li class="ui-corner-top">
                        <a href="#search">Metadata doorzoeken</a> 
                    </li>
                </c:if>
                <c:if test="${b.admin}">
                    <li class="ui-corner-top">
                        <a href="#admin">Beheer</a>
                    </li>
                </c:if>
            </ul>
            <div id="page-tabs-and-toolbar" class="ui-helper-reset">
                <div id="toolbar" class="ui-helper-reset">&nbsp;</div>
                <div id="page-tabs" class="ui-helper-reset">&nbsp;</div>
            </div>
        </div>
    </div>
</div>
