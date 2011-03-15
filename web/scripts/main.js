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

B3pCatalog.modes = {
    NO_MODE: 0,
    FILE_MODE: 1,
    CSW_MODE: 2
}

B3pCatalog.currentMode = B3pCatalog.modes.NO_MODE;

B3pCatalog.currentFilename = "";

B3pCatalog.loadMetadataFromFile = function(filename, esriType, isGeo, cancel) {
    this._loadMetadata({
        done: function() {
            
        },
        cancel: cancel,
        ajaxOptions: {
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
                B3pCatalog.currentMode = B3pCatalog.modes.FILE_MODE;
                document.title = B3pCatalog.title + B3pCatalog.titleSeparator + filename;
                var viewMode = jqXHR.getResponseHeader("MDE_viewMode") === "true";
                B3pCatalog.createMde(data, isGeo, viewMode);
            }
        }
    });
}

B3pCatalog.loadMetadataByUUID = function(uuid) {
    this._loadMetadata({
        done: function() {
            B3pCatalog.getCurrentFileAnchor().removeClass("selected").blur();
            B3pCatalog.currentFilename = "";
            // TODO: eigenlijk moet ook oldrel in jquery.filetree nog leeg gemaakt worden, maar dat vereist wat veranderingen in die plugin
        },
        ajaxOptions: {
            url: B3pCatalog.catalogUrl,
            data: {
                load: "",
                uuid: uuid
            },
            type: "POST",
            dataType: "text",
            success: function(data, textStatus, jqXHR) {
                log("load by uuid success");
                B3pCatalog.currentMode = B3pCatalog.modes.CSW_MODE;
                // TODO: title kan geëxtract worden uit het xml
                document.title = B3pCatalog.title;
                B3pCatalog.createViewMde(data);
            }
        }
    });
}

B3pCatalog._loadMetadata = function(opts) {
    var options = $.extend({
        done: $.noop,
        cancel: $.noop,
        ajaxOptions: {}
    }, opts);
    B3pCatalog.saveDataUserConfirm({
        done: function() {
            $("#mde-toolbar").empty();
            $("#mde").html($("<img />", {
                src: B3pCatalog.contextPath + "/styles/images/spinner.gif",
                "class": "spinner"
            }));
            document.title = B3pCatalog.title;
            options.done();
            $.ajax(options.ajaxOptions);
        },
        cancel: options.cancel
    });
}

B3pCatalog.saveMetadata = function(settings) {
    var options = $.extend({
        filename: B3pCatalog.currentFilename,
        updateUI: true,
        async: false
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

B3pCatalog.getCurrentFileAnchor = function() {
    return $("a[rel='" + RegExp.escape(B3pCatalog.currentFilename) + "']", "#filetree");
}

B3pCatalog.saveDataUserConfirm = function(opts) {
    var options = $.extend({
        done: $.noop,
        cancel: $.noop,
        text: "Wilt u uw wijzigingen opslaan?",
        asyncSave: false
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
    //log("isGeo: " + isGeo);
    //log("data: " + data);
    $.mde.logMode = true;
    $("#mde").mde("destroy");

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
    this.createToolbar(viewMode);
}

B3pCatalog.createViewMde = function(xmlDoc) {
    //log("data: " + data);
    $.mde.logMode = true;
    $("#mde").mde("destroy");
    $("#mde").mde($.extend({}, this.basicMdeOptions, {
        xml: xmlDoc,
        viewMode: true
    }));
    this.createToolbar(true);
}

B3pCatalog.exportMetadata = function() {
    switch(this.currentMode) {
        case this.modes.FILE_MODE:  this._exportMetadataFromFile(); break;
        case this.modes.CSW_MODE:   this._exportMetadataByUUID(); break;
        default: openErrorDialog(B3pCatalog.title + " is in an illegal mode: " + this.currentMode);
    }
}

B3pCatalog._exportMetadataFromFile = function() {
    window.location = this.metadataUrl + "?" + $.param({
        "export": "",
        filename: this.currentFilename,
        esriType: this.getCurrentEsriType(),
        strictISO19115: $("#strictISO19115Checkbox").is(":checked")
    });
}

B3pCatalog._exportMetadataByUUID = function() {
    window.location = this.catalogUrl + "?" + $.param({
        "export": "",
        uuid: $("#search-results .search-result-selected").attr("uuid")
    });
}

B3pCatalog.importMetadata = function() {
    $("<div/>").html($("<textarea></textarea>", {
        id: "import-textarea",
        cols: 50,
        rows: 35, // IE 6/7 pakt 100% height niet
        margin: 0,
        padding: 0,
        width: "99%", // nodig voor IE 6/7
        height: "97%", // nodig voor FF (3.6)
        text: "Plak uw te importeren metadata hier"
    })).appendTo(document.body).dialog({
        title: "Metadata importeren in " + B3pCatalog.currentFilename,
        modal: true,
        width: calculateDialogWidth(66),
        height: calculateDialogHeight(80),
        buttons: [{
            text: "Importeer",
            click: function(event) {
                $("#mde").mde("option", "xml", $("#import-textarea").val());
                $(this).dialog("close");
            }
        }],
        close: function(event) {
            $(this).dialog("destroy").remove();
        }
    });
}

B3pCatalog.createToolbar = function(viewMode) {
    var mdeToolbar = $("#mde-toolbar");
    mdeToolbar.empty();
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
                B3pCatalog.importMetadata();
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
                    done: B3pCatalog.exportMetadata,
                    text: "Wilt u uw wijzigingen opslaan alvorens de metadata te exporteren?",
                    asyncSave: false // data needs to be saved already when we do our export request
                });
            } else {
                B3pCatalog.exportMetadata();
            }
        }
    }).button({disabled: false}));
    mdeToolbar.append($("<input type='checkbox' checked='checked' value='strictISO19115' id='strictISO19115Checkbox' />"));
    if (this.currentMode === this.modes.FILE_MODE)
        mdeToolbar.append($("<label for='strictISO19115Checkbox' title='Exporteer als ISO 19115 metadata volgens het Nederlands profiel versie 1.2. Tabs Algemeen, Attributen en Commentaar worden dan weggelaten.'>Exporteer strict</label>"));
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

