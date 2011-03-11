if (typeof B3pCatalog == "undefined") B3pCatalog = {};

$(document).ajaxError(function(event, xhr, ajaxOptions, thrownError) {
    B3pCatalog.openErrorDialog(xhr.responseText);
    return false;
});

B3pCatalog.openErrorDialog = function(message) {
    log("error: " + message);
    $(".spinner").remove();
    $("<div/>").html(message).appendTo(document.body).dialog({
        title: "Fout",
        modal: true,
        width: calculateDialogWidth(66),
        height: calculateDialogHeight(80),
        buttons: [{
            text: "Ok",
            click: function(event) {
                $(this).dialog("close");
            }
        }],
        close: function(event) {
            $(this).dialog("destroy").remove();
        }
    });
}

B3pCatalog.openSimpleErrorDialog = function(message) {
    log("error: " + message);
    $(".spinner").remove();
    $("<div/>").html(message).appendTo(document.body).dialog({
        title: "Fout",
        modal: true,
        buttons: [{
            text: "Ok",
            click: function(event) {
                $(this).dialog("close");
            }
        }],
        close: function(event) {
            $(this).dialog("destroy").remove();
        }
    });
}

B3pCatalog.currentFilename = "";

B3pCatalog.loadMetadataFromFile = function(filename, esriType, isGeo) {
    $("#mde-toolbar").empty();
    $("#mde").html($("<img />", {
        src: B3pCatalog.contextPath + "/styles/images/spinner.gif",
        "class": "spinner"
    }));
    $.ajax({
        url: B3pCatalog.metadataUrl,
        type: "POST",
        data: {
            load : "",
            filename : filename,
            esriType : esriType
        },
        dataType: "text", // jquery returns the limited (non-activeX) xml document version in IE when using the default or 'xml'
        success: function(data, textStatus, jqXHR) {
            //log(data);
            B3pCatalog.currentFilename = filename;
            document.title = "B3pCatalog | " + filename;
            var viewMode = jqXHR.getResponseHeader("MDE_viewMode") === "true";
            B3pCatalog.createMde(data, isGeo, viewMode);
        }
    });
}

B3pCatalog.loadMetadataByUUID = function(uuid) {
    $("#mde-toolbar").empty();
    $("#mde").html($("<img />", {
        src: B3pCatalog.contextPath + "/styles/images/spinner.gif",
        "class": "spinner"
    }));
    $.ajax({
        url: B3pCatalog.catalogUrl,
        data: {load: "", uuid: uuid},
        type: "POST",
        dataType: "text",
        success: function(data, textStatus, jqXHR) {
            B3pCatalog.saveDataUserConfirm({
                done: function() {
                    B3pCatalog.createViewMde(data);
                }
            });
        }
    });
}

B3pCatalog.saveMetadata = function(settings) {
    var options = $.extend({
        filename: B3pCatalog.currentFilename,
        updateUI: true,
        async: true
    }, settings);

    if (!options.filename)
        return;

    var xml = $("#mde").mde("save", {
        profile: "nl_md_1.2_with_fc"
    });
    $.ajax({
        url: B3pCatalog.metadataUrl,
        async: options.async,
        type: "POST",
        data: {
            save: "",
            filename: options.filename,
            metadata: xml,
            esriType: B3pCatalog.getCurrentEsriType()
        },
        success: function(data, textStatus, xhr) {
            log("metadata saved succesfully.");
            if (options.updateUI)
                $("#saveMD").button("option", "disabled", true);
        }
    });
}

B3pCatalog.getCurrentEsriType = function() {
    return $("#filetree .jqueryFileTree a.selected").attr("esritype");
}

B3pCatalog.saveDataUserConfirm = function(opts) {
    var options = $.extend({
        done: $.noop,
        cancel: $.noop,
        text: "Wilt u uw wijzigingen opslaan?",
        asyncSave: true
    }, opts);
    if ($("#mde").mde("initialized") && $("#mde").mde("changed")) {
        $("<div/>").text(options.text).appendTo(document.body).dialog({
            title: "Vraag",
            modal: true,
            buttons: [{
                text: "Ja",
                click: function(event) {
                    B3pCatalog.saveMetadata({async: options.asyncSave});
                    options.done();
                    $(this).dialog("destroy").remove();
                }
            }, {
                text: "Nee",
                click: function(event) {
                    options.done();
                    $(this).dialog("destroy").remove();
                }
            }, {
                text: "Annuleren",
                click: function(event) {
                    $(this).dialog("close");
                }
            }],
            close: function(event) {
                options.cancel();
                $(this).dialog("destroy").remove();
            }
        });
    } else {
        options.done();
    }
};

B3pCatalog.basicMdeOptions = {
    baseFullPath: B3pCatalog.contextPath + "/scripts/mde/",
    profile: "nl_md_1.2_with_fc",
    richTextMode: true,
    dcMode: true,
    dcPblMode: true,
    iso19115oneTab: true
}

