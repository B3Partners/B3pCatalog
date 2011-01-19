if (typeof B3pCatalog == "undefined") B3pCatalog = {};

B3pCatalog.currentFilename = "";

B3pCatalog.openErrorDialog = function(message) {
    log("error: " + message);
    $("<div/>").text(message).appendTo(document.body).dialog({
        title: "Error",
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

B3pCatalog.openFile = function(filename) {
    $.ajax({
        url: B3pCatalog.metadataUrl,
        type: "POST",
        data: {"load" : "", "filename" : filename},
        success: function(data) {
            B3pCatalog.currentFilename = filename;
            document.title = "B3pCatalog | " + filename;
            //log(B3pCatalog.currentFilename);
            B3pCatalog.createMde(data);
        }
    });
}

B3pCatalog.createMde = function(xmlDoc) {
    //log("data: " + data);
    $.mde.logMode = true;
    $("#mde").mde({
        xml: xmlDoc,
        baseFullPath: B3pCatalog.contextPath + "/scripts/mde/",
        profile: "nl_md_1.2_with_fc",
        commentMode: true,
        commentPosted: function(comment) {
            var xhr = $.ajax({
                url: B3pCatalog.contextPath + "/Metadata.action",
                data: {"postComment": "", "comment": comment, filename: B3pCatalog.currentFilename},
                method: "POST",
                async: false
            });
            if (xhr.responseXML == null || typeof xhr.responseXML != "object") {
                return xhr.responseText;
            } else {
                return xhr.responseXML;
            }
        },
        changed: function(changed) {
            $("#saveMD").button("option", "disabled", !changed);
        }
    });
    $("#mde-toolbar").empty().append($("<span/>", {
        id: "saveMD",
        text: "Opslaan",
        title: "Metadatadocument opslaan",
        click: function(event) {
            $(this).removeClass("ui-state-hover");
            B3pCatalog.saveMetadata();
        }
    }).button({disabled: true})).append($("<span/>", {
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
            if (data !== "success") {
                log("metadata save error: " + data);
                B3pCatalog.openErrorDialog(data);
            } else {
                log("metadata saved succesfully.");
                if (options.updateUI)
                    $("#saveMD").button("option", "disabled", true);
            }
        },
        error: function(xhr, textStatus, errorThrown) {
            B3pCatalog.openErrorDialog(errorThrown);
        }
    });
}

// http://simonwillison.net/2006/Jan/20/escape/
// used for escaping the file/dirname in the "a" rel-attribute. So it can be put in the jQuery selector.
RegExp.escape = function(text) {
    return text.replace(/[-[\]{}()*+?.,\\^$|#\s]/g, "\\$&");
}


