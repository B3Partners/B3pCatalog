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
                    log("file clicked: " + filename);
                    var anchor = $('a[rel="' + RegExp.escape(filename) + '"]', "#filetree");
                    if (anchor.length > 0 && anchor.hasClass(activeClass))
                        return;
                    
                    if ($("#mde").mde("initialized") && $("#mde").mde("changed")) {
                        $("<div/>").text("Wilt u uw wijzigingen opslaan?").appendTo(document.body).dialog({
                            title: "Vraag",
                            modal: true,
                            buttons: [{
                                text: "Ja",
                                click: function(event) {
                                    B3pCatalog.saveMetadata();
                                    B3pCatalog.openFile(filename);
                                    $(this).dialog("destroy").remove();
                                }
                            }, {
                                text: "Nee",
                                click: function(event) {
                                    B3pCatalog.openFile(filename);
                                    $(this).dialog("destroy").remove();
                                }
                            }, {
                                text: "Annuleren",
                                click: function(event) {
                                    $(this).dialog("close");
                                }
                            }],
                            close: function(event) {
                                $("a[rel='" + RegExp.escape(filename) + "']", "#filetree").removeClass(activeClass);
                                $("a[rel='" + RegExp.escape(B3pCatalog.currentFilename) + "']", "#filetree").addClass(activeClass);
                                $(this).dialog("destroy").remove();
                            }
                        });//.find("a.ui-dialog-titlebar-close").remove();
                    } else {
                        B3pCatalog.openFile(filename);
                    }
                },
                dirExpandCallback: function(dir) {
                    log("dir clicked: " + dir);
                    var anchor = $('a[rel="' + RegExp.escape(dir) + '"]', "#filetree");
                    //anchor.blur();
                    if (anchor.position() && anchor.position().top > 5) {
                        $("#filetree").scrollTo(anchor, {
                            axis: "y",
                            duration: 1000,
                            easing: "easeOutBounce"
                        });
                    }
                    //anchor.focus();
                },
                readyCallback: function(root) {
                    if (selectedFilePath != null && !selectedFileFound) {
                        //log(root);
                        var selectedFile = root.find("input:radio[value='" + RegExp.escape(selectedFilePath) + "']");
                        log(selectedFile);
                        if (selectedFile.length > 0) {
                            selectedFileFound = true;
                            selectedFile.attr("checked", true);
                            selectedFile.siblings("a").addClass(activeClass);
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

<div id="filetree" class="ui-layout-content"></div>