B3pCatalog.createMde = function(xmlDoc, isGeo, viewMode) {
    log("isGeo: " + isGeo);
    //log("data: " + data);
    B3pCatalog.destroyMdeWrapper();
    $.mde.logMode = true;

    var extraOptions = {};
    if (typeof isGeo === "boolean" && !isGeo) {
        $.extend(extraOptions, {
            geoTabsMinimizable: true,
            geoTabsStartMinimized: true
        });
    }
    if (typeof viewMode === "boolean") {
        $.extend(extraOptions, {
            viewMode: viewMode
        });
    }
    $("#mde").mde($.extend({}, B3pCatalog.basicMdeOptions, {
        xml: xmlDoc,
        commentMode: true,
        commentPosted: function(comment) {
            if (!comment) {
                B3pCatalog.openSimpleErrorDialog("Commentaar kan niet leeg zijn.");
                return false;
            } else {
                var xhr = $.ajax({
                    url: B3pCatalog.contextPath + "/Metadata.action",
                    data: {
                        postComment: "",
                        comment: comment,
                        filename: B3pCatalog.currentFilename,
                        esriType: B3pCatalog.getCurrentEsriType()
                    },
                    dataType: "text",
                    method: "POST",
                    async: false
                });
                return xhr.responseText;
            }
        },
        changed: function(changed) {
            $("#saveMD").button("option", "disabled", !changed);
        }
    }, extraOptions));

    var mdeToolbar = $("#mde-toolbar");
    if (viewMode === false) {
        mdeToolbar.append($("<a />", {
            href: "#",
            id: "saveMD",
            text: "Opslaan",
            title: "Metadatadocument opslaan",
            click: function(event) {
                $(this).removeClass("ui-state-hover");
                B3pCatalog.saveMetadata();
            }
        }).button({disabled: true}));
        mdeToolbar.append($("<a />", {
            href: "#",
            id: "resetMD",
            text: "Legen",
            title: "Metadatadocument volledig leeg maken. Wordt nog niet opgeslagen.",
            click: function(event) {
                // TODO: confirmation box: Weet u zeker dat u alle metadata en commentaren wilt wissen voor dit document? Dit wordt pas definitief als u op "Opslaan" klikt.
                $(this).removeClass("ui-state-hover");
                $("#mde").mde("reset");
            }
        }).button({disabled: false}));
        mdeToolbar.append($("<a />", {
            href: "#",
            id: "importMD",
            text: "Importeren",
            title: "Metadatadocument importeren en over huidige metadatadocument heen kopiëren. Wordt nog niet opgeslagen.",
            click: function(event) {
                $(this).removeClass("ui-state-hover");
                // TODO: import
            }
        }).button({disabled: false}));
    }
    mdeToolbar.append($("<a />", {
        href: "#",
        id: "exportMD",
        text: "Exporteren",
        title: "Metadatadocument exporteren.",
        click: function(event) {
            $(this).removeClass("ui-state-hover ui-state-focus");
            if ($("#mde").mde("changed")) {
                B3pCatalog.saveDataUserConfirm({
                    done: B3pCatalog.exportMd,
                    text: "Wilt u uw wijzigingen opslaan alvorens de metadata te exporteren?",
                    asyncSave: false // data needs to be saved already when we do our export request
                });
            } else {
                B3pCatalog.exportMd();
            }
        }
    }).button({disabled: false}));
}

B3pCatalog.exportMd = function() {
    window.location = B3pCatalog.metadataUrl + "?" + $.param({
        "export": "",
        filename: B3pCatalog.currentFilename,
        esriType: B3pCatalog.getCurrentEsriType()
    });
}

B3pCatalog.createViewMde = function(xmlDoc) {
    //log("data: " + data);
    B3pCatalog.destroyMdeWrapper();
    $.mde.logMode = true;
    $("#mde").mde($.extend({}, B3pCatalog.basicMdeOptions, {
        xml: xmlDoc,
        viewMode: true
    }));
}

B3pCatalog.destroyMdeWrapper = function() {
    $("#mde").mde("destroy");
    $("#mde-toolbar").empty();
}

function calculateDialogWidth(percentageOfBodyWidth, minWidth, maxWidth) {
    return _calculateDialogSize(percentageOfBodyWidth, minWidth, maxWidth, $("body").width());
}

function calculateDialogHeight(percentageOfBodyHeight, minHeight, maxHeight) {
    return _calculateDialogSize(percentageOfBodyHeight, minHeight, maxHeight, $("body").height());
}

function _calculateDialogSize(percentage, minSize, maxSize, bodySize) {
    var size = Math.floor(bodySize * percentage / 100.0);
    if (!!minSize) {
        if (size < minSize) {
            if (minSize < bodySize) {
                size = minSize;
            } else {
                size = bodySize;
            }
        }
    }
    if (!!maxSize) {
        if (size > maxSize)
            size = maxSize;
    }
    return size;
}

