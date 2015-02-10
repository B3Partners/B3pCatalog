<%-- 
    Document   : geobrabant
    Created on : Oct 15, 2014, 11:14:03 AM
    Author     : geertplaisier
--%>

<%@include file="/WEB-INF/jsp/commons/taglibs.jsp" %>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<stripes:layout-definition>
<!DOCTYPE html>
<html>
    <head>
        <meta charset="utf-8">
        <meta http-equiv="X-UA-Compatible" content="IE=edge">
        <title>${pageTitle}</title>
        <meta name="description" content="">
        <meta name="viewport" content="width=device-width, initial-scale=1">
        <link href='http://fonts.googleapis.com/css?family=Open+Sans:400,300,300italic,400italic' rel='stylesheet' type='text/css'>
        <link href="${contextPath}/styles/geobrabant/geobrabant.css" media="all" rel="stylesheet" type="text/css" />
    </head>
    <body>
        <stripes:layout-component name="header"/>
        <section class="${activePage}">
            <stripes:layout-component name="content"/>
        </section>
        <stripes:layout-component name="footerscripts" />
    </body>
</html>
</stripes:layout-definition>