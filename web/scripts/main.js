if (typeof B3pCatalog == "undefined") B3pCatalog = {};

B3pCatalog.hashchange = function(event) {
    console.log("hashchange", event);
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

    if ($("#filetree-file").children().length == 0) {
        // first run:
        B3pCatalog.loadFiletreeFile();
        B3pCatalog.loadFiletreeSDE();
    }

    if(event.getState("page") === "organisations") {
        B3pCatalog.loadOrganisations();
        return;
    }

    if(event.getState("page") === "csw") {
        showTab($("#main-tabs a[href='#search']"));
        return;
    }

    if(event.getState("page") == "metadata") {
        $(".selected", "#filetree").removeClass("selected");
        var mode = event.getState("mode");
        var $selectedFile = $("a[rel=\"" + RegExp.escape(event.getState("path")) + "\"]", "#filetree-" + mode);
        if ($selectedFile.length == 0) {
            B3pCatalog.loadFiletreeFile(event.getState("path"));
        } else {
            // highlight selected
            $selectedFile.addClass("selected");
            B3pCatalog.fileTreeScrollTo($selectedFile);
        }

        B3pCatalog.loadMetadata(
            mode,
            event.getState("path"),
            event.getState("title"),
            event.getState("isGeo",true),
            function() {
                B3pCatalog.clickedFileAnchor.removeClass("selected");
                B3pCatalog.getCurrentFileAnchor().addClass("selected").focus();
            }
        );
        return;
    }
};

B3pCatalog.loadLocal = function(success) {
    var me = this;
    if(!this.local) {
        $.okCancel({
            text: "Voor het openen van lokale mappen is een Java applet nodig. Dit werkt het beste wanneer de laatste versie van Java geinstalleerd is. Doorgaan met het laden van het applet?",
            ok: function() {
                me.local = new LocalAccess();
                me.local.initApplet(B3pCatalog.contextPath + "/applet", "applet-container", success);
            }
        });
    } else {
        success();
    }
}
    
B3pCatalog.connectDirectory = function() {
    var me = this;
    this.loadLocal( function() {
        me.local.callApplet("selectDirectory", "Selecteer een map...", 
            function(dir) { 
                if(dir != null) {
                    B3pCatalog.loadFiletreeLocal(dir);
                }
            },
            B3pCatalog.openSimpleErrorDialog
        );
    });
}

function htmlEncode(str) {
    var div = document.createElement("div");
    var txt = document.createTextNode(str);
    div.appendChild(txt);
    return div.innerHTML;
}

function extension(f) {
    return f.substring((f.lastIndexOf(".")+1));
}

function filterOutMetadataFiles(files) {
    var i = 0;
    while(i < files.length) {
        var f = files[i];
        var prev = files[i-1];
        if(i > 0 && prev.n == f.n.substring(0,prev.n.length)) {
            if(f.n.substring(prev.n.length) == ".xml") {
                prev.m = true;
                files.splice(i,1);
                continue;
            }            
        } 
        prev = f.n;
        i++;
    }
}

function filterOutShapeExtraFiles(files) {
    var shapefiles = [];
    for(var i = 0; i < files.length; i++) {      
        var f = files[i];
        if(f.d == 0) {
            if(extension(f.n) == "shp") {
                shapefiles[shapefiles.length] = f.n.substring(0,f.n.length - 4);           
            }
        }
    }
    
    for(var i = 0; i < shapefiles.length; i++) {
        var shp = shapefiles[i];
        var j = 0;
        while(j < files.length) {
            var f = files[j];
            if(f.n.substring(0,shp.length) == shp) {
                if(extension(f.n) != "shp") {
                    files.splice(j,1);
                    continue;
                }
            }
            j++;
        }
    }
}

