<%-- 
    Document   : searchResults
    Created on : 2-feb-2011, 14:54:37
    Author     : Erik van de Pol
--%>

<%@include file="/WEB-INF/jsp/commons/taglibs.jsp" %>

<%@page contentType="text/html" pageEncoding="UTF-8"%>

<script type="text/javascript">
    $(document).ready(function() {
        $(".searchResult").click(function() {
            $.ajax({
                url: B3pCatalog.catalogUrl,
                data: {load: "", uuid: $(this).attr("uuid")},
                type: "POST",
                success: function(data, textStatus, jqXHR) {
                    if ($.isXMLDoc(data)) {
                        B3pCatalog.saveDataUserConfirm({
                            done: function() {
                                B3pCatalog.createViewMde(data);
                            }
                        });
                    } else {
                        B3pCatalog.openErrorDialog(data);
                    }
                },
                error: function(xhr, textStatus, errorThrown) {
                    B3pCatalog.openErrorDialog(textStatus + ": " + errorThrown);
                }
            });
        });
    });
</script>

<div>
    <c:choose>
        <c:when test="${empty actionBean.metadataList}">
            <div class="mod message_info">
                Geen resultaten gevonden
            </div>
        </c:when>
        <c:otherwise>
            <c:forEach items="${actionBean.metadataList}" var="mdDoc">
                <div class="searchResult" uuid="<c:out value="${mdDoc.uuid}"/>" title="<c:out value="${mdDoc.abstractString}"/>">
                    <c:out value="${mdDoc.title}"/>
                </div>
            </c:forEach>
        </c:otherwise>
    </c:choose>
</div>
