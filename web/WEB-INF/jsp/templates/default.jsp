<%-- 
    Document   : template
    Created on : 22-apr-2010, 17:57:44
    Author     : Erik van de Pol
--%>

<%@include file="/WEB-INF/jsp/commons/taglibs.jsp" %>
<%@page contentType="text/html" pageEncoding="UTF-8"%>

<stripes:layout-definition>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01//EN" "http://www.w3.org/TR/html4/strict.dtd">
<html>
    <head>
        <meta http-equiv="Expires" content="-1" />
        <meta http-equiv="Cache-Control" content="max-age=0, no-store" />
        <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />

        <title>${pageTitle}</title>

        <link rel="icon" href="${contextPath}/images/favicon.ico" type="image/x-icon" />

        <!-- Rijkshuisstijl PBL -->
        <!--link rel="stylesheet" type="text/css" href="${contextPath}/styles/screen.css" media="screen" />
        <link rel="stylesheet" type="text/css" href="${contextPath}/styles/print.css" media="print" /-->
        <!-- Overige css -->
        <link rel="stylesheet" type="text/css" href="${contextPath}/scripts/mde/styles/profiles/pbl/jquery-ui-latest.custom.css" />
        <link rel="stylesheet" type="text/css" href="${contextPath}/scripts/mde/styles/profiles/pbl/metadataEdit.css" />
        <!--[if IE]> <link rel="stylesheet" type="text/css" href="${contextPath}/scripts/mde/styles/metadataEdit-ie.css" /> <![endif]-->
        <!--[if lte IE 7]> <link rel="stylesheet" type="text/css" href="${contextPath}/scripts/mde/styles/metadataEdit-ie7.css" /> <![endif]-->
        <link rel="stylesheet" type="text/css" href="${contextPath}/styles/jquery.filetree.css" />
        <link rel="stylesheet" type="text/css" href="${contextPath}/styles/main.css" />

        <script type="text/javascript" src="${contextPath}/scripts/mde/includes/jquery/jquery-latest.js"></script>
        <!--script type="text/javascript" src="${contextPath}/scripts/jquery/jquery-latest.min.js"></script-->
        <script type="text/javascript" src="${contextPath}/scripts/mde/includes/jquery-ui/jquery-ui-latest.custom.js"></script>
        <!--script type="text/javascript" src="${contextPath}/scripts/mde/includes/jquery-ui/jquery-ui-latest.custom.min.js"></script-->
        <script type="text/javascript" src="${contextPath}/scripts/mde/includes/jquery.ui.datepicker-nl/jquery.ui.datepicker-nl.js"></script>

        <script type="text/javascript" src="${contextPath}/scripts/jquery.layout/jquery.layout-latest.js"></script>
        <script type="text/javascript" src="${contextPath}/scripts/jquery.form/jquery.form.js"></script>
        <script type="text/javascript" src="${contextPath}/scripts/jquery.scrollTo/jquery.scrollTo.js"></script>
        <!--script type="text/javascript" src="${contextPath}/scripts/jquery.scrollTo/jquery.scrollTo-min.js"></script-->
        <script type="text/javascript" src="${contextPath}/scripts/jquery.filetree/jquery.filetree-latest.js"></script>
        <script type="text/javascript" src="${contextPath}/scripts/jquery.easing/jquery.easing-latest.js"></script>
        <script type="text/javascript" src="${contextPath}/scripts/jquery.ThreeDots/jquery.ThreeDots.js"></script>

        <!-- mde dependencies -->
        <script type="text/javascript" src="${contextPath}/scripts/mde/includes/sarissa/sarissa.js"></script>
        <!--script type="text/javascript" src="${contextPath}/scripts/mde/includes/sarissa/sarissa-compressed.js"></script-->
        <script type="text/javascript" src="${contextPath}/scripts/mde/includes/sarissa/sarissa_ieemu_xpath.js"></script>
        <!--script type="text/javascript" src="${contextPath}/scripts/mde/includes/sarissa/sarissa_ieemu_xpath-compressed.js"></script-->
        <script type="text/javascript" src="${contextPath}/scripts/mde/includes/Math.uuid.js"></script>
        <script type="text/javascript" src="${contextPath}/scripts/mde/includes/wiki2html.js"></script>

        <!-- organisations database. should be filled by customer data. -->
        <script type="text/javascript" src="${contextPath}/scripts/mde/picklists/organisations.js"></script>
        <!-- mde -->
        <script type="text/javascript" src="${contextPath}/scripts/mde/includes/metadataEditor.js"></script>

        <!-- B3p libs: -->
        <script type="text/javascript" src="${contextPath}/scripts/log.js"></script>

        <!-- B3pCatalog main js -->
        <script type="text/javascript" src="${contextPath}/scripts/init.js.jsp"></script>
        <script type="text/javascript" src="${contextPath}/scripts/main.js"></script>



        <stripes:layout-component name="head"/>

        <script type="text/javascript">
            $(document).ready(function() {
                $("body").layout({
                    resizable: false,
                    closable: false,
                    spacing_close: 0,
                    spacing_open: 0,
                    west__size: 30,
                    east__size: 30
                });
                theLayout = $("#center-wrapper").layout({
                    // algemeen:
                    resizable: false,
                    closable: false,
                    spacing_close: 0,
                    spacing_open: 0,
                    // per pane:
                    //north__size: 200,
                    south__size: 75,
                    west__size: $("body").width() / 3,
                    west__resizable: true,
                    west__spacing_open: 8
                });
            });
        </script>

    </head>
    <body>
        <div class="ui-layout-west" id="border-left">
            <stripes:layout-component name="borderLeft">
                <jsp:include page="/WEB-INF/jsp/commons/borderLeft.jsp"/>
            </stripes:layout-component>
        </div>

        <div class="ui-layout-east" id="border-right">
            <stripes:layout-component name="borderRight">
                <jsp:include page="/WEB-INF/jsp/commons/borderRight.jsp"/>
            </stripes:layout-component>
        </div>

        <div class="ui-layout-center" id="center-wrapper">
            <div class="ui-layout-north" id="north">
                <stripes:layout-component name="header">
                    <jsp:include page="/WEB-INF/jsp/commons/header.jsp"/>
                </stripes:layout-component>
            </div>

            <div class="ui-layout-south" id="south">
                <stripes:layout-component name="footer">
                    <jsp:include page="/WEB-INF/jsp/commons/footer.jsp"/>
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
        </div>


    </body>
</html>

</stripes:layout-definition>