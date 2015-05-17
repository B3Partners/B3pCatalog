<%-- 
    Document   : admin
    Created on : 9-aug-2011, 14:26:13
    Author     : Erik van de Pol
--%>

<%@include file="/WEB-INF/jsp/commons/taglibs.jsp" %>

<%@page contentType="text/html" pageEncoding="UTF-8"%>

<div id="admin" class="tab-definition">
    <script type="text/javascript">
        $(document).ready(function() {
            $("#organisationsLink").click(function() {
                $.bbq.pushState({page: "organisations"}, 2);
                return false;
            });
        });
    </script>
    
    <a href="#" id="organisationsLink">Organisaties en contactpersonen</a>
    
    <p>
    Gebruik de volgende link om direct metadata in te zien, bv in configuratie van gisviewer
    <ul>
        <li>${contextPath}/Metadata.action?view=t&path=path_to_file&mode=file</li>
    </ul>


</div>
