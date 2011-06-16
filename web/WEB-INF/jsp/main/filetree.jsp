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
            selectedFilePath = null;
            selectedFileFound = false;
            <c:if test="${not empty actionBean.selectedFilePath}">
                selectedFilePath = "<c:out value="${actionBean.selectedFilePath}"/>";
            </c:if>
            //log("selectedFilePath: " + selectedFilePath);

            $("#filetree").fileTree({
                script: "${filetreeUrl}",
                scriptEvent: "listDir",
                root: "",
                spinnerImage: "${contextPath}/styles/images/spinner.gif",
                expandEasing: "linear",
                collapseEasing: "easeOutBounce",
                dragAndDrop: false,
                /*extraAjaxOptions: {
                    global: false
                },*/
                activeClass: "selected",
                activateDirsOnClick: false,
                expandOnFirstCallTo: selectedFilePath,
                fileCallback: function(filename, aElement) {
                    //log("file clicked: " + filename);
                    var anchor = B3pCatalog.clickedFileAnchor = $(aElement);
                    if (anchor.length > 0 && anchor.hasClass("selected"))
                        return;

                    var newState = {filename: filename}

                    var esriType = parseInt(anchor.attr("esritype"));
                    if (!isNaN(esriType) && esriType !== 0) {
                        newState.type = anchor.attr("esritype");
                    }
                    var isGeo = anchor.attr("isgeo");
                    if (isGeo !== "true") {
                        newState.isgeo = isGeo;
                    }

                    $.bbq.pushState(newState, 2);
                },
                dirExpandCallback: function(dir) {},
                readyCallback: function(root) {
                    //log("root");
                    //log(root);
                    $("#sidebar").scrollTo(root, {
                        axis: "y",
                        duration: 1000,
                        easing: "easeOutBounce"
                    });
                    if (selectedFilePath != null && !selectedFileFound) {
                        //log(root);
                        var selectedFile = root.find("input:radio[value='" + RegExp.escape(selectedFilePath) + "']");
                        //log(selectedFile);
                        if (selectedFile.length > 0) {
                            selectedFileFound = true;
                            selectedFile.attr("checked", true);
                            selectedFile.siblings("a").addClass("selected");
                            $("#filetree").parent().scrollTo(selectedFile, {
                                duration: 1000,
                                easing: "easeOutBounce"
                            });
                        }
                    }
                }
            });
        });

    </script>
</div>

<div id="filetree" class="tab-definition"></div>