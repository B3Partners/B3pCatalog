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
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
        <meta http-equiv="Expires" content="-1" />
        <meta http-equiv="Cache-Control" content="max-age=0, no-store" />

        <title>${pageTitle}</title>

        <link rel="stylesheet" type="text/css" href="${contextPath}/scripts/mde/styles/jquery-ui-1.8.5.custom.css" />
        <link rel="stylesheet" type="text/css" href="${contextPath}/scripts/jquery.filetree/jquery.filetree.css" />
        <link rel="stylesheet" type="text/css" href="${contextPath}/styles/main.css" />

        <script type="text/javascript" src="${contextPath}/scripts/mde/includes/jquery/jquery-latest.js"></script>
        <!--script type="text/javascript" src="${contextPath}/scripts/jquery/jquery-latest.min.js"></script-->
        <script type="text/javascript" src="${contextPath}/scripts/mde/includes/jquery-ui/jquery-ui-1.8.5.custom.js"></script>
        <!--script type="text/javascript" src="${contextPath}/scripts/jquery-ui/jquery-ui-1.8.5.custom.min.js"></script-->
        <script type="text/javascript" src="${contextPath}/scripts/mde/includes/jquery.ui.datepicker-nl/jquery.ui.datepicker-nl.js"></script>

        <script type="text/javascript" src="${contextPath}/scripts/jquery.layout/jquery.layout-latest.js"></script>
        <script type="text/javascript" src="${contextPath}/scripts/jquery.scrollTo/jquery.scrollTo.js"></script>
        <!--script type="text/javascript" src="${contextPath}/scripts/jquery.scrollTo/jquery.scrollTo-min.js"></script-->
        <script type="text/javascript" src="${contextPath}/scripts/jquery.filetree/jquery.filetree-latest.js"></script>
        <script type="text/javascript" src="${contextPath}/scripts/jquery.easing/jquery.easing-latest.js"></script>

        <!-- B3p libs: -->
        <script type="text/javascript" src="${contextPath}/scripts/log.js"></script>

        <stripes:layout-component name="head"/>

        <script type="text/javascript">
            $(document).ready(function() {
                $("body").layout({
                    resizable: true,
                    closable: false,
                    west__size: 50,
                    east__size: 50,
                    north__size: 50,
                    south__size: 50/*,
                    spacing_open: 0,
                    spacing_close: 0*/
                });
            });
        </script>

    </head>
    <body>
        <div class="ui-layout-north">
            <stripes:layout-component name="header">
                <jsp:include page="/WEB-INF/jsp/commons/header.jsp"/>
            </stripes:layout-component>
        </div>

        <div class="ui-layout-west">
            <stripes:layout-component name="west">
                <jsp:include page="/WEB-INF/jsp/commons/west.jsp"/>
            </stripes:layout-component>
        </div>

        <div class="ui-layout-east">
            <stripes:layout-component name="east">
                <jsp:include page="/WEB-INF/jsp/commons/east.jsp"/>
            </stripes:layout-component>
        </div>

        <div class="ui-layout-south">
            <stripes:layout-component name="footer">
                <jsp:include page="/WEB-INF/jsp/commons/footer.jsp"/>
            </stripes:layout-component>
        </div>

        <div id="centerWrapper" class="ui-layout-center" style="height: 100%">
            <stripes:layout-component name="content"/>
        </div>

    </body>
</html>

</stripes:layout-definition>