B3pCatalog.decodeFileList = function(data, fileJSON, success) {
    
    
    eval("var files = " + fileJSON);    
    
    var s = "<ul class=\"jqueryFileTree\">";
    
    files.sort( function(lhs, rhs) {
        if(lhs.d != rhs.d) {
            return lhs.d < rhs.d ? 1 : -1;
        }    
        return lhs.n.localeCompare(rhs.n);
    });
    
    filterOutMetadataFiles(files);
    filterOutShapeExtraFiles(files);
    
    var dir = data.expandTo || data.dir;
    
    if(data.expandTo) {
        var d = htmlEncode(data.expandTo);
        s += "<li class=\"directory expanded\">" +
            "<a href=\"#\" rel=\"" + d + "\" title=\"" + d + "\">" + d + "</a>";
        s += "<ul class=\"jqueryFileTree\">";
    }                

    for(i = 0; i < files.length; i++) {
        f = files[i];
        if(f.d != 0) {
            var en = htmlEncode(f.n);
            s += "<li class=\"directory collapsed\">";
            s += "<a href=\"#\" rel=\"" + htmlEncode(dir) + "/" + en + "\" title=\"" + en + "\">";
            s += en + "</a></li>";            
        } else  {
            var idx = f.n.lastIndexOf(".");
            var ext = "";
            if(idx != -1) {
                ext = f.n.substring(idx+1);
                if(ext.indexOf(" ") == -1) { // not entirely foolproof
                    ext = "ext_" + ext;
                } else {
                    ext = "";
                }
            }
            if(f.m) {
                ext += " with_metadata";
            }
            s += "<li class=\"file " + ext + "\">";
            var en = htmlEncode(f.n);
            s += "<a href=\"#\" m=\"" + (!!f.m) + "\" rel=\"" + htmlEncode(dir) + "/" + en + "\" title=\"" + en + " (" + (f.s / 1024).toFixed(2) + " KB)" + (f.m ? " (metadata XML bestand aanwezig)" : "") + "\">";
            s += en + "</a></li>";
        }
    }
    if(data.expandTo) {
        s += "</ul></li>";
    }
    s += "</ul>";
    success(s);
}
    
B3pCatalog.loadFiletreeLocal = function(dir) {
    log("loadFiletreeLocal", dir);
    
    var me = this;

    B3pCatalog._loadFiletree(dir, $("#filetree-local"), {
        noAjax: function(data, success, error) {
            log("list directory", data.expandTo || data.dir);            
            me.local.callApplet("listDirectory", data.expandTo || data.dir, 
                function(files) {
                    B3pCatalog.decodeFileList(data, files, success)
                },
                function(e) {
                    $.ok({text: e});
                    error();
                }
            );
        },
        fileCallback: function(rel, aElement) {
            var anchor = B3pCatalog.clickedFileAnchor = $(aElement);
            if (anchor.length > 0 && anchor.hasClass("selected"))
                return;

            var newState = {
                page: "metadata",
                mode: B3pCatalog.modes.LOCAL_MODE,
                path: rel,
                title: anchor.attr("title")
            };

            $.bbq.pushState(newState, 2);
        }
    });    
}

/////////////////////////////// Filetree ///////////////////////////////////////

// zou niet meer nodig moeten zijn nu.
B3pCatalog.loadingFiletreeFile = false;

// Deze functie wordt maar één keer aangeroepen per aanroep van de B3PCatalog pagina, vandaar de boolean.
// De boolean B3pCatalog.loadingFiletree voorkomt het voor een tweede keer starten van de filetree (met alleen de roots)
B3pCatalog.loadFiletreeFile = function(selectedFilePath) {
    log("loadFiletreeFile");
    if (B3pCatalog.loadingFiletreeFile)
        return;
    B3pCatalog.loadingFiletreeFile = true;

    B3pCatalog._loadFiletree(selectedFilePath, $("#filetree-file"), {
        scriptEvent: "listDir",
        fileCallback: function(rel, aElement) {
            //log("file clicked: " + filename);
            var anchor = B3pCatalog.clickedFileAnchor = $(aElement);
            if (anchor.length > 0 && anchor.hasClass("selected"))
                return;

            var newState = {
                page: "metadata",
                mode: B3pCatalog.modes.FILE_MODE,
                path: rel,
                title: anchor.attr("title"),
                isGeo: "true" == anchor.attr("isgeo")
            };
console.log("loadFiletreeFile",newState,$.bbq);
            $.bbq.pushState(newState, 2);
        }
    });
};

// zou niet meer nodig moeten zijn nu.
B3pCatalog.loadingFiletreeSDE = false;

B3pCatalog.loadFiletreeSDE = function(selectedFilePath) {
    if (B3pCatalog.loadingFiletreeSDE)
        return;
    B3pCatalog.loadingFiletreeSDE = true;

    B3pCatalog._loadFiletree(selectedFilePath, $("#filetree-sde"), {
        scriptEvent: "listSDEDir",
        fileCallback: function(rel, aElement) {
            var anchor = B3pCatalog.clickedFileAnchor = $(aElement);
            if (anchor.length > 0 && anchor.hasClass("selected"))
                return;
            
            var newState = {
                page: "metadata",
                mode: B3pCatalog.modes.SDE_MODE,
                path: rel,
                title: anchor.attr("title")                
            };

            $.bbq.pushState(newState, 2);
        }
    });
};

