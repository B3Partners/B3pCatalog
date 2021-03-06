<%-- 
    Document   : template
    Created on : 22-apr-2010, 17:57:44
    Author     : Erik van de Pol
--%>

<%@include file="/WEB-INF/jsp/commons/taglibs.jsp" %>
<%@include file="/WEB-INF/jsp/commons/urls.jsp" %>
<%@include file="/WEB-INF/jsp/commons/customization.jsp" %>

<%@page contentType="text/html" pageEncoding="UTF-8"%>

<stripes:layout-definition>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01//EN" "http://www.w3.org/TR/html4/strict.dtd">
<html>
    <head>
        <meta http-equiv="Expires" content="-1" />
        <meta http-equiv="Cache-Control" content="max-age=0, no-store" />
        <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
        
        <title>${pageTitle}</title>

        <link rel="shortcut icon" href="${contextPath}/images/favicon.ico" />

        <link rel="stylesheet" type="text/css" href="${contextPath}/scripts/mde/styles/jquery-ui-latest.custom.css" />
        <link rel="stylesheet" type="text/css" href="${contextPath}/scripts/mde/styles/metadataEdit.css" />
        <link rel="stylesheet" type="text/css" href="${contextPath}/scripts/mde/styles/metadataEditSimple.css" />
        <link rel="stylesheet" type="text/css" href="${contextPath}/scripts/mde/styles/deploy.css" />
        <!--[if IE]> <link rel="stylesheet" type="text/css" href="${contextPath}/scripts/mde/styles/metadataEdit-ie.css" /> <![endif]-->
        <!--[if lte IE 7]> <link rel="stylesheet" type="text/css" href="${contextPath}/scripts/mde/styles/metadataEdit-ie7.css" /> <![endif]-->
        <link rel="stylesheet" type="text/css" href="${contextPath}/styles/jquery.filetree.css" />
        <link rel="stylesheet" type="text/css" href="${contextPath}/styles/main.css" />
        <link rel="stylesheet" type="text/css" href="${contextPath}/styles/icons.css" />
        <link rel="stylesheet" type="text/css" href="${contextPath}/styles/deploy.css" />

        <script type="text/javascript" charset="utf-8" src="${contextPath}/scripts/mde/includes/jquery/jquery-latest.js"></script>
        <!--script type="text/javascript" charset="utf-8" src="${contextPath}/scripts/jquery/jquery-latest.min.js"></script-->
        <script type="text/javascript" charset="utf-8" src="${contextPath}/scripts/mde/includes/jquery-ui/jquery-ui-latest.custom.js"></script>
        <!--script type="text/javascript" charset="utf-8" src="${contextPath}/scripts/mde/includes/jquery-ui/jquery-ui-latest.custom.min.js"></script-->
        <script type="text/javascript" charset="utf-8" src="${contextPath}/scripts/mde/includes/jquery.ui.datepicker-nl/jquery.ui.datepicker-nl.js"></script>

        <script type="text/javascript" charset="utf-8" src="${contextPath}/scripts/jquery.layout/jquery.layout-latest.js"></script>
        <script type="text/javascript" charset="utf-8" src="${contextPath}/scripts/jquery.form/jquery.form.js"></script>
        <script type="text/javascript" charset="utf-8" src="${contextPath}/scripts/jquery.scrollTo/jquery.scrollTo.js"></script>
        <!--script type="text/javascript" charset="utf-8" src="${contextPath}/scripts/jquery.scrollTo/jquery.scrollTo-min.js"></script-->
        <script type="text/javascript" charset="utf-8" src="${contextPath}/scripts/jquery.filetree/jquery.filetree-latest.js"></script>
        <script type="text/javascript" charset="utf-8" src="${contextPath}/scripts/jquery.easing/jquery.easing-latest.js"></script>
        <script type="text/javascript" charset="utf-8" src="${contextPath}/scripts/jquery.ThreeDots/jquery.ThreeDots.js"></script>
        <script type="text/javascript" charset="utf-8" src="${contextPath}/scripts/jquery.bbq/jquery.ba-bbq.js"></script>
        <!--script type="text/javascript" charset="utf-8" src="${contextPath}/scripts/jquery.bbq/jquery.ba-bbq.min.js"></script-->
        <script type="text/javascript" charset="utf-8" src="${contextPath}/scripts/jquery.cookie/jquery.cookie.js"></script>

        <!-- mde dependencies -->
        <script type="text/javascript" charset="utf-8" src="${contextPath}/scripts/mde/includes/Math.uuid.js"></script>
        <script type="text/javascript" charset="utf-8" src="${contextPath}/scripts/mde/includes/wiki2html.js"></script>

        <!-- script type="text/javascript" charset="utf-8" src="${orgsUrl}"></script -->
        <script type="text/javascript" src="${contextPath}/scripts/mde/picklists/gemet-inspire-nl.js"></script>
        
        <!-- mde -->
        <script type="text/javascript" charset="utf-8" src="${contextPath}/scripts/mde/includes/mde.js"></script>
        <script type="text/javascript" charset="utf-8" src="${contextPath}/scripts/mde/includes/commonOptions.js"></script>
        <!--script type="text/javascript" charset="utf-8" src="${contextPath}/scripts/mde/includes/start.js"></script-->

        <!-- B3pCatalog main js -->
        <script type="text/javascript" charset="utf-8" src="${contextPath}/scripts/init.js.jsp"></script>
        <script type="text/javascript" charset="utf-8" src="${contextPath}/scripts/mdeOptions.js"></script>
        <script type="text/javascript" charset="utf-8" src="${contextPath}/scripts/main.js"></script>

        <!-- connect local folder -->
        <script type="text/javascript" src="${contextPath}/applet/deployJavaSucks.js"></script>
        <script type="text/javascript" charset="utf-8" src="${contextPath}/scripts/local.js"></script>

        <stripes:layout-component name="head"/>

        <script type="text/javascript">
            $(document).ready(function() {
                theLayout = $("body").layout({
                    // algemeen:
                    resizable: false,
                    closable: false,
                    spacing_close: 0,
                    spacing_open: 0,
                    // per pane:
                    west__size: getWestSize(),
                    west__resizable: true,
                    west__spacing_open: 4,
                    enableCursorHotkey: false,
                    onresize: B3pCatalog.resizeTabsAndToolbar
                });
                
                $(window).resize(function() {
                    theLayout.sizePane("west", getWestSize());
                });

                // metadata files are always loaded via hash changes:
                $(window).bind("hashchange", B3pCatalog.hashchange);

                // Since the event is only triggered when the hash changes, we need to trigger
                // the event now, to handle the hash the page may have loaded with.
                $(window).trigger("hashchange");
            });
            
            function getWestSize() {
                var maxwidth = 375;
                var third = $("body").width() / 3;
                return third < maxwidth ? third: maxwidth;
            }

        </script>

    </head>
    <body>
        <div class="ui-layout-north" id="north">
            <stripes:layout-component name="header">
                <jsp:include page="/WEB-INF/jsp/commons/header.jsp" />
            </stripes:layout-component>
        </div>

        <div class="ui-layout-west" id="west">
            <stripes:layout-component name="west">
                <jsp:include page="/WEB-INF/jsp/commons/west.jsp"/>
            </stripes:layout-component>
        </div>

        <div class="ui-layout-center" id="center">
            <stripes:layout-component name="content"/>
        </div>

        <div class="ui-layout-south" id="south">
            <stripes:layout-component name="footer">
                <jsp:include page="/WEB-INF/jsp/commons/footer.jsp"/>
            </stripes:layout-component>
        </div>

    </body>
</html>

</stripes:layout-definition>