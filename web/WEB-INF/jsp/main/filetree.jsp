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
            log("selectedFilePath: " + selectedFilePath);

            var activeClass = "ui-state-active";

            $("#filetree").fileTree({
                script: "${filetreeUrl}",
                scriptEvent: "listDir",
                root: "",
                //spinnerImage: "${contextPath}/scripts/jquery.filetree/images/spinner.png",
                expandEasing: "linear",
                collapseEasing: "easeOutBounce",
                dragAndDrop: false,
                /*extraAjaxOptions: {
                    global: false
                },*/
                activeClass: activeClass,
                activateDirsOnClick: false,
                expandOnFirstCallTo: selectedFilePath,
                fileCallback: function(filename) {
                    $.ajax({
                        url: "${metadataUrl}",
                        type: "POST",
                        data: {"load" : "", "filename" : filename},
                        success: function(data) {
                            log("data: " + data);
                            $("#mde").mde({
                                xml: data,
                                baseFullPath: "${contextPath}/scripts/mde/",
                                profile: "nl_md_1.2_with_fc",
                                changed: function(changed) {
                                    $("#saveMD").button("option", "disabled", !changed);
                                }
                            });
                            $("#mde-toolbar").html($("<div/>", {
                                id: "saveMD",
                                text: "Opslaan",
                                click: function(event) {
                                    $(this).removeClass("ui-state-hover");
                                    var xml = $("#mde").mde("save", {
                                        profile: "nl_md_1.2_with_fc"
                                    });
                                    $.ajax({
                                        url: "${metadataUrl}",
                                        type: "POST",
                                        data: {save: "", filename: filename, metadata: xml},
                                        success: function(data, textStatus, xhr) {
                                            if (data !== "success") {
                                                log("metadata save error: " + data);
                                                openErrorDialog(data);
                                            } else {
                                                log("metadata saved succesfully.");
                                                $("#saveMD").button("option", "disabled", true);
                                            }
                                        },
                                        error: function(xhr, textStatus, errorThrown) {
                                            openErrorDialog(errorThrown);
                                        }
                                    });
                                }
                            }).button({disabled: true}));
                        }
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
                }
            });
        });

        function openErrorDialog(message) {
            log("error: " + message);
            $("<div/>").text(message).appendTo(document.body).dialog({
                title: "Error",
                modal: true,
                buttons: [{
                    text: "Ok",
                    click: function(event) {
                        $(this).close();
                    }
                }],
                close: function(event) {
                    $(this).dialog("destroy").remove();
                }
            });
        }
    </script>
</div>

<div id="filetree" class="ui-layout-content"></div>