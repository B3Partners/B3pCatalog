
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@include file="/WEB-INF/jsp/commons/taglibs.jsp"%>

<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Autorisatie info</title>
    </head>
    <body>
        <h2>Autorisatie info</h2>

        <table>
            <tr><td>Remote user:</td><td><c:out value="${pageContext.request.remoteUser}"/></td></tr>
            <tr><td>Principal:</td><td><c:out value="${pageContext.request.userPrincipal}"/> (class <c:catch var="e"><%= request.getUserPrincipal().getClass().getName() %></c:catch>)</td></tr>
            <tr><td>Realm:</td><td> <c:catch var="e"><c:out value="${pageContext.request.userPrincipal.realm.info}"/></c:catch></td></tr>
        </table>
        <p>
        Lijst met roles:
        <ol>
            <c:catch var="e">
                    <%
                    if(request.getUserPrincipal() != null) {
                        String[] roles = ((org.apache.catalina.realm.GenericPrincipal)request.getUserPrincipal()).getRoles();
                        for(String s: roles) {
                            pageContext.setAttribute("role", s);
                            %><li><c:out value="${role}"/></li><%
                        }
                    }
                    %>
            </c:catch>
        </ol>
        <p>
        Test HttpServletRequest.isUserInRole():
        <p>
        <c:if test="${!empty param.role}">
            Rol <b><c:out value="${param.role}"/>: <b><%= request.isUserInRole(request.getParameter("role")) %></b>
            <p>
        </c:if>
        <form action="${pageContext.request.pathInfo}" method="get">
            <input name="role"  placeholder="Voer rolnaam in"  type="text">
            <input type="submit"value="Check">
        </form>

        <script type="text/javascript">
            window.onload = function() {
                document.forms[0].role.focus();
            }
        </script>
    </body>
</html>
