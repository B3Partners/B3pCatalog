if (typeof B3pCatalog == "undefined") B3pCatalog = {};

B3pCatalog.hashchange = function(event) {
    log("state:");
    log(event.getState());
    var page = event.getState("page");
    var filename = event.getState("filename");
    if (!page && filename) {
        var $selectedFile = $("a[rel=\"" + RegExp.escape(filename) + "\"]", "#filetree");
        if ($selectedFile.length == 0) {
            B3pCatalog.loadFiletree(filename);
        } else {
            // highlight selected
            $(".selected", "#filetree").removeClass("selected");
            $selectedFile.addClass("selected");
            B3pCatalog.fileTreeScrollTo($selectedFile);
        }
        // bad user input is dealt with internally:
        B3pCatalog.loadMetadataFromFile(
            filename,
            event.getState("type", true),
            event.getState("isgeo", true),
            function() {
                B3pCatalog.clickedFileAnchor.removeClass("selected");
                B3pCatalog.getCurrentFileAnchor().addClass("selected").focus();
            }
        );
    } else if (page === "organisations") {
        B3pCatalog.loadOrganisations();
    } else if (page === "csw") {
        showTab($("#main-tabs a[href='#search']"));
    } else {
        // get possible cookie set by login page:
        var loginHash = $.cookie("mdeLoginHash");
        if (loginHash && $.trim(loginHash) !== "#") {
            // delete cookie first (prevent perpetual loops):
            $.cookie("mdeLoginHash", null);
            // we just logged in. get login hash from cookie.
            // this will trigger this event again ("hashchange")
            location.hash = loginHash;
            return; // stop the rest of the function (unnecessary loadFiletree)
        }
    }
    
    if ($("#filetree").children().length == 0) {
        // first run:
        B3pCatalog.loadFiletree();
    }
};


/////////////////////////////// Filetree ///////////////////////////////////////

// zou niet meer nodig moeten zijn nu.
B3pCatalog.loadingFiletree = false;

// Deze functie wordt maar één keer aangeroepen per aanroep van de B3PCatalog pagina, vandaar de boolean.
// De boolean B3pCatalog.loadingFiletree voorkomt het voor een tweede keer starten van de filetree (met alleen de roots)
B3pCatalog.loadFiletree = function(selectedFilePath) {
    log("loadFiletree");
    if (B3pCatalog.loadingFiletree)
        return;
    B3pCatalog.loadingFiletree = true;

    // used to indicate that the selected file does not need to be selected in readyCallback
    var selectedFileFound = false;
    
    $("#filetree").fileTree({
        script: B3pCatalog.filetreeUrl,
        scriptEvent: "listDir",
        root: "",
        spinnerImage: B3pCatalog.contextPath + "/styles/images/spinner.gif",
        expandEasing: "", //"linear",
        collapseEasing: "", //"linear", //"easeOutBounce",
        expandSpeed: 0,
        collapseSpeed: 0,
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

            var newState = {filename: filename};

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
            if (selectedFilePath && !selectedFileFound) {
                var $selectedFile = $("a[rel=\"" + RegExp.escape(selectedFilePath) + "\"]", root);
                //log(selectedFile);
                if ($selectedFile.length > 0) {
                    selectedFileFound = true;
                    $(".selected", root).removeClass("selected");
                    $selectedFile.addClass("selected");
                    B3pCatalog.fileTreeScrollTo($selectedFile);
                }
            } else {
                // no selected file or a directory (root) was clicked
                B3pCatalog.fileTreeScrollTo(root);
            }
        }
    });
}

B3pCatalog.filetreeScrollToOptions = {
    axis: "y",
    duration: 0, //200, //1000,
    easing: "" //"linear" //"easeOutBounce"
}

B3pCatalog.fileTreeScrollTo = function(elem) {
    var $elem = $(elem),
        $pane = $("#sidebar"),

        paneHeight = $pane.height(),
        paneTop = $pane.offset().top,
        paneBottom = paneTop + paneHeight,

        elemHeight = $elem.height(),
        elemTop = $elem.offset().top,
        elemBottom = elemTop + elemHeight;
    
    var isScrolledIntoPane = ((elemBottom >= paneTop) && (elemTop <= paneBottom)
      && (elemBottom <= paneBottom) &&  (elemTop >= paneTop) );

    if (!isScrolledIntoPane) {
        if (elemBottom > paneBottom && elemTop <= paneBottom &&
            elemTop > paneTop && elemHeight < paneHeight) {
            // element is partly out of range at the bottom of the pane: 
            // make sure the element bottom is visible at the bottom of the pane.
            $pane.scrollTo($pane.scrollTop() + elemBottom - paneBottom, B3pCatalog.filetreeScrollToOptions);
        } else {
            // element is completely out of range
            $pane.scrollTo($elem, B3pCatalog.filetreeScrollToOptions);
        }
    }
}