B3pCatalog._loadFiletree = function(selectedFilePath, $elem, extraOpts) {
    // used to indicate that the selected file does not need to be selected in readyCallback
    var selectedFileFound = false;
    
    $elem.fileTree($.extend({
        scriptEvent: "",
        script: B3pCatalog.filetreeUrl,
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
        fileCallback: $.noop,
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
    }, extraOpts));
};

B3pCatalog.filetreeScrollToOptions = {
    axis: "y",
    duration: 0, //200, //1000,
    easing: "" //"linear" //"easeOutBounce"
};

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
};

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
    NO_MODE: "none",
    FILE_MODE: "file",
    SDE_MODE: "sde",
    LOCAL_MODE: "local",
    CSW_MODE: "csw",
    ADMIN_MODE: "admin"
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

B3pCatalog.loadMetadata = function(mode, path, title, isGeo, cancel) {

    var opts = {
        done: function() {
            
        },
        cancel: cancel,
        ajaxOptions: {
            url: B3pCatalog.metadataUrl,
            type: "POST",
            data: {
                loadMdAsHtml : "t",
                mode: mode,
                path : path
            },
            dataType: "text", // jquery returns the limited (non-activeX) xml document version in IE when using the default or 'xml'. Could use dataType adapter override to fix this: text -> xml
            success: function(data, textStatus, jqXHR) {
                //log(data);
                B3pCatalog.currentFilename = path;
                B3pCatalog.currentMode = mode;
                document.title = B3pCatalog.title + B3pCatalog.titleSeparator + title;
                // TODO: on demand van PBL bv: laatst geopende doc opslaan
                //$.cookie();
                var access = jqXHR.getResponseHeader("X-MDE-Access");
                var viewMode = false; //access != "WRITE";
                 
                B3pCatalog.createMdeHtml(data, isGeo, viewMode);
            }
        }
    };
    
    $("#synchronizeMD").button("option", "disabled", false);   
      
    this._loadMetadata(opts);
};

B3pCatalog.refreshMde = function() {
    var mde = $("#mde").data("mde");
    
    var changedElements = mde.getChangedElements();
    var sectionChange = mde.getSectionChange();
    
    console.log("refreshMde", changedElements, sectionChange);
    
    var viewMode = mde.options.viewMode;
    var currentTab = mde.options.currentTab;
    
    $.ajax({
        url: B3pCatalog.metadataUrl,
        type: "POST",
        dataType: 'html',
        data: {
            updateXml: "t",
            elementChanges: JSON.stringify(changedElements),
            sectionChange: sectionChange === null ? null : JSON.stringify(sectionChange)
        },
        success: function(data, textStatus, xhr) {
            console.log("updateXml", data);
            
            // TODO: isGeo onthouden
            B3pCatalog.createMdeHtml(data, true, viewMode, { currentTab: currentTab});            
        }
    });    
    
}

