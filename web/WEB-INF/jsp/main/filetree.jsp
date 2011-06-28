<%--
    Document   : folderTree
    Created on : 23-dec-2010, 15:59:16
    Author     : Erik van de Pol
--%>

<%@include file="/WEB-INF/jsp/commons/taglibs.jsp" %>
<%@include file="/WEB-INF/jsp/commons/urls.jsp" %>

<%@page contentType="text/html" pageEncoding="UTF-8"%>


<div class="ui-layout-ignore">
    <script type="text/javascript">
        $(document).ready(function() {
            var selectedFilePath = null;
            <c:if test="${not empty actionBean.selectedFilePath}">
                selectedFilePath = "<c:out value="${actionBean.selectedFilePath}"/>";
            </c:if>
            //log("selectedFilePath: " + selectedFilePath);
            
            B3pCatalog.loadFiletree(selectedFilePath);
        });
    </script>
</div>

<div id="filetree" class="tab-definition"></div>