function scrollbarWidth() {
    var div = $('<div style="width:50px;height:50px;overflow:hidden;position:absolute;top:-200px;left:-200px;"><div style="height:100px;"></div>');
    // Append our div, do our calculation and then remove it
    $('body').append(div);
    var w1 = $('div', div).innerWidth();
    div.css('overflow-y', 'scroll');
    var w2 = $('div', div).innerWidth();
    div.remove();
    return (w1 - w2);
}

////////////////////////////// Algemeen ////////////////////////////////////////

$(document).ajaxError(function(event, xhr, ajaxOptions, thrownError) {
    var message = xhr.responseText;
    if (!!thrownError)
        message = thrownError + "<br /><br/>" + message;
    B3pCatalog.openErrorDialog(message);
    return false;
});

B3pCatalog.openErrorDialog = function(message) {
    message = !!message ? message : "Fouttekst is leeg.";
    log("error: " + message);
    $(".spinner").remove();
    $(".wait").removeClass("wait");
    $("<div/>").html(message).appendTo(document.body).dialog({
        title: "Fout",
        modal: true,
        width: $("body").calculateDialogWidth(66),
        height: $("body").calculateDialogHeight(80),
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
};

B3pCatalog.openSimpleErrorDialog = function(message) {
    message = !!message ? message : "Fouttekst is leeg.";
    log("error: " + message);
    $(".spinner").remove();
    $(".wait").removeClass("wait");
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
};


/////////////////////////////////// Status /////////////////////////////////////

// kan niet zomaar checken op zichtbaarheid van file of csw tab. 
// bij switchen van tab blijft metadata rechts in het scherm namelijk zichtbaar (by design).
// de modus hier beschreven is dus de modus van de metadata rechts in het scherm.
// het zou wellicht in een data veld in #mde-wrapper kunnen worden opgeslagen. weinig verschil met status quo.
B3pCatalog.modes = {
    NO_MODE: 0,
    FILE_MODE: 1,
    CSW_MODE: 2,
    ADMIN_MODE: 3
};

// dit kan wat consistenter:
B3pCatalog.currentMode = B3pCatalog.modes.NO_MODE;

B3pCatalog.currentFilename = "";

B3pCatalog.clickedFileAnchor = $();

B3pCatalog.getCurrentEsriType = function() {
    return $("#filetree .jqueryFileTree a.selected").attr("esritype");
};

B3pCatalog.getCurrentFileAnchor = function() {
    return $("a[rel='" + RegExp.escape(B3pCatalog.currentFilename) + "']", "#filetree");
};


/////////////////////////////// Functies ///////////////////////////////////////

B3pCatalog.loadMetadataFromFile = function(filename, esriType, isGeo, cancel) {
    this._loadMetadata({
        done: function() {
            
        },
        cancel: cancel,
        ajaxOptions: {
            url: B3pCatalog.metadataUrl,
            type: "POST",
            data: {
                load : "t",
                filename : filename,
                esriType : typeof esriType == "number" ? esriType : -1
            },
            dataType: "text", // jquery returns the limited (non-activeX) xml document version in IE when using the default or 'xml'. Could use dataType adapter override to fix this: text -> xml
            success: function(data, textStatus, jqXHR) {
                //log(data);
                B3pCatalog.currentFilename = filename;
                B3pCatalog.currentMode = B3pCatalog.modes.FILE_MODE;
                document.title = B3pCatalog.title + B3pCatalog.titleSeparator + filename;
                // TODO: on demand van PBL bv: laatst geopende doc opslaan
                //$.cookie();
                var viewMode = jqXHR.getResponseHeader("MDE_viewMode") === "true";
                B3pCatalog.createMde(data, isGeo, viewMode);
            }
        }
    });
};

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
                load: "t",
                uuid: uuid
            },
            type: "POST",
            dataType: "text",
            success: function(data, textStatus, jqXHR) {
                //log("load by uuid success");
                B3pCatalog.currentMode = B3pCatalog.modes.CSW_MODE;
                // TODO: title kan geëxtract worden uit het xml
                document.title = B3pCatalog.title;
                B3pCatalog.createCswMde(data);
            }
        }
    });
};

