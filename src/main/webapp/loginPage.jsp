<%@include file="/WEB-INF/jsp/commons/taglibs.jsp" %>
<%@include file="/WEB-INF/jsp/commons/customization.jsp" %>

<%@page contentType="text/html" pageEncoding="UTF-8"%>

<stripes:layout-definition>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01//EN" "http://www.w3.org/TR/html4/strict.dtd">
<html>
    <head>
        <meta http-equiv="content-type" content="text/html; charset=utf-8" />
        <title>${pageTitle}</title>

        <link rel="stylesheet" href="${contextPath}/scripts/mde/styles/jquery-ui-latest.custom.css" type="text/css" media="screen" />
        <link rel="stylesheet" href="${contextPath}/styles/main.css" type="text/css" media="screen" />
        <link rel="stylesheet" href="${contextPath}/styles/icons.css" type="text/css" media="screen" />
        <link rel="stylesheet" href="${contextPath}/styles/deploy.css" type="text/css" media="screen" />

        <link rel="shortcut icon" href="${contextPath}/images/favicon.ico" type="image/x-icon" />

        <script type="text/javascript" charset="utf-8" src="${contextPath}/scripts/mde/includes/jquery/jquery-latest.js"></script>
        <!--script type="text/javascript" charset="utf-8" src="${contextPath}/scripts/mde/includes/jquery/jquery-latest.min.js"></script-->
        <script type="text/javascript" charset="utf-8" src="${contextPath}/scripts/mde/includes/jquery-ui/jquery-ui-latest.custom.js"></script>
        <!--script type="text/javascript" charset="utf-8" src="${contextPath}/scripts/mde/includes/jquery-ui/jquery-ui-latest.custom.min.js"></script-->
        <script type="text/javascript" charset="utf-8" src="${contextPath}/scripts/jquery.layout/jquery.layout-latest.js"></script>
        <script type="text/javascript" charset="utf-8" src="${contextPath}/scripts/jquery.cookie/jquery.cookie.js"></script>
        <script type="text/javascript">
            $(document).ready(function() {
                theLayout = $("body").layout({
                    north__size: 60,
                    west__size: 100,
                    east__size: 100,
                    /*south__size: 60,*/
                    resizable: false,
                    closable: false,
                    spacing_close: 0,
                    spacing_open: 0,
                    enableCursorHotkey: false
                });
                
                // $(".submit").button();
            });
        </script>

    </head>
    <body>
        <div class="ui-layout-north title-bar" id="north">
            <%@include file="/WEB-INF/jsp/commons/branding.jsp" %>
            <%@include file="/WEB-INF/jsp/commons/titlebar.jsp" %>
        </div>
        <div class="ui-layout-west left-background" id="west">

        </div>
        <div class="ui-layout-center" id="center">
            <div class="form-wrap">
            <stripes:layout-component name="messages"/>
            <stripes:layout-component name="content"/>
            </div>
        </div>
        <div class="ui-layout-east right-background" id="east">

        </div>
        <div class="ui-layout-south" id="south">
            <%@include file="/WEB-INF/jsp/commons/footer.jsp" %>
        </div>
    </body>
</html>

</stripes:layout-definition>