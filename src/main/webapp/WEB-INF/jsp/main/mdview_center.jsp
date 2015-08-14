<%-- 
    Document   : mde
    Created on : 25-7-2014
    Author     : Chris van Lith
--%>
<%@include file="/WEB-INF/jsp/commons/taglibs.jsp" %>
<%@include file="/WEB-INF/jsp/commons/urls.jsp" %>
<%@include file="/WEB-INF/jsp/commons/customization.jsp" %>

<%@page contentType="text/html" pageEncoding="UTF-8"%>

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

        <script type="text/javascript" charset="utf-8" src="${orgsUrl}"></script>
        <script type="text/javascript" src="${contextPath}/scripts/mde/picklists/gemet-inspire-nl.js"></script>
        
        <!-- mde -->
        <script type="text/javascript" charset="utf-8" src="${contextPath}/scripts/mde/includes/mde.js"></script>
        <script type="text/javascript" charset="utf-8" src="${contextPath}/scripts/mde/includes/commonOptions.js"></script>

        <!-- B3pCatalog main js -->
        <script type="text/javascript" charset="utf-8" src="${contextPath}/scripts/init.js.jsp"></script>
        <script type="text/javascript" charset="utf-8" src="${contextPath}/scripts/mdeOptions.js"></script>
        <script type="text/javascript" charset="utf-8" src="${contextPath}/scripts/main.js"></script>

        <!-- connect local folder -->
        <script type="text/javascript" src="${contextPath}/applet/deployJavaSucks.js"></script>
        <script type="text/javascript" charset="utf-8" src="${contextPath}/scripts/local.js"></script>

        <script type="text/javascript">
            $(document).ready(function() {
<%--                
                http://localhost:8080/b3pcatalog/Metadata.action?view=t&path=0/B_GS_KOUD.txt&mode=file&strictISO19115=false
                B3pCatalog.loadMetadata = function("file", "0/B_GS_KOUD.txt", title, isGeo, cancel)
--%>
                B3pCatalog.loadMetadata4View("${actionBean.mode}", "${actionBean.path}", "View metadata", true, null);
            });
            
         </script>

    </head>
    <body>

        <div class="ui-layout-center" id="center">
            <div id="ui-mde-tabs-container">

            </div>
            <div id="center-wrapper" class="ui-layout-content">

            </div>
        </div>
    </body>
