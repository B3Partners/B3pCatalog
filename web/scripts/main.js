if (typeof B3pCatalog == "undefined") B3pCatalog = {};

$(document).ajaxError(function(event, xhr, ajaxOptions, thrownError) {
    B3pCatalog.openErrorDialog(thrownError + "<br />" + xhr.responseText);
});

B3pCatalog.openErrorDialog = function(message) {
    log("error: " + message);
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

B3pCatalog.currentFilename = "";

B3pCatalog.loadMetadataFromFile = function(filename) {
    $("#mde-toolbar").empty();
    $("#mde").html($("<img />", {
        src: B3pCatalog.contextPath + "/styles/images/spinner.gif"
    }));
    $.ajax({
        url: B3pCatalog.metadataUrl,
        type: "POST",
        data: {"load" : "", "filename" : filename},
        dataType: "text", // jquery returns the limited (non-activeX) xml document version in IE when using the default or 'xml'
        success: function(data, textStatus, jqXHR) {
            //log(data);
            B3pCatalog.currentFilename = filename;
            document.title = "B3pCatalog | " + filename;
            B3pCatalog.createMde(data);
        }
    });
}

B3pCatalog.loadMetadataByUUID = function(uuid) {
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
        data: {save: "", filename: options.filename, metadata: xml},
        success: function(data, textStatus, xhr) {
            log("metadata saved succesfully.");
            if (options.updateUI)
                $("#saveMD").button("option", "disabled", true);
        }
    });
}

B3pCatalog.saveDataUserConfirm = function(opts) {
    var options = $.extend({
        done: $.noop,
        cancel: $.noop
    }, opts);
    if ($("#mde").mde("initialized") && $("#mde").mde("changed")) {
        $("<div/>").text("Wilt u uw wijzigingen opslaan?").appendTo(document.body).dialog({
            title: "Vraag",
            modal: true,
            buttons: [{
                text: "Ja",
                click: function(event) {
                    B3pCatalog.saveMetadata();
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
    iso19115oneTab: true,
    geoTabsMinimizable: true,
    geoTabsStartMinimized: true
}

B3pCatalog.createMde = function(xmlDoc) {
    //log("data: " + data);
    B3pCatalog.destroyMdeWrapper();
    $.mde.logMode = true;
    $("#mde").mde($.extend({}, B3pCatalog.basicMdeOptions, {
        xml: xmlDoc,
        commentMode: true,
        commentPosted: function(comment) {
            var xhr = $.ajax({
                url: B3pCatalog.contextPath + "/Metadata.action",
                data: {"postComment": "", "comment": comment, filename: B3pCatalog.currentFilename},
                dataType: "text",
                method: "POST",
                async: false
            });
            return xhr.responseText;
        },
        changed: function(changed) {
            $("#saveMD").button("option", "disabled", !changed);
        }
    }));
    $("#mde-toolbar").append($("<a />", {
        href: "#",
        id: "saveMD",
        text: "Opslaan",
        title: "Metadatadocument opslaan",
        click: function(event) {
            $(this).removeClass("ui-state-hover");
            B3pCatalog.saveMetadata();
        }
    }).button({disabled: true})).append($("<a />", {
        href: "#",
        id: "resetMD",
        text: "Legen",
        title: "Metadatadocument volledig leeg maken. Wordt nog niet opgeslagen.",
        click: function(event) {
            // TODO: confirmation box: Weet u zeker dat u alle metadata en commentaren wilt wissen voor dit document? Dit wordt pas definitief als u op "Opslaan" klikt.
            $(this).removeClass("ui-state-hover");
            $("#mde").mde("reset");
        }
    }).button({disabled: false})
    );
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

