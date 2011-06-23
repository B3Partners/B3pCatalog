<%-- 
    Document   : footer
    Created on : 16-sep-2010, 17:32:32
    Author     : Erik van de Pol
--%>

<%@include file="/WEB-INF/jsp/commons/taglibs.jsp" %>
<%@include file="/WEB-INF/jsp/commons/customization.jsp" %>

<div class="ui-layout-content footer">
    <div id="footer-text-left" class="footer-text footer-text-vertical-center">
        This program is distributed under the terms of the <a class="gpl_link" href="http://www.gnu.org/licenses/gpl.html">GNU General Public License</a>
    </div>
    <div id="footer-text-right" class="footer-text footer-text-vertical-center">
        ${title}
    </div>
    <div class="footer-logo">
        <%@include file="/WEB-INF/jsp/commons/footerLogo.jsp" %>
    </div>
</div>
