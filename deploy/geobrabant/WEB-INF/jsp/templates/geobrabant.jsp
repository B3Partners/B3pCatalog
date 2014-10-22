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
        <link href="${contextPath}/styles/geobrabant/geobrabant.css" media="all" rel="stylesheet" type="text/css" />
    </head>
    <body>
        <header>
            <img src="${contextPath}/images/geobrabant/logo.png" alt="GeoBrabant" />
            <nav>
                <div class="form">
                    <stripes:form beanclass="nl.b3p.catalog.stripes.GeoBrabantAction">
                        <input type="submit" name="catalogus" value="Zoek"/>
                        <input type="search" placeholder="Zoeken" name="searchString" value="${actionBean.searchString}" />
                        <input type="hidden" name="searchType" value="AnyText" />
                    </stripes:form>
                    <div class="social-icons">
                        <a href="http://www.linkedin.com" class="text">LinkedIn Log In</a>
                        <a href="https://twitter.com/geobrabant" class="icon-twitter"><span>Twitter</span></a>
                        <a href="http://www.facebook.com" class="icon-facebook"><span>Facebook</span></a>
                    </div>
                </div>
                <ul>
                    <li><a href="<stripes:url beanclass="nl.b3p.catalog.stripes.GeoBrabantAction"/>"${activePage == 'home' ? ' class="active"' : ''}>Home</a></li>
                    <li><a href="<stripes:url beanclass="nl.b3p.catalog.stripes.GeoBrabantAction" event="overgeobrabant"/>"${activePage == 'over-geobrabant' ? ' class="active"' : ''}>Over GeoBrabant</a></li>
                    <li><a href="<stripes:url beanclass="nl.b3p.catalog.stripes.GeoBrabantAction" event="diensten"/>"${activePage == 'diensten' ? ' class="active"' : ''}>Diensten</a></li>
                    <li><a href="<stripes:url beanclass="nl.b3p.catalog.stripes.GeoBrabantAction" event="contact"/>"${activePage == 'contact' ? ' class="active"' : ''}>Contact</a></li>
                </ul>
            </nav>
        </header>
        <section class="${activePage}">
            <stripes:layout-component name="content"/>
        </section>
        <footer class="${activePage}_footer">
            Innovatieve dienstverlening door samenwerking van overheid, bedrijfsleven en onderwijs
        </footer>
        <stripes:layout-component name="footerscripts" />
    </body>
</html>
</stripes:layout-definition>