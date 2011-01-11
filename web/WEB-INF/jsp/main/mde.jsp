<%-- 
    Document   : mde
    Created on : 23-dec-2010, 15:59:38
    Author     : Erik van de Pol
--%>
<%@include file="/WEB-INF/jsp/commons/taglibs.jsp" %>

<%@page contentType="text/html" pageEncoding="UTF-8"%>

<div class="ui-layout-ignore">
    <link rel="stylesheet" type="text/css" href="${contextPath}/scripts/mde/styles/jquery-ui-1.8.5.custom.css" />
    <link rel="stylesheet" type="text/css" href="${contextPath}/scripts/mde/styles/metadataEdit.css" />
    <!--[if IE]> <link rel="stylesheet" type="text/css" href="${contextPath}/scripts/mde/styles/metadataEdit-ie.css" /> <![endif]-->
    <!--[if lte IE 7]> <link rel="stylesheet" type="text/css" href="${contextPath}/scripts/mde/styles/metadataEdit-ie7.css" /> <![endif]-->
    
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
    <script type="text/javascript">
        $(document).ready(function() {
            //$.mde.logMode = true;

            /*$("#mde").mde({
                xmlString: Sarissa.unescape($("#metadata").text()),
                baseFullPath: "${contextPath}/scripts/mde/",
                profile: "nl_md_1.2_with_fc",
                changed: function(changed) {
                }
            });*/
        });
    </script>
</div>

<%--div id="metadata" class="ui-layout-ignore" style="display: none">
    <c:out value="${actionBean.metadata}" escapeXml="true"/>
</div--%>

<div id="mde" class="ui-layout-content"></div>