B3pCatalog._loadMetadata = function(opts) {
    //log("Loading metadata...");
    var options = $.extend({
        done: $.noop,
        cancel: $.noop,
        ajaxOptions: {}
    }, opts);
    B3pCatalog.saveDataUserConfirm({
        done: function() {
            $("#toolbar").empty();
            $("#mde").mde("destroy");
            var spinner = $("<img />", {
                src: B3pCatalog.contextPath + "/styles/images/spinner.gif",
                "class": "spinner"
            });
            $("#mde").html(spinner);
            var scrollable = $("#mde").closest(":scrollable");
            spinner.position({
                of: scrollable.length > 0 ? scrollable : $(window),
                my: "center center",
                at: "center center"
            });

            document.title = B3pCatalog.title;
            options.done();
            $.ajax(options.ajaxOptions);
        },
        cancel: options.cancel
    });
};

B3pCatalog.saveMetadata = function(settings) {
    var options = $.extend({
        filename: B3pCatalog.currentFilename,
        updateUI: true,
        async: false
    }, settings);

    if (!options.filename)
        return;

    var xml = $("#mde").mde("save");
    $.ajax({
        url: B3pCatalog.metadataUrl,
        async: options.async,
        type: "POST",
        data: {
            save: "t",
            filename: options.filename,
            metadata: xml,
            esriType: B3pCatalog.getCurrentEsriType()
        },
        success: function(data, textStatus, xhr) {
            //log("metadata saved succesfully.");
            B3pCatalog.fadeMessage("Metadata succesvol opgeslagen");
            if (options.updateUI)
                $("#saveMD").button("option", "disabled", true);
        }
    });
};

B3pCatalog.fadeMessage = function(message) {
    log("fadeMessage: " + message);
    var $message = $("<div/>", {
        text: message,
        "class": "fade-message",
        "z-index": 2000
    });
    $("#center").append($message);
    setTimeout(function() {
        $message.fadeOut(2000, function() { 
            $(this).remove(); 
            log("123: " + message);
        });
    }, 2000);
};

B3pCatalog.logout = function() {
    this.saveDataUserConfirm({
        done: function() {
            window.location = B3pCatalog.contextPath + "/logout.jsp";
        }
    });
};

B3pCatalog.saveDataUserConfirm = function(opts) {
    var options = $.extend({
        done: $.noop,
        cancel: $.noop,
        text: "Wilt u uw wijzigingen opslaan?",
        asyncSave: false
    }, opts);
    if ($("#mde .ui-mde-element").length > 0 && $("#mde").mde("option", "changed")) {
        $.yesNoCancel({
            text: options.text,
            yes: function() {
                B3pCatalog.saveMetadata({async: options.asyncSave});
                options.done();
            },
            no: function() {
                options.done();
            },
            cancel: function() {
                options.cancel();
            }
        });
    } else {
        options.done();
    }
};

B3pCatalog.createMde = function(xmlDoc, isGeo, viewMode) {
    $("#mde").mde("destroy");
    $("#center-wrapper").html($("<div>", {
        id: "mde"
    }));

    log("creating mde...");
    $("#mde").mde($.extend({}, B3pCatalog.basicMdeOptions, {
        xml: xmlDoc,
        commentPosted: function(comment) {
            if (!$.trim(comment)) {
                B3pCatalog.openSimpleErrorDialog("Commentaar kan niet leeg zijn.");
                return false;
            } else {
                var xhr = $.ajax({
                    url: B3pCatalog.contextPath + "/Metadata.action",
                    data: {
                        postComment: "t",
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
        change: function(changed) {
            $("#saveMD").button("option", "disabled", !changed);
        }
    }, B3pCatalog.getExtraMdeOptions(isGeo, viewMode)));
    
    B3pCatalog.createMdeToolbar(viewMode);
};

B3pCatalog.createCswMde = function(xmlDoc) {
    $.bbq.pushState({page: "csw"}, 2);
    $("#mde").mde("destroy");
    $("#center-wrapper").html($("<div>", {
        id: "mde"
    }));

    $("#mde").mde($.extend({}, B3pCatalog.basicMdeOptions, {
        xml: xmlDoc,
        viewMode: true
    }));
    B3pCatalog.createMdeToolbar(true);
};

B3pCatalog.exportMetadata = function() {
    switch(B3pCatalog.currentMode) {
        case B3pCatalog.modes.FILE_MODE:B3pCatalog._exportMetadataFromFile();break;
        case B3pCatalog.modes.CSW_MODE:B3pCatalog._exportMetadataByUUID();break;
        default:openErrorDialog(B3pCatalog.title + " is in an illegal mode: " + B3pCatalog.currentMode);
    }
};

B3pCatalog._exportMetadataFromFile = function() {
    $("#mde").mde("option", "pageLeaveWarning", false);
    window.location = B3pCatalog.metadataUrl + "?" + $.param({
        "export": "t",
        filename: B3pCatalog.currentFilename,
        esriType: B3pCatalog.getCurrentEsriType(),
        strictISO19115: $("#strictISO19115Checkbox").is(":checked")
    });
    $("#mde").mde("option", "pageLeaveWarning", true);
};

B3pCatalog._exportMetadataByUUID = function() {
    $("#mde").mde("option", "pageLeaveWarning", false);
    window.location = B3pCatalog.catalogUrl + "?" + $.param({
        "export": "t",
        uuid: $("#search-results .search-result-selected").attr("uuid")
    });
    $("#mde").mde("option", "pageLeaveWarning", true);
};

B3pCatalog.importMetadata = function() {
    var $form = $("<form />", {
        method: "POST",
        action: B3pCatalog.metadataUrl // enctype and encoding set by form plugin
    });
    
    var $chooseXmlDiv = $("<div />", {
        text: "Kies een xml metadata bestand:"
    });
    
    var $fileInput = $("<input type='file' name='uploader' size='50' style='width: 100%' />");
    
    var $textarea = $("<textarea></textarea>", {
        id: "import-textarea",
        cols: 50,
        rows: 35, // IE 6/7 pakt 100% height niet
        css: {
            width: "100%",
            height: "200px",//"100%",
            margin: 0,
            padding: 0
        }
    })
    var placeholderText = "Plak uw te importeren metadata hier";
    if ("placeholder" in $textarea[0]) {
        $textarea.attr("placeholder", placeholderText);
    } else {
        $textarea.text(placeholderText);
    }
    
    var $orDiv = $("<div />", {
        text: "of",
        css: {"margin-top": "1em", "margin-bottom": "1em"}
    })
    
    var $uuidCheckbox = $("<input type='checkbox' id='new-uuid-checkbox' name='new-uuid' />");
    $uuidCheckbox.prop("checked", true);
    
    var $uuidLabel = $("<label for='new-uuid-checkbox'>Genereer nieuwe unieke identifiers (UUID's) voor de metadata en de bron.</label>");
    
    var $submitEventInput = $("<input type='submit' name='importMD' value='Importeren' class='dialog-submit'/>");

    
    var $dialogDiv = $("<div/>", {
        "class": "ui-mde-textarea-wrapper",
        css: {
            overflow: "hidden"
        }
    });
    
    $form.append($chooseXmlDiv);
    $form.append($fileInput);
    $form.append($orDiv);
    $form.append($textarea);
    $form.append($("<hr style='margin-top: 2em' />"));
    $form.append($uuidCheckbox);
    $form.append($uuidLabel);
    $form.append($submitEventInput);
    
    function importMD(xml) {
        $("#mde").mde("option", {
            overwriteUUIDs: $uuidCheckbox.prop("checked"), // moet eerst
            xml: xml // start de mde opnieuw met deze xml
        });
        $dialogDiv.dialog("close");
        B3pCatalog.fadeMessage("Importeren succesvol");
    }
    
    $form.submit(function() {
        if ($fileInput.val()) {
            log("import via fileInput submit");
            $(this).ajaxSubmit({
                async: false,
                data: {importMD: "t"},
                dataType: "text", // text from textarea must not be treated as xml immediately
                success: function(data, status, xhr) {
                    log("import success");
                    importMD(Sarissa.unescape(data));
                }
            });
        } else if ($textarea.val() && $textarea.val() !== placeholderText) {
            log("import via textarea");
            importMD($textarea.val());
        } else {
            $.ok({ 
                text: "Kies een bestand of plak xml in het tekstvak om metadata te importeren."
            });
        }
        return false;
    });
    
    $dialogDiv.append($form);
    $dialogDiv.appendTo(document.body).dialog({
        title: "Metadata importeren in " + B3pCatalog.currentFilename,
        modal: true,
        width: $("body").calculateDialogWidth(66),
        //height: $("body").calculateDialogHeight(80), // auto
        close: function(event) {
            $(this).dialog("destroy").remove();
        }
    });
};

B3pCatalog.synchronizeWithData = function() {
    B3pCatalog.saveDataUserConfirm({
        text: "Wilt u uw wijzigingen opslaan alvorens uw metadata te synchroniseren? Als u \"Nee\" kiest gaan uw wijzigingen verloren.",
        done: function() {
            //log($("#mde").mde("save", {postprocess: false}));
            $.ajax({
                url: B3pCatalog.contextPath + "/Metadata.action",
                data: {
                    synchronize: "t",
                    filename: B3pCatalog.currentFilename,
                    esriType: B3pCatalog.getCurrentEsriType(),
                    metadata: $("#mde").mde("save", {postprocess: false})
                },
                type: "POST",
                async: false,
                dataType: "text",
                success: function(data) {
                    $("#mde").mde("option", "xml", data);
                    B3pCatalog.fadeMessage("Synchronisatie succesvol");
                }
            });
        }
    });
}

B3pCatalog.createAdminOrganisationsToolbar = function() {
    var toolbar = $("#toolbar");
    toolbar.empty();

    toolbar.append(
        $("<a />", {
            href: "#",
            id: "saveOrgs",
            text: "Opslaan",
            title: "Organisaties en contactpersonen opslaan",
            click: function(event) {
                $(this).removeClass("ui-state-hover");
                B3pCatalog.saveOrganisations();
                return false;
            }
        }).button({
            icons: {primary: "ui-icon-b3p-save_16"}
        })
    );
    
    B3pCatalog.resizeTabsAndToolbar();
}

B3pCatalog.createMdeToolbar = function(viewMode) {
    var toolbar = $("#toolbar");
    toolbar.empty();
    if (viewMode === false) {
        toolbar.append(
            $("<a />", {
                href: "#",
                id: "saveMD",
                text: "Opslaan",
                title: "Metadatadocument opslaan",
                click: function(event) {
                    $(this).removeClass("ui-state-hover");
                    B3pCatalog.saveMetadata();
                    return false;
                }
            }).button({
                disabled: true,
                icons: {primary: "ui-icon-b3p-save_16"}
            })
        );
        toolbar.append(
            $("<a />", {
                href: "#",
                id: "resetMD",
                text: "Legen",
                title: "Metadatadocument volledig leeg maken. Wordt nog niet opgeslagen.",
                click: function(event) {
                    $(this).removeClass("ui-state-hover");
                    $.okCancel({
                        text: "Weet u zeker dat u alle metadata en commentaren wilt wissen voor dit document? Dit wordt pas definitief als u op \"Opslaan\" klikt.",
                        ok: function() {
                            $("#mde").mde("reset");
                        }
                    });
                    return false;
                }
            }).button({
                disabled: false,
                icons: {primary: "ui-icon-b3p-delete_16"}
            })
        );
        toolbar.append(
            $("<a />", {
                href: "#",
                id: "synchronizeMD",
                text: "Synchroniseren",
                title: "Metadatadocument synchroniseren met bijbehorend data-document. Wijzigingen in de data, zoals bijvoorbeeld een andere omgrenzende rechthoek, worden doorgevoerd in de metadata.",
                click: function(event) {
                    $(this).removeClass("ui-state-hover");
                    B3pCatalog.synchronizeWithData();
                    return false;
                }
            }).button({
                disabled: false,
                icons: {primary: "ui-icon-b3p-sync_16"}
            })
        );
        toolbar.append(
            $("<a />", {
                href: "#",
                id: "importMD",
                text: "Importeren",
                title: "Metadatadocument importeren en over huidige metadatadocument heen kopiëren. Wordt nog niet opgeslagen.",
                click: function(event) {
                    $(this).removeClass("ui-state-hover");
                    B3pCatalog.importMetadata();
                    return false;
                }
            }).button({
                disabled: false,
                icons: {primary: "ui-icon-b3p-down_16"}
            })
        );
    }
    toolbar.append(
        $("<a />", {
            href: "#",
            id: "exportMD",
            text: "Exporteren",
            title: "Metadatadocument exporteren.",
            click: function(event) {
                $(this).removeClass("ui-state-hover");
                B3pCatalog.saveDataUserConfirm({
                    done: function() {
                        B3pCatalog.exportMetadata();
                    },
                    text: "Wilt u uw wijzigingen opslaan alvorens de metadata te exporteren?",
                    asyncSave: false // data needs to be saved already when we do our export request
                });
                return false;
            }
        }).button({
            disabled: false,
            icons: {primary: "ui-icon-b3p-up_16"}
        })
    );
    if (B3pCatalog.currentMode === B3pCatalog.modes.FILE_MODE) {
        toolbar.append($("<input type='checkbox' checked='checked' value='strictISO19115' id='strictISO19115Checkbox' />"));
        toolbar.append($("<label for='strictISO19115Checkbox' title='Exporteer als ISO 19115 metadata volgens het Nederlands profiel versie 1.2. Tabs Algemeen, Attributen en Commentaar worden dan weggelaten.'>Exporteer strict</label>"));
    }
    B3pCatalog.resizeTabsAndToolbar();
};

B3pCatalog.resizeTabsAndToolbar = function() {
    $("#page-tabs-and-toolbar").css("left", $("#sidebar").width());
};

B3pCatalog.loadOrganisations = function() {
    B3pCatalog.saveDataUserConfirm({
        done: function() {
            $.ajax({
                url: B3pCatalog.adminUrl,
                data: {
                    loadOrganisations: "t"
                },
                success: function(data) {
                    showTab($("#main-tabs a[href='#admin']"));
                    $("#mde").mde("destroy"); // if it exists
                    document.title = B3pCatalog.title + B3pCatalog.titleSeparator + "Beheer organisaties";
                    B3pCatalog.currentMode = B3pCatalog.modes.ADMIN_MODE;
                    B3pCatalog.createAdminOrganisationsToolbar();
                    $("#center-wrapper").html(data);
                }
            });
        }
    });
};

B3pCatalog.saveOrganisations = function() {
    var orgs = $("#organisationsJSON").val();
    $.ajax({
        url: B3pCatalog.adminUrl,
        data: {
            saveOrganisations: "t",
            organisations: orgs
        },
        type: "POST",
        success: function(data) {
            $.globalEval(orgs);
            B3pCatalog.basicMdeOptions.organisations = organisations;
            B3pCatalog.fadeMessage("Organisaties en contacten succesvol opgeslagen");
        }
    });
};



// dialogs:
(function($) {
    $.yesNoCancel = function(opts) {
        var options = $.extend({
            text: "Lege vraag",
            yes: $.noop,
            no: $.noop,
            cancel: $.noop
        }, opts);
        $("<div/>").text(options.text).appendTo(document.body).dialog($.extend({
            title: "Vraag",
            modal: true,
            buttons: [{
                text: "Ja",
                click: function(event) {
                    options.yes();
                    $(this).dialog("destroy").remove();
                }
            }, {
                text: "Nee",
                click: function(event) {
                    options.no();
                    $(this).dialog("destroy").remove();
                }
            }, {
                text: "Annuleren",
                click: function(event) {
                    $(this).dialog("close"); // close does cancel
                }
            }],
            close: function(event) {
                options.cancel();
                $(this).dialog("destroy").remove();
            }
        }, options));
    }

    $.okCancel = function(opts) {
        var options = $.extend({
            text: "Lege vraag",
            ok: $.noop,
            cancel: $.noop
        }, opts);
        $("<div/>").text(options.text).appendTo(document.body).dialog($.extend({
            title: "Vraag",
            modal: true,
            buttons: [{
                text: "OK",
                click: function(event) {
                    options.ok();
                    $(this).dialog("destroy").remove();
                }
            }, {
                text: "Annuleren",
                click: function(event) {
                    $(this).dialog("close"); // close does cancel
                }
            }],
            close: function(event) {
                options.cancel();
                $(this).dialog("destroy").remove();
            }
        }, options));
    }

    $.ok = function(opts) {
        var options = $.extend({
            text: "Lege opmerking",
            ok: $.noop
        }, opts);
        $("<div/>").text(options.text).appendTo(document.body).dialog($.extend({
            title: "Opmerking",
            modal: true,
            buttons: [{
                text: "OK",
                click: function(event) {
                    $(this).dialog("close"); // close does ok
                }
            }],
            close: function(event) {
                options.ok();
                $(this).dialog("destroy").remove();
            }
        }, options));
    }

    $.fn.calculateDialogWidth = function(percentageOfElementWidth, minWidth, maxWidth) {
        return calculateDialogSize(percentageOfElementWidth, minWidth, maxWidth, this.width());
    }

    $.fn.calculateDialogHeight = function(percentageOfElementHeight, minHeight, maxHeight) {
        return calculateDialogSize(percentageOfElementHeight, minHeight, maxHeight, this.height());
    }

    function calculateDialogSize(percentage, minSize, maxSize, bodySize) {
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
})(jQuery);
