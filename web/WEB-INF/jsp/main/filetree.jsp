<%--
    Document   : folderTree
    Created on : 23-dec-2010, 15:59:16
    Author     : Erik van de Pol
--%>

<%@include file="/WEB-INF/jsp/commons/taglibs.jsp" %>
<%@include file="/WEB-INF/jsp/commons/urls.jsp" %>

<%@page contentType="text/html" pageEncoding="UTF-8"%>


<script type="text/javascript">
    $(document).ready(function() {
        selectedFilePath = null;
        selectedFileFound = false;
        <c:if test="${not empty actionBean.selectedFilePath}">
            selectedFilePath = "<c:out value="${actionBean.selectedFilePath}"/>";
        </c:if>
        log("selectedFilePath: " + selectedFilePath);

        var activeClass = "ui-state-active";

        $("#filetree").fileTree({
            script: "${filetreeUrl}",
            scriptEvent: "listDir",
            root: "",
            //spinnerImage: "${contextPath}/scripts/jquery.filetree/images/spinner.png",
            expandEasing: "easeOutBounce",
            collapseEasing: "easeOutBounce",
            dragAndDrop: false,
            /*extraAjaxOptions: {
                global: false
            },*/
            activeClass: activeClass,
            activateDirsOnClick: false,
            expandOnFirstCallTo: selectedFilePath,
            fileCallback: function(filename) {
                log(filename + " clicked!");
                $.get("${metadataUrl}", {"load" : "", "filename" : filename}, function(data) {
                    $("#center").html(data);
                });
            },
            readyCallback: function(root) {
                if (selectedFilePath != null && !selectedFileFound) {
                    //log(root);
                    var selectedFile = root.find("input:radio[value='" + selectedFilePath + "']");
                    log(selectedFile);
                    if (selectedFile.length > 0) {
                        selectedFileFound = true;
                        selectedFile.attr("checked", true);
                        selectedFile.siblings("a").addClass(activeClass);
                        $("#filetree").parent().scrollTo(
                            selectedFile,
                            defaultScrollToDuration,
                            defaultScrollToOptions
                        );
                    }
                }
                root.css("height", "100%");
            }
        });
    });
</script>

<div id="filetree" class="ui-layout-content"></div>