B3pCatalog.loadMetadata2 = function(mode, path, title, isGeo, cancel) {

    var opts = {
        done: function() {
            
        },
        cancel: cancel,
        ajaxOptions: {
            url: B3pCatalog.metadataUrl,
            type: "POST",
            data: {
                load : "t",
                mode: mode,
                path : path
            },
            dataType: "text", // jquery returns the limited (non-activeX) xml document version in IE when using the default or 'xml'. Could use dataType adapter override to fix this: text -> xml
            success: function(data, textStatus, jqXHR) {
                //log(data);
                B3pCatalog.currentFilename = path;
                B3pCatalog.currentMode = mode;
                document.title = B3pCatalog.title + B3pCatalog.titleSeparator + title;
                // TODO: on demand van PBL bv: laatst geopende doc opslaan
                //$.cookie();
                var access = jqXHR.getResponseHeader("X-MDE-Access");
                var viewMode = false; //access != "WRITE";
                B3pCatalog.createMde(data, isGeo, viewMode);
            }
        }
    };
    
    $("#synchronizeMD").button("option", "disabled", false);       
    
    var me = this;
    /*
    if(mode == B3pCatalog.modes.LOCAL_MODE) {

        opts.noAjax = function() {
            
            function loadLocalMetadata(md) {
                B3pCatalog.currentFilename = path;
                B3pCatalog.currentMode = mode;
                document.title = B3pCatalog.title + B3pCatalog.titleSeparator + title;                            
                B3pCatalog.createMde(md, isGeo, false);                            

                var lpath = path.toLowerCase();
                if(! (endsWith(lpath, ".shp.xml") || endsWith(lpath, ".nc.xml") || endsWith(lpath, ".cdf.xml"))) {
                    console.log("disabling synchronize button for "+lpath);
                    $("#synchronizeMD").button("option", "disabled", true);       
                }
            }
            
            if(extension(path) == "xml") {
                
                me.loadLocal(function() {
                    me.local.callApplet("readFileUTF8", path,
                        loadLocalMetadata,
                        function(e) {
                            B3pCatalog.openSimpleErrorDialog("Fout bij lezen bestand: " + e);
                            cancel();
                            return;
                        });                
                });
            } else {
                path = path + ".xml";
                me.loadLocal(function() {
                    me.local.callApplet("readFileUTF8", path,
                        function(md) {
                            if(md == null) {
                                // XML bestand bestaat nog niet                                
                                loadLocalMetadata("");
                            } else {
                                loadLocalMetadata(md);
                            }
                        },
                        function(e) {
                            B3pCatalog.openSimpleErrorDialog("Fout bij lezen metadata : " + e);
                            cancel();
                        }
                    );
                });
            }
        }
    }*/
    
    this._loadMetadata(opts);
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
            if(opts.noAjax) {
                opts.noAjax();
            } else {
                $.ajax(options.ajaxOptions);
            }
        },
        cancel: options.cancel
    });
};

function endsWith(s, n) {
    return s.indexOf(n, s.length - n.length) != -1;
}

B3pCatalog.saveMetadata = function(settings) {

    if(B3pCatalog.currentMode == B3pCatalog.modes.LOCAL_MODE) {

        var me = this;
        
        // Get updated XML from server
        
        var mde = $("#mde").data("mde");
        var changedElements = mde.getChangedElements();
        var sectionChange = mde.getSectionChange();
    
        $.ajax({
            url: B3pCatalog.metadataUrl,
            type: "POST",
            dataType: 'html',
            data: {
                updateElementsAndGetXml: "t",
                elementChanges: JSON.stringify(changedElements),
                sectionChange: sectionChange === null ? null : JSON.stringify(sectionChange)
            },
            success: function(data, textStatus, xhr) {

                var xml = data;
                
                me.loadLocal(function() {

                    me.local.callApplet("writeFileUTF8", B3pCatalog.currentFilename, xml,
                        function() {
                            B3pCatalog.fadeMessage("Metadata succesvol opgeslagen");
                            $("#saveMD").button("option", "disabled", true);       
                            if(!endsWith(B3pCatalog.currentFilename.toLowerCase(), ".xml")) {
                                B3pCatalog.clickedFileAnchor.addClass("with_metadata");
                            }
                        },
                        function(e) {
                            B3pCatalog.openSimpleErrorDialog("Fout bij opslaan bestand: " + e);
                        }
                    );
                });
            }
        });    
        
    } else {
        var options = $.extend({
            filename: B3pCatalog.currentFilename,
            updateUI: true,
            async: false
        }, settings);

        if (!options.filename)
            return;

        var mde = $("#mde").data("mde");
        var changedElements = mde.getChangedElements();
        var sectionChange = mde.getSectionChange();
    
        $.ajax({
            url: B3pCatalog.metadataUrl,
            type: "POST",
            dataType: 'html',
            data: {
                updateAndSaveXml: "t",
                elementChanges: JSON.stringify(changedElements),
                sectionChange: sectionChange === null ? null : JSON.stringify(sectionChange),
                path: options.filename,
                mode: B3pCatalog.currentMode
            },
            success: function(data, textStatus, xhr) {
                B3pCatalog.fadeMessage("Metadata succesvol opgeslagen");
                if (options.updateUI)
                    $("#saveMD").button("option", "disabled", true);
            }
        });    
    }
};

B3pCatalog.fadeMessage = function(message) {
    var $message = $("<div/>", {
        text: message,
        "class": "fade-message",
        "z-index": 2000
    });
    $("#center").append($message);
    setTimeout(function() {
        $message.fadeOut(2000, function() { 
            $(this).remove(); 
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

B3pCatalog.commentUsername = null;

B3pCatalog.createMde = function(xmlDoc, isGeo, viewMode) {
    B3pCatalog.createMde2(xmlDoc, null, isGeo, viewMode);
};

B3pCatalog.createMdeHtml = function(htmlDoc, isGeo, viewMode, extraOptions) {
     B3pCatalog.createMde2(null, htmlDoc, isGeo, viewMode, extraOptions);
};

B3pCatalog.createMde2 = function(xmlDoc, htmlDoc, isGeo, viewMode, extraOptions) {
    $("#mde").mde("destroy");
    $("#center-wrapper").html($("<div>", {
        id: "mde"
    }));
    
    log("creating mde...");
    $("#mde").mde($.extend({}, B3pCatalog.basicMdeOptions, {
        xmlHtml: htmlDoc,
        commentPosted: function(comment) {
            if (!$.trim(comment)) {
                B3pCatalog.openSimpleErrorDialog("Commentaar kan niet leeg zijn.");
                return false;
            } else {
                var me = B3pCatalog;
                
                if(me.commentUsername == null) {
                    if(me.username != null && me.username.trim().length > 0) {
                        me.commentUsername = me.username;
                    } else {
                        me.commentUsername = $.cookie('commentUsername');
                        if(me.commentUsername == null) {
                            me.commentUsername = prompt("Onder welke naam wilt u dit commentaar plaatsen?");                        
                        }
                        if(me.commentUsername == null) {
                            return null;
                        } else {
                            $.cookie("commentUsername", me.commentUsername, {expires: 30});
                        }
                    }
                }

                var metadata = "";
                
                if(B3pCatalog.currentMode == B3pCatalog.modes.LOCAL_MODE) {
                    metadata = $("#mde").mde("save");
                }
                var xhr = $.ajax({
                    url: B3pCatalog.metadataUrl,
                    data: {
                        postComment: "t",
                        comment: comment,
                        path: B3pCatalog.currentFilename,
                        mode: B3pCatalog.currentMode,
                        metadata: metadata,
                        username: me.commentUsername
                    },
                    dataType: "text",
                    type: "POST",
                    async: false
                });
                if(B3pCatalog.currentMode == B3pCatalog.modes.LOCAL_MODE) {
                    $("#saveMD").button("option", "disabled", false);              
                }                
                return xhr.responseText;
            }
        },
        onServerTransformRequired: function() { console.log("onServerTransformRequired"); B3pCatalog.refreshMde(); },
        change: function(changed) {            
            $("#saveMD").button("option", "disabled", !changed);
        }
    }, B3pCatalog.getExtraMdeOptions(isGeo, viewMode)
    , extraOptions));
    
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
        case B3pCatalog.modes.SDE_MODE:
        case B3pCatalog.modes.LOCAL_MODE:
        case B3pCatalog.modes.FILE_MODE:B3pCatalog._exportMetadata();break;
        case B3pCatalog.modes.CSW_MODE:B3pCatalog._exportMetadataByUUID();break;
        default:B3pCatalog.openSimpleErrorDialog(B3pCatalog.title + " is in an illegal mode: " + B3pCatalog.currentMode);
    }
};

B3pCatalog._exportMetadata = function() {
    
    $.yesNoCancel({
        html: "Wilt u alle metadata exporteren? Indien u nee antwoordt worden alleen de ISO19115 metadata " +
            " gegevens op de tab \"Geografisch\" geexporteerd.<p>" +
            "<b>Ja</b>: XML root element <tt>&lt;metadata&gt;</tt> met verschillende soorten metadata, o.a. attributen en commentaar" +
            "<p><b>Nee</b>: XML root element <tt>&lt;MD_Metadata&gt;</tt> volgens het ISO 19139 XML schema",
        yes: function() {
            B3pCatalog._doExportMetadata(false);
        },
        no: function() {
            B3pCatalog._doExportMetadata(true);
        },
        cancel: function() {
        }
    });
}
    
B3pCatalog._doExportMetadata = function(strict) {    
    $("#mde").mde("option", "pageLeaveWarning", false);

    if(B3pCatalog.currentMode == B3pCatalog.modes.LOCAL_MODE) {
        var metadata = $("#mde").mde("save");
        
        var action = B3pCatalog.metadataUrl + "?" + $.param({
                "export": "t",
                "mode": B3pCatalog.currentMode,
                "path": B3pCatalog.currentFilename,
                strictISO19115: strict
                });
                
        var form = $("<form>", {
            "method": "POST",
            "action": action
        }).append(
            $("<textarea>", {
                "name": "metadata"
            }).text(metadata).hide()
        );
        form.appendTo("body").submit();
        form.remove();
    } else {
        window.location = B3pCatalog.metadataUrl + "?" + $.param({
            "export": "t",
            path: B3pCatalog.currentFilename,
            mode: B3pCatalog.currentMode,
            strictISO19115: strict
        });
    }
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
    
    var $fileInput = $("<input type='file' name='importXml' size='50' style='width: 100%' />");
    
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
    var me = this;
    
    var doIt = function(synchronizeData) {
        //log($("#mde").mde("save", {postprocess: false}));
        $.ajax({
            url: B3pCatalog.metadataUrl,
            data: {
                synchronize: "t",
                path: B3pCatalog.currentFilename,
                mode: B3pCatalog.currentMode,
                metadata: $("#mde").mde("save", {postprocess: false}),
                synchronizeData: synchronizeData
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
        
    B3pCatalog.saveDataUserConfirm({
        text: "Wilt u uw wijzigingen opslaan alvorens uw metadata te synchroniseren? Als u \"Nee\" kiest gaan uw wijzigingen verloren.",
        done: function() {
            
            if(B3pCatalog.currentMode == B3pCatalog.modes.LOCAL_MODE) {            
                var fn = B3pCatalog.currentFilename;
                if(endsWith(fn, ".xml")) {
                    fn = fn.substr(0, fn.length-4);
                }
                if(endsWith(fn.toLowerCase(), ".shp")) {
                    me.local.callApplet("getShapefileMetadata",
                        fn,
                        doIt,
                        B3pCatalog.openSimpleErrorDialog);
                } else if(endsWith(fn.toLowerCase(), ".nc")) {
                    me.synchronizeNetCDF(fn);
                }
                return;
            } else {
                doIt();
            }
        }
    });
}

B3pCatalog.synchronizeNetCDF = function(fn) {
    
    var gotNCML = function(ncml) {

        $.ajax({
            url: B3pCatalog.metadataUrl,
            data: {
                synchronize: "t",
                path: B3pCatalog.currentFilename,
                mode: B3pCatalog.currentMode,
                metadata: $("#mde").mde("save", {postprocess: false}),
                synchronizeData: ncml
            },
            type: "POST",
            async: false,
            dataType: "text",
            success: function(data) {
                $("#mde").mde("option", "xml", data);
                B3pCatalog.fadeMessage("NCML ingelezen, exporteer volledige metadata voor <netcdf> XML");
            }
        });        
    }
    
    this.local.callApplet("getNCML",
        fn,
        gotNCML,
        B3pCatalog.openSimpleErrorDialog);
}

B3pCatalog.publishMetadata = function() {
    
    var xml = $("#mde").mde("save");

    $.ajax({
        url: B3pCatalog.publishUrl,
        type: "POST",
        data: {
            publish: "t",
            metadata: xml
        },
        success: function(data, textStatus, xhr) {
            
            B3pCatalog.fadeMessage("Metadata succesvol gepubliceerd " + (data.exists ? "(update)" : "(nieuw)"));
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
           
    if(B3pCatalog.username != null && B3pCatalog.haveCsw) {
        toolbar.append(
            $("<a />", {
                href: "#",
                id: "publishMD",
                text: "Publiceren",
                title: "Metadatadocument publiceren naar CSW",
                click: function(event) {
                    $(this).removeClass("ui-state-hover");
                    B3pCatalog.saveDataUserConfirm({
                        done: function() {
                            B3pCatalog.publishMetadata();
                        },
                        text: "Wilt u uw wijzigingen opslaan alvorens de metadata te publiceren?",
                        asyncSave: false // data needs to be saved already when we do our publish request
                    });
                    return false;
                }
            }).button({
                disabled: false,
                icons: {primary: "ui-icon-b3p-sync_alt_16"}
            })
        );
        
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
        
        var div = $("<div/>");
        
        if(options.html) {
            div.html(options.html);
        } else {
            div.text(options.text);
        }
        div.appendTo(document.body).dialog($.extend({
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
