/*
B3P Metadata Editor is a ISO 19139 compliant metadata editor,
that is preconfigured to use the Dutch profile for geography

Copyright 2006-2012 B3Partners BV

This file is part of B3P Metadata Editor.

B3P Metadata Editor is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, either version 3 of the License, or
(at your option) any later version.

B3P Metadata Editor is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with B3P Kaartenbalie.  If not, see <http://www.gnu.org/licenses/>.
*/
var Thesaurus = function Thesaurus(_name, url, autocompleteTerms) {
    this._name = _name;
    this.url = url;
    this.autocomplete = autocompleteTerms;
}

var mdeGlobal = null;

(function($, undefined) {

$.widget("ui.mde", {
    options: {
        xmlHtml: "", // input to html transformed xml string or XmlDocument.
        onServerTransformRequired: function() { console.log("default..."); return false; },
        onResetRequired: function() { console.log("default..."); return false; },
        richTextMode: true, // if true, allows users to write wiki-like text in some fields and in comments.
        commentPosted: function(comment) {return false}, // function that will be called when a user post a comment. This function should make a server call (synchronously) and return the resulting xml document from the server. Errors during the servercall should be caught within this method. MDE will not do this.
        change: function(changed) {}, // function that will be called when the md document changes.
        afterInit: function() {}, // called each time after a xml document has been converted to html and the gui is completely initialized. Use this to personalize the mde.
        extraTitleAboveTabs: true, // if true, will show an extra title element read-only above the tabs
        iso19115PreviewImageInsideGeotab: false, // if true, will show preview image inside the first geotab instead of above the tabs.
        logMode: false, // is logging enabled (Firebug, Chrome, IE8+, Opera)
        changed: false, // modify externally whether the mde is in changed mode. Use with care. (add/removes star in title and calls change callback...)
        tabContainerSelector: "#ui-mde-tabs-container", // the default tab container is residing above the md document.
        organisations: {}, // autocomplete organisations and contacts; see organisations.js for examples
        //TODO CvL
//        getOrganisations: function() { console.log("default..."); return {}; },
        wiki2htmlHelpUrl: "http://nl.wikipedia.org/wiki/Wikipedia:Spiekbriefje", // hulpmiddel voor richtext elems
        thesauri: [
                new Thesaurus("GEMET thesaurus","http://www.eionet.europa.eu/gemet/inspire_themes?langcode=nl", /* loadJsonTerms("picklists/gemet-nl.json") */ gemetInspireNlTerms)
        ],
        currentTab: undefined, // opties: undefined (== eerste tab), #algemeen, #service, #overzicht, #specificaties, #iso19115, #attributen of #commentaar of een DOM anchor tab element of jQuery anchor tab element
        overwriteUUIDs: false, // overwrite metadata and data uuid's after starting the mde? be very careful with this option.
        dateFormat: "dd-mm-yy", // used for conversion from/to ISO19115. Is jQuery UI DatePicker dateformat: http://docs.jquery.com/UI/Datepicker/formatDate
        storedDateFormat: "yy-mm-dd", // date format used to store dates. Is jQuery UI DatePicker dateformat: http://docs.jquery.com/UI/Datepicker/formatDate
        dateFormatUserHint: "dd-mm-jjjj", // hint shown to the user in an empty date(-like) field, where the user should enter a date according to the "dateFormat" option.
        pageLeaveWarning: true // display a warning when the user tries to go to a new page or close the tab or browser. Can also be used for for example exporting metadata ("new" download file page) by temporarily disabling this option.
    },

    ///////////////////////////////// INTERNAL VARIABLES ///////////////////////////

    preEditText: undefined,
    mouseOverMultiInput: false,
    
    changedElements: [], // array of objects with changed elements (path, attrName en newValue)    
    sectionChange: null, // object with information about requested section change (add or delete)
    
    openedMenuNode: $(),

    ///////////////////////////////////// CONSTANTS ////////////////////////////////
    
    ORG_XPATH: {
        ORGANISATION_NAME: "gmd:organisationName/gco:CharacterString",
        INDIVIDUAL_NAME: "gmd:individualName/gco:CharacterString",
        ADDRESS: "gmd:address/gmd:CI_Address/gmd:deliveryPoint/gco:CharacterString",
        CITY: "gmd:address/gmd:CI_Address/gmd:city/gco:CharacterString",
        STATE: "gmd:address/gmd:CI_Address/gmd:administrativeArea/gco:CharacterString",
        POSTAL_CODE: "gmd:address/gmd:CI_Address/gmd:postalCode/gco:CharacterString",
        COUNTRY: "gmd:address/gmd:CI_Address/gmd:country/gco:CharacterString",
        VOICE: "gmd:phone/gmd:CI_Telephone/gmd:voice/gco:CharacterString",
        EMAIL: "gmd:address/gmd:CI_Address/gmd:electronicMailAddress/gco:CharacterString",
        URL: "gmd:onlineResource/gmd:CI_OnlineResource/gmd:linkage/gmd:URL"
    },
    WHITESPACE_REGEXP: new RegExp(/^\s+$/),
    // text box size (larger than max will create TEXTAREA also
    // sets width of TEXTAREA)
    MIN_TEXTINPUT_SIZE: 50,
    MAX_TEXTINPUT_SIZE: 65,// fits abstract textarea on screen in IE (IFrame) and ArcCatalog.
    MIN_TEXTAREA_ROWSIZE: 5,

    // Tekst constanten in het Nederlands
    GLOBAL_DEFAULT: "Klik om te bewerken.",
    GLOBAL_DEFAULT_VIEW: "-",
    DEFAULT_PICKLIST_TEXT: "Klik voor opties",
    DEFAULT_PICKLIST_TEXT_VIEW: "-",

    CONFIRM_DELETE_ELEMENT_TEXT: "Weet u zeker dat u dit element wilt verwijderen?",
    NOT_ALLOWED_DELETE_ELEMENT_TEXT: "Het is niet toegestaan het laatste element van dit type te verwijderen.",

    CONFIRM_DELETE_SECTION_TEXT: "Weet u zeker dat u deze sectie wilt verwijderen?",
    NOT_ALLOWED_DELETE_SECTION_TEXT: "Het is niet toegestaan de laatste sectie van dit type te verwijderen.",

    // expand/collapse section && menu image paths
    PLUS_IMAGE: "images/xp_plus.gif",
    MINUS_IMAGE: "images/xp_minus.gif",
    MENU_IMAGE: "images/arrow.gif",

    PICKLIST_ORGANISATIONS: "picklist_organisations",
    PICKLIST_CONTACTS: "picklist_contacts",
    DYNAMIC_PICKLISTS: [
        "picklist_organisations",
        "picklist_contacts"
    ],

    //TODO is dit nodig?
    BASE_FULL_PATH: (function() {
        // See: http://stackoverflow.com/questions/984510/what-is-my-script-src-url/984656#984656
        var scripts = document.getElementsByTagName("script"),
        script = scripts[scripts.length - 1];

        var scriptSource = (script.getAttribute.length !== undefined) ?
        //FF/Chrome/Safari
        script.src : //(only FYI, this would work also in IE8)
        //IE 6/7/8
        script.getAttribute("src", 4); //using 4 (and not -1) see MSDN http://msdn.microsoft.com/en-us/library/ms536429(VS.85).aspx

        scriptSource = scriptSource.substring(0, scriptSource.lastIndexOf("/")); // the includes dir
        scriptSource = scriptSource.substring(0, scriptSource.lastIndexOf("/") + 1); // the main mde dir (ending with a slash)
        // window.console && console.log("mdeSource: " + scriptSource);
        return scriptSource;
    }()),
    
    ////////////////////////////////////////////////////////////////////////////////    
    //////////////////////////// Afkomstig van subklasse  XSLT /////////////////////
    ////////////////////////////////////////////////////////////////////////////////    

    isInitialized: function() {
        return this.options.xmlHtml !== undefined;
    },

     getChangedElements: function() {
        return this.changedElements;
    },
    
    getSectionChange: function() {
        return this.sectionChange;
    },

    //////////////////////// Adding/deleting elements/sections /////////////////////

    _addElementOrSection: function($elementOrSection, above) {
        
        console.log("add section");
        
        this._showSpinner();
        
        this.sectionChange = {
            action: "add",
            above: above,
            path: $elementOrSection.attr("ui-mde-repeatablepath"),
            endPath: $elementOrSection.attr("ui-mde-fullpath")
        };
        
        this.options.onServerTransformRequired();
    },

    _deleteElementOrSection: function($elementOrSection, notAllowedDeleteText, confirmDeleteText) {

        console.log("delete section");
        
        //Voorlopig via server check, client side check is mooier
        // TODO: add deletable attribute in XSL
        // TODO: check deletable attribute on elementOrSection 

        //if(<deletable attribute is false>) {
        //    this._openErrorDialog(notAllowedDeleteText);
        //    return;
        //}

        // confirm delete
        var returnKey = confirm(confirmDeleteText);
        //this.log("returnKey: " + returnKey);
        if (returnKey == 7 || returnKey === false) {
            return;
        }
        
        this._showSpinner();
        
        this.sectionChange = {
            action: "delete",
            path: $elementOrSection.attr("ui-mde-repeatablepath")
        };
        
        this.options.onServerTransformRequired();
    },
    
    _submitComment: function(event) {
        var comment = $("#ui-mde-comment-textarea", this.element).val();
        
        this.options.commentPosted(comment);

        $("#ui-mde-comment-textarea", this.element).val("").focus();
    },

    ////////////////////////////////////////////////////////////////////////////////    
    //////////////////////////// Widget function overrides /////////////////////////
    ////////////////////////////////////////////////////////////////////////////////    

    _create: function(options) {
        var self = this;
        this.changedElements = [];
        
        $("body").bind("click.mde", function() {
            self.openedMenuNode.hide();
        });
        this.element.addClass("ui-mde");        
    },

    destroy: function() {
        $("body").unbind(".mde"); // only click at the moment
        $(window).unbind(".mde"); // only beforeunload at the moment
        this.element.empty();
        $(this.options.tabContainerSelector).empty();
        $.Widget.prototype.destroy.apply(this, arguments);
    },

    _init: function() {
        mdeGlobal = this;
        
        this.log("Init");
        this.element.data("mdeInstance", this);
        
        this.element.html(this.options.xmlHtml); 

        this._postprocessHtmlDoc();
        var scrollable = this.element.closest(":scrollable");
        var oldScrollTop = scrollable.scrollTop();
        scrollable.scrollTop(oldScrollTop);
    },

    _showSpinner: function(){
        var spinner = $("<img />", {
            src: this.BASE_FULL_PATH + "images/spinner.gif",
            "class": "ui-mde-spinner"
        });
        this.element.html(spinner);
        var scrollable = this.element.closest(":scrollable");
        spinner.position({
            my: "center center",
            at: "center center",
            of: scrollable.length > 0 ? scrollable : $(window)
        });        
    },
//    _handleInputError: function(errorText) {
//        this._openErrorDialog(errorText);
//        if (this.options.viewMode) {
//            // do not show empty document
//            $(".ui-mde-spinner", this.element).remove();
//            return null;
//        }
//        //TODO kan dit zo blijven, waarschijnlijk ook via server doen
//        return this._createXmlDocumentFromString(this.DEFAULT_METADATA_XML);
//    },

    _setOption: function(key, value){
        this.log("_setOption: " + key);

        this.options[key] = value;

        switch (key) {
            case "xmlHtml":
                this._init();
                break;
            case "currentTab":
                this._showTab(value);
                break;
            case "geoTabsMinimized":
                this._getGeoTabs().toggle(!value);
                if (!$("#ui-mde-tabs a[href$='" + this.options.currentTab + "']").is(":visible")) {
                    this._showTab();
                }
                break;
            default:
                $.Widget.prototype._setOption.apply(this, arguments);
                break;
        }

        return this;
    },

    ////////////////////////////////////////////////////////////////////////////////    
    //////////////////////////// Internal functions ////////////////////////////////
    ////////////////////////////////////////////////////////////////////////////////    

    _startEdit: function(event) {
        var self = this;
        //this.log("startEdit");
        var $element = $(event.target);

        // already editing? or for rich text: follow links:
        if ($element.is("a, input:text, textarea, select, option"))
            return true; // do bubbling

        this.openedMenuNode.hide();

        // for rich text: find containing element.
        $element = $element.closest(".ui-mde-value"); // closest can be self
        
        // remove all external links
        $element.closest(".ui-mde-element").find("a.ui-mde-external-link").remove();

        // get current value (for checking if changed later)
        this.preEditText = $.trim(this._getSavedValueOnClientSide($element));
        //this.log("this.preEditText: " + this.preEditText);

        var picklistId = $element.attr("ui-mde-picklist");

        var $inputElement;
        if (!!picklistId) {
            var $picklistElement = this._createPicklist($element);
            //this.log("pickelem");
            //this.log($picklistElement);
            $element.html($picklistElement);

            if (this._isDynamicPicklist(picklistId)) {
                this.log("this._isDynamicPicklist(picklistId)");
                $inputElement = this._createTextInput(event, $element);
                $element.prepend($inputElement);

                // prevent clicking from picklist/inputElement to inputElement/picklist to destroy both:
                $picklistElement.add($inputElement)
                    .mouseover(function() {self.mouseOverMultiInput = true;})
                    .mouseout (function() {self.mouseOverMultiInput = false;});

                $picklistElement.css("margin-left", $inputElement.outerWidth(true) + 5);
                if ($picklistElement.length == 0)
                    $inputElement.focus();
            }

            $picklistElement.focus();
        } else {
            $inputElement = this._createTextInput(event, $element);

            $element.html($inputElement);
            $inputElement.focus(); // will also show the datepicker if this is a date field
        }

        return false;
    },

    _createTextInput: function(event, $element) {
        var self = this;

        // get size from current text
        var iCol, iRow;
        if ($element.attr("ui-mde-type") === "rich-text") {
            iCol = this.MAX_TEXTINPUT_SIZE;
            iRow = Math.max(this.MIN_TEXTAREA_ROWSIZE,
                Math.floor(this.preEditText.length / this.MAX_TEXTINPUT_SIZE) + 1);
        } else if (this.preEditText.length > this.MAX_TEXTINPUT_SIZE) {
            iCol = this.MAX_TEXTINPUT_SIZE;
            iRow = Math.floor(this.preEditText.length / this.MAX_TEXTINPUT_SIZE) + 1;
        } else if (this.preEditText.length > this.MIN_TEXTINPUT_SIZE) {
            iCol = this.preEditText.length;
            iRow = 1;
        } else {
            iCol = this.MIN_TEXTINPUT_SIZE;
            iRow = 1;
        }

        // alt-clicked? if so, force use of textarea
        if (event.altKey) {
            iRow = 4;
            iCol = this.MAX_TEXTINPUT_SIZE;
        }

        var $input;
        if (iRow > 1) {
            $input = $("<textarea />", {
                rows: iRow,
                cols: iCol
            });
        } else {
            $input = $("<input />", {
                "class": "inputfield",
                size: iCol
            });
        }
        

        // check if the element should have autocomplete with thesaurus terms
        // only one thesaurus supported at the moment

        if (this.options.thesauri.length > 0 && this.options.thesauri[0].autocomplete) {

            if($element.attr("ui-mde-fullpath").indexOf("gmd:keyword") != -1) {
                var thesaurus = this.options.thesauri[0];

                var terms = thesaurus.autocomplete;

                this.log("autocomplete " + terms.length + " terms");

                $input
                    .autocomplete({
                        minLength: 2,
                        source: function( request, response ) {
                            // delegate back to autocomplete
                            response( $.ui.autocomplete.filter(
	                            terms, request.term) );
                        },
                        focus: function() {
                            // prevent value inserted on focus
                            return false;
                        },
                        select: function( event, ui ) {
                            this.value = ui.item.value; 
                            return false;
                        }
                    });
            }
        }    
        
        $input
            .val(this.preEditText)
            .keydown(function(event) {return self._checkKey(event);});

        if ($element.attr("ui-mde-field-type") === "date") {
            $input.val(this._convertDate(
                this.preEditText, 
                this.options.storedDateFormat,
                this.options.dateFormat
            ));
            $input.datepicker({
                dateFormat: this.options.dateFormat,
                showAnim: "", // geen show animatie voor de snelheid in IE6 (ja, de MDE wordt nog gebruikt door IE6 gebruikers)
                onClose: function(dateText, inst) {
                    $(this).blur(function(event) {return self._stopEdit(event);});
                    $(this).blur();
                }
            });
        } else {
            $input.blur(function(event) {return self._stopEdit(event);});
        }

        return $input;
    },

    _stopEdit: function(event) {
        
        if($(event.target).hasClass("ui-autocomplete-input")) {
            if($(event.target).data("autocomplete").menu.element.is(":visible")) {
                return true;
            }
        }

        if (this.mouseOverMultiInput) {
            // prevent clicking from picklist/inputElement to inputElement/picklist to destroy both:
            return true; // do bubbling
        }

        var $element = $(event.target).closest(".ui-mde-value");
        var newValue = $(event.target).val();
        //this.log("newValue: " + newValue);

        var fieldType = $element.attr("ui-mde-field-type");
        // check for changed value (from original)
        if (newValue !== this.preEditText &&
            (newValue !== "" || (newValue === "" && this.preEditText !== "")) ) {
            
            var newStoredValue = newValue;
            
            if (fieldType === "date") {
                newStoredValue = this._convertDate(
                    newStoredValue, 
                    this.options.dateFormat, 
                    this.options.storedDateFormat, 
                    $element.attr("ui-mde-fullpath").endsWith("DateTime") || $element.attr("ui-mde-fullpath").endsWith("timePosition")
                );
            }
            
            this._saveValueOnClientSide($element, newStoredValue);
        }

        // is blank? user deleted value? to span default (default value)
        if (newValue === "") {
            newValue = this._getDefaultValue($element);
        }

        var nodeType = $element.attr("ui-mde-type");
        if ($element.attr("ui-mde-picklist") && !this._isDynamicPicklist($element.attr("ui-mde-picklist"))) {
            newValue = this._picklistLocalizedPrettyTitle(newValue);
            //alert(newValue);
        } else if (nodeType === "rich-text") {
            newValue = this._createRichTextValue(newValue);
        } else if (nodeType === "image-url") {
            if (newValue !== this.preEditText) {
                this._showImage(newValue);
            }
        }

        // change span value to text alone; jQuery.text() escapes html tags/entities
        if (nodeType === "rich-text") {
            $element.html(newValue);
        } else {
            $element.text(newValue);
        }
        
        if (fieldType === "url") {
            this._addUrl($element);
        }

        this.preEditText = undefined;

        return false;
    },
    
    _convertDate: function(value, fromFormat, toFormat, toDateTime) {
        try {
            if (value.indexOf("T") > 0)
                value = value.substring(0, value.indexOf("T"));
            var newDate = $.datepicker.parseDate(fromFormat, value);
            if (toDateTime)
                toFormat += "T00:00:00.000";
            return $.datepicker.formatDate(toFormat, newDate);
        } catch(error) {
            this.log(error);
            /*this.log(value);
            this.log(fromFormat);
            this.log(toFormat);
            this.log(toDateTime);*/
            // waarde is niet correct. dit kan alleen voorkomen worden door een input mask op het veld te zetten. dit is geen grote ramp. gebruikers moeten gewoon iets goeds invoeren of anders de datepicker gebruiken.
            return value;
        }
    },

    _checkKey: function(event) {
        //this.log("checkKey");
        var $target = $(event.target);
        var key = event.which;
        //this.log("key: " + key);

        //this.log(element);
        if ($target.is("input")) {
            //this.log("element.value: " + element.value);
            //this.log("this.preEditText: " + this.preEditText);
            if ($target.val() !== this.preEditText) {
                this.options.change(true);
            }
        }

        var abortKeys = [
            $.ui.keyCode.ESCAPE
        ];

        if ($.inArray(key, abortKeys) >= 0) {
            var $element = $target.closest(".ui-mde-value");
            var fieldType = $element.attr("ui-mde-field-type");
            var storedValue = this.preEditText;
            if (fieldType === "date") {
                storedValue = this._convertDate(
                    storedValue,
                    this.options.storedDateFormat,
                    this.options.dateFormat
                );
            }

            $target.val(storedValue);
        }

        var blurKeys = [
            $.ui.keyCode.TAB, 
            $.ui.keyCode.ESCAPE
        ];

        var nextKeys = [
            //$.ui.keyCode.DOWN,
            $.ui.keyCode.TAB
        ];

        var prevKeys = [
            //$.ui.keyCode.UP
            // shift-tab
        ];

        // was 'tab' or down-arrow pressed?
        // huh? can't use 40 for down-arrow, that's the '(' in ArcCatalog. Why?
        //if (iKey = 9 || iKey = 40) {
        if ($.inArray(key, blurKeys) >= 0 || 
            key === $.ui.keyCode.ENTER && $target.is("input")) {
            this.mouseOverMultiInput = false;
            // werkt nog niet 100% ok: aan het einde van een rij/lijst niet ok
            /*var $nextElem = $();
            if ($.inArray(key, nextKeys) >= 0) {
                var $elem = $target.closest(".ui-mde-element");
                if ($elem.next().length > 0) {
                    $nextElem = $(".ui-mde-value", $elem.next());
                }
            }*/
            $target.blur();
            //$nextElem.click();
            return false;
        }
        return true;
    },

    ////////////////////////////////////////////////////////////////////////////////
    //////////////////////////////// Logging functions /////////////////////////////
    ////////////////////////////////////////////////////////////////////////////////

    // IE8/Firebug/Chrome kunnen ook console.info/warn/error aan
    log: function() {
        if (this.options.logMode) {
            var message = arguments[0];
            if (arguments.length > 1)
                message = Array.prototype.join.call(arguments, '; ');

            if (window.console && window.console.log) {
                window.console.log(message);
            } else if (window.opera && window.opera.postError) {
                window.opera.postError(message);
            }
        }
    },


    ////////////////////////////////////////////////////////////////////////////////
    //////////////////////////////// XML processing ////////////////////////////////
    ////////////////////////////////////////////////////////////////////////////////

    _postprocessHtmlDoc: function() {

        this.log("Postprocessing...");
        //TODO CvL
        //this._getOrganisationsJson();
        this._setPrettyPicklistStrings();
        this._setFormattedDates();
        this._createRichTextElements(); 
        this._showImage($(".ui-mde-value[ui-mde-type='image-url']", this.element).first().text());
        this._addUrls();
        this._initGui();
        
        // do not expose the entire mde:
        this.options.afterInit.apply(this.element, []);
    },
    
    //TODO CvL
    // TODO JB. This functions has to be called when new organizations info is added and
    // 'opslaan' is selected. In effect this means that the 'organizations' picklist gets 
    // extended. There is a ticket for this enhancement.  
//    _getOrganisationsJson: function() {
//	this.options.organisations = this.options.getOrganisations();
//
//    },
    
    //////////////////////////////// Rich text /////////////////////////////////////    

    _createRichTextElements: function() {
        var self = this;
        if (this.options.richTextMode) {
            $(".ui-mde .ui-mde-value[ui-mde-type='rich-text']").each(function() {
                self._createRichTextElement($(this));
            });
        }
    },

    _createRichTextElement: function($element) {
        var rawTextValue = this._getSavedValueOnClientSide($element);
        //this.log("rawTextValue: "+rawTextValue);
        var richTextValue = this._createRichTextValue(rawTextValue);
        //this.log("richTextValue: "+richTextValue);
        if (!!richTextValue) {
            $element.html(richTextValue);
        } else {
            // used in "previous comment" blocks, saved value is empty
            $element.html("<p>" + $element.text() + "</p>");
        }
    },

    _createRichTextValue: function(stringValue) {
        if (!stringValue || 0 === stringValue.length) {
            return stringValue;
        }
        // raw rich-text value needs to be escaped first, because we are going to add html tags in wiki2html.
         // we need to keep ' (and ") for wikitext. Therefore no full escaping:
        stringValue = stringValue.replace(/</g, "&lt;").replace(/>/g, "&gt;").replace(/&/g, "&amp;");
        // enige verwijzing naar functies van externe wiki2html.js lib.
        return stringValue.wiki2html();
    },

    /////////////////////////////// Picklists //////////////////////////////////////

    _createPicklist: function($element) {
        var self = this;
        var picklist = this._getPicklist($element)
            .clone()
            .addClass("ui-mde-picklist")
            .keydown(function(event) {return self._checkKey(event);})
            .change(function(event) {return self._selectPicklistValue(event);})
            .blur(function(event) {return self._destroyPicklist(event);})
        ;

        var selectElement = picklist.find('option[value="' + this.preEditText + '"]');
        if (selectElement.length > 0) {
            picklist.val(this.preEditText);
        } else {
            var newTextValue = this.preEditText === "" ? 
            this.DEFAULT_PICKLIST_TEXT : 
            this.preEditText;

            var $newOption = $("<option />", {
                text: newTextValue,
                val: newTextValue
            });

            picklist.prepend($newOption);
            picklist.val(newTextValue);
        }

        return picklist;
    },

    _getPicklist: function($element) {
        var self = this;
        var id = $element.attr("ui-mde-picklist");
        if (!this._isDynamicPicklist(id)) {
            return $("#" + id);
        } else {
            if (id === this.PICKLIST_ORGANISATIONS) {
                return this._createDynamicPicklist(id, function(select) {
                    $.each(self.options.organisations, function(organisationName, organisationContents) {
                        select.append($("<option></option>").attr({
                            value: organisationName,
                            title: organisationName
                        }).text(organisationName));
                    });
                });
            } else if (id === this.PICKLIST_CONTACTS) {
                var section = $element.closest(".ui-mde-section");
                var org = this._findOrganisationContactNode(section, this.ORG_XPATH.ORGANISATION_NAME);
                var orgValue = org.length ? this._getSavedValueOnClientSide(org) : "";
                // check if the organisation exists in the defined picklists
                var orgContent = orgValue in this.options.organisations ? this.options.organisations[orgValue] : null;

                var contacts;
                if (!!orgContent) {
                    // exists; use contacts of this org only.
                    contacts = [];
                    $.each(orgContent.contacts, function(contactName, value) {
                        contacts.push(contactName);
                    });
                } else {
                    // does not exist; use all contacts.
                    contacts = this._getAllContacts();
                }
                return this._createDynamicPicklist(id, function(select) {
                    $.each(contacts, function(index, contactName) {
                        select.append($("<option />", {
                            value: contactName,
                            title: contactName,
                            text: contactName
                        }));
                    });
                });
            } else {
                this.log("dynamicpicklist '" + id + "' not implemented in _getPicklist($element).");
                return null;
            }
        }
    },

    // Description: code called by picklists when selection changed (onchange)
    _selectPicklistValue: function(event) {
        var self = this;

        var $select = $(event.target);
        var $element = $select.closest(".ui-mde-value");
        var picklistId = $select.attr("id");

        var selected = $select.find(":selected");
        var newValue = selected.val();
        var newText = selected.text();
        //this.log("newValue: " + newValue);
        //this.log("newText: " + newText);

        if (this._isDynamicPicklist(picklistId)) {
            var $section = $select.closest(".ui-mde-section");
            switch(picklistId) {
                case this.PICKLIST_ORGANISATIONS: {
                    this._deleteOrganisationContactValue($section, self.ORG_XPATH.INDIVIDUAL_NAME);
                    this._fillOrganisationContactValues($section, newValue, this.options.organisations);
                    break;
                }
                case this.PICKLIST_CONTACTS: {
                    $.each(this.options.organisations, function(organisationName, organisationContents) {
                        if (organisationContents.contacts && organisationContents.contacts[newValue]) {
                            // first fill with organisation values
                            self._fillOrganisationContactValue($section, self.ORG_XPATH.ORGANISATION_NAME, organisationName);
                            self._fillOrganisationContactValues($section, organisationName, self.options.organisations);
                            // then overwrite with contact values
                            self._fillOrganisationContactValues($section, newValue, organisationContents.contacts);
                            return false;
                        }
                        return true;
                    });
                    break;
                }
            }
            this.mouseOverMultiInput = false;
        }

        if (newValue != undefined && // undefined == null
            newValue !== "" &&
            newValue !== this.DEFAULT_PICKLIST_TEXT) {
            $element.text(newText);
            this._saveValueOnClientSide($element, newValue, newText);
        } else {
            $element.text(this.DEFAULT_PICKLIST_TEXT);
        }

        this.preEditText = undefined;

        return false;
    },

    _destroyPicklist: function(event) {
        if (this.mouseOverMultiInput) {
            // prevent clicking from picklist/inputElement to inputElement/picklist to destroy both:
            return true;
        }

        var $parent = $(event.target).parent();
        if (this.preEditText != undefined && // undefined == null
            this.preEditText !== "" && 
            this.preEditText !== this.DEFAULT_PICKLIST_TEXT) {
            this._setPicklistLocalizedPrettyTitle($parent, this.preEditText);
        } else {
            $parent.text(this.DEFAULT_PICKLIST_TEXT).addClass("ui-mde-default-value");
        }

        this.preEditText = undefined;

        return false;
    },

    // Some elements have codes as values that have an associated picklist with localized descriptions.
    _setPrettyPicklistStrings: function() {
        var self = this;
        this.element.find('.ui-mde-value[ui-mde-picklist!=""]').each(function() {
            var $this = $(this);
            if ($this.attr("ui-mde-picklist")) {
                self._setPicklistLocalizedPrettyTitle($this, $this.attr("ui-mde-codelistvalue"));
            }
        });
    },

    _setPicklistLocalizedPrettyTitle: function($element, codeListValue) {
        var picklist = this._getPicklist($element);
        var localizedPrettyTitle = picklist.find('option[value="' + codeListValue + '"]').text();

        if (!localizedPrettyTitle) {
            // We are forgiving in the sense that
            // although no corresponding translated picklist value can be found,
            // we show the original stored value anyway.
            //
            // When the original text is empty, we show a default picklist text.
            // This is useful for empty elements with a picklist that have no default value.
            if (!$.trim(codeListValue)) {
                $element.addClass("ui-mde-default-value");
                if (this.options.viewMode)
                    localizedPrettyTitle = this.DEFAULT_PICKLIST_TEXT_VIEW;
                else
                    localizedPrettyTitle = this.DEFAULT_PICKLIST_TEXT;
            } else {
                localizedPrettyTitle = codeListValue;
            }
        }

        $element.text(localizedPrettyTitle);
    },

    ////////////////////////////// Misc document tweaks ////////////////////////////
    
    _addUrls: function() {
        var self = this;
        this.element.find(".ui-mde-value[ui-mde-field-type=\"url\"]").each(function() {
            self._addUrl($(this));
        })
    },
    
    _addUrl: function($value) {
        if ((this.options.viewMode && $value.text() !== this.GLOBAL_DEFAULT_VIEW) || 
            (!this.options.viewMode && $value.text() !== this.GLOBAL_DEFAULT)) {
            var anchorOptions = {
                "class": "ui-mde-external-link",
                html: $("<img />", {
                    src: this.BASE_FULL_PATH + "images/external_link.png",
                    alt: "Klik hier om de link te volgen",
                    title: "Klik hier om de link te volgen"
                })
            }

            var $element = $value.closest(".ui-mde-element");
            var link = $.trim($value.text());
            if (link.startsWith("www")) { // cannot make other assumptions
                link = "http://" + link;
                $.extend(anchorOptions, {target: "_blank"});
            } else if ((link.charAt(1) === ':' && link.charAt(2) === '\\') || link.startsWith("\\\\")) { // Windows path or UNC path
                // not downloadable/startable (yet). Switch intranet settings on?
                // in FF probably(?): http://kb.mozillazine.org/Links_to_local_pages_do_not_work
                // in IE: zones(?).
                link = "file:///" + (link.replace(/\\/g, "/"));
            } else { // normal url
                $.extend(anchorOptions, {target: "_blank"});
            }
            link = encodeURI(link);
            $.extend(anchorOptions, {href: link});
            $element.append($("<a />", anchorOptions));
        }
    },

    _setFormattedDates: function() {
        var self = this;
        // gco:Date, gco:DateTime, dc:date and gml:timePosition. 
        // Prefices omitted for flexibility in prefix changes in stylesheets
        $(".ui-mde-value[ui-mde-fullpath$=\"Date\"], \
           .ui-mde-value[ui-mde-fullpath$=\"DateTime\"], \
           .ui-mde-value[ui-mde-fullpath$=\"date\"], \
           .ui-mde-value[ui-mde-fullpath$=\"timePosition\"]", this.element)
            .each(function(i, value) {
                var $this = $(this);
                var text = $this.text();
                if (text && text !== $this.attr("ui-mde-default") && text !== self.GLOBAL_DEFAULT_VIEW) {
                    $this.text(self._convertDate(
                        text, 
                        self.options.storedDateFormat,
                        self.options.dateFormat
                    ));
                }
            });
    },
    ////////////////////////////////// Misc ////////////////////////////////////////    

    _encodeNewLines: function(value) {
        if (typeof value == "undefined" || value === null || value === "")
            return "";

        value = $.trim(value);

        // nodig voor IE. IE maak van \n input \r\n output. Tweede lijn is voor compatibiliteit met *nix.
        value = value.replace(/\r\n/g, "\n");
        value = value.replace(/\r/g, "\n");
        value = value.replace(/\n/g, "\\n");

        return value;
    },
    _decodeNewLines: function(value) {
        if (typeof value == "undefined" || value === null || value === "")
            return "";

        value = $.trim(value);

        // nodig voor IE. IE maak van \n input \r\n output. Tweede lijn is voor compatibiliteit met *nix.
        value = value.replace(/\\n/g, "\n");

        return value;
    },

    _showImage: function(url) {
        var start = url.substr(0, 4);
        //var start = url.substring(0, url.indexOf(":"));
        if (start === "http" || start === "ftp:") { // om te testen:  || start === "file"
            $(".preview-image", this.element).remove();
            var image = $("<img></img>").attr({
                src: url,
                height: 150
            }).css({
                width: "auto"
            }).addClass("preview-image");
            if (this.options.iso19115PreviewImageInsideGeotab) {
                var tab = $("#iso19115").length > 0 ? $("#iso19115") : $("#overzicht");
                tab.prepend(image.css("float", "right"));
            } else {
                $("#edit-doc-root", this.element).before(image);
            }
        }
    },

    _openErrorDialog: function(htmlMessage) {
        this.log("error: " + htmlMessage);
        $(".ui-mde-spinner", this.element).remove();
        $("<div/>").html(htmlMessage).appendTo(document.body).dialog({
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
    },

    ////////////////////////////////////////////////////////////////////////////////
    ///////////////////////////////// GUI //////////////////////////////////////////
    ////////////////////////////////////////////////////////////////////////////////

    _initGui: function() {
        this.log("Initializing gui with view mode: " + this.options.viewMode);

        var self = this;
        
        if (this.options.tabContainerSelector !== "#ui-mde-tabs-container") {
            var tabs = $("#ui-mde-tabs-container").html();
            $(this.options.tabContainerSelector).html(tabs);
            $("#ui-mde-tabs-container").remove();
        }
        $("#ui-mde-tabs > li").hover(function() {
            $(this).add("a", this).toggleClass("ui-mde-tab-hover");
        });
        $("#ui-mde-tabs > li").click(function() {
            self._showTab($(this).find("a"));
            return false;
        });
        $("#ui-mde-tabs > li > a").click(function() {
            self._showTab(this);
            return false;
        });
        if (this.options.geoTabsMinimizable) {
            var geoTabsToggleContainer = $("<div />", {
                id: "ui-mde-geoTabsToggle-container"
            });
            var geoTabsCheckbox = $("<input type='checkbox' />") // ', {}'-notatie niet mogelijk hier; jq bug? vliegt eruit in FF zonder foutmelding.
            .attr({
                id: "ui-mde-geoTabsToggle",
                checked: !self.options.geoTabsMinimized
            })
            .click(function(event) {
                self.log("geoTabsCheckbox: " + geoTabsCheckbox);
                self.option("geoTabsMinimized", !self.options.geoTabsMinimized);
            })
            ;
            var geoTabsLabel = $("<label />", {
                "for": "ui-mde-geoTabsToggle",
                text: "Geografische tabs"
            });
            geoTabsToggleContainer.append(geoTabsCheckbox, geoTabsLabel);
            $(this.options.tabContainerSelector).append(geoTabsToggleContainer);

            this.option("geoTabsMinimized", this.options.geoTabsMinimized);
        }

        this._showTab(this.options.currentTab);
                
        $(".ui-mde-comment-date", this.element).each(function() {
            var theDate = $.datepicker.parseDate("yy-mm-dd", $(this).text());
            $(this).text($.datepicker.formatDate("d-m-yy", theDate));
        });
        $(".ui-mde-comment-content", this.element).each(function() {
            self._createRichTextElement($(this));
        });

        $(".ui-mde-section-header a", this.element).click(function(event) {
            var sectionContent = $(event.target).closest(".ui-mde-section").find(".ui-mde-section-content").first();
            sectionContent.toggle();

            // toggle plus/minus image
            var imgSrc = self.BASE_FULL_PATH + (sectionContent.is(":visible") ? self.MINUS_IMAGE : self.PLUS_IMAGE);
            var newImg = $("<img />").addClass("plus-minus").attr("src", imgSrc);
            $(event.target).closest(".ui-mde-section-header").find("img.plus-minus").replaceWith(newImg);
            return false;
        });
        $(".ui-mde-section-title", this.element).hover(function(event) {
            $(this).toggleClass("ui-mde-section-title-hover");
        });
        $(".menu-wrapper .menu-img", this.element).click(function(event) {
            var $this = $(this);
            var menu = $this.siblings(".menu");

            self.openedMenuNode.hide();
            if (!menu.is(":visible")) {
                self.openedMenuNode = menu.show();
                menu.position({
                    my: "left top",
                    at: "left bottom",
                    of: $this
                });
            }
            return false;
        }).hover(function(event) {
            $(this).toggleClass("menu-img-hover");
        });

        $(".ui-mde-wiki-help-link").click(function(event) {
            var w = window.open(self.options.wiki2htmlHelpUrl, "wikihelp", "width=800, height=600, toolbar=no, scrollbars=yes, status=no, location=no");
            //w.focus(); //IE11: Kan de eigenschap focus van een niet-gedefinieerde verwijzing of een verwijzing naar een lege waarde niet ophalen
            return false;
        });
        
        $("#ui-mde-comment-textarea").wrap($("<div>").addClass("ui-mde-textarea-wrapper"));

        if (!this.options.viewMode) {
            if (this.options.thesauri.length > 0) {
                $(".ui-mde-section[ui-mde-fullpath$=\"gmd:descriptiveKeywords\"] .ui-mde-section-header", this.element)
                    .first().append($("<a />", {
                        href: this.options.thesauri[0].url,
                        html: this.options.thesauri[0]._name,
                        target: "_blank",
                        title: "Link naar thesaurus",
                        "class": "ui-mde-thesaurus-link"
                    }));
            }
            
            //$(".ui-mde-value").click(function(event) {
            $(".ui-mde-clickable").click(function(event) {
                self.log(".ui-mde-value click");
                return self._startEdit(event);
            });

        }

        if (!this.options.viewMode) {

            var sectionMenus = $(".ui-mde-section[ui-mde-fullpath] .ui-mde-section-header .menu-wrapper", this.element);
            sectionMenus.find(".menuaddabove a").click(function(event) {
                self._addElementOrSection($(this).closest(".ui-mde-section"), true);
                return false;
            });
            sectionMenus.find(".menuaddbelow a").click(function(event) {
                self._addElementOrSection($(this).closest(".ui-mde-section"), false);
                return false;
            });
            sectionMenus.find(".menudelete a").click(function(event) {
                self._deleteElementOrSection($(this).closest(".ui-mde-section"), self.NOT_ALLOWED_DELETE_ELEMENT_TEXT, self.CONFIRM_DELETE_ELEMENT_TEXT);
                return false;
            });

            var elementMenus = $(".ui-mde-element .menu-wrapper", this.element);
            elementMenus.find(".menuaddabove a").click(function(event) {
                self._addElementOrSection($(this).closest(".ui-mde-element").find(".ui-mde-value"), true);
                return false;
            });
            elementMenus.find(".menuaddbelow a").click(function(event) {
                self._addElementOrSection($(this).closest(".ui-mde-element").find(".ui-mde-value"), false);
                return false;
            });
            elementMenus.find(".menudelete a").click(function(event) {
                self._deleteElementOrSection($(this).closest(".ui-mde-element").find(".ui-mde-value"), self.NOT_ALLOWED_DELETE_SECTION_TEXT, self.CONFIRM_DELETE_SECTION_TEXT);
                return false;
            });

            $("#ui-mde-comment-submit", this.element).button().click(function(event) {
                self._submitComment(event);
                return false;
            });
        }

    },

    _getGeoTabs: function() {
        return $("a[href$='#overzicht'],\
                 a[href$='#specificaties'],\
                 a[href$='#iso19115'],\
                 a[href$='#iso19119'],\
                 a[href$='#service'],\
                 a[href$='#mdcommon'],\
                 a[href$='#attributen']", "#ui-mde-tabs").parent();
    },

    _showTab: function(aElem) {
        var self = this;
        if (!aElem || (typeof aElem === "string" && $(this._getBracketNormalizedHref(aElem)).length == 0)) {
            aElem = $("#ui-mde-tabs > li > a:visible").first(); //default tab
        }

        $("#ui-mde-tabs > li > a").each(function() {
            $(this).parent().removeClass("ui-mde-tab-selected");
            $(self._getBracketNormalizedHref($(this).attr("href"))).hide();
        });

        var tabAnchor;
        if (typeof aElem === "string") {
            this.options.currentTab = this._getBracketNormalizedHref(aElem);
            tabAnchor = $("#ui-mde-tabs > li > a[href$='" + this.options.currentTab + "']");
        } else { // DOM node or jQuery wrapper
            this.options.currentTab = this._getBracketNormalizedHref($(aElem).attr("href"));
            tabAnchor = $(aElem);
        }
        tabAnchor.parent().addClass("ui-mde-tab-selected");
        $(this.options.currentTab).show();
    },

    // IE 6 and 7 turn a href into an absolute path
    _getBracketNormalizedHref: function(href) {
        return href.substring(href.indexOf("#")); // find first #
    },

    //////////////////////////////// Save values ///////////////////////////////////

    _getDefaultValue: function($element) {
        // as a side effect, we also set the node's class to "ui-mde-default-value"
        $element.removeClass("ui-mde-changed-value").addClass("ui-mde-default-value");

        var defaultValue;
        if ($element.closest(".ui-mde-element").hasClass("ui-mde-element-ro")) {
            defaultValue = this.GLOBAL_DEFAULT_VIEW;
        } else if ($element.attr("ui-mde-default")) {
            defaultValue = $element.attr("ui-mde-default");
        } else {
            defaultValue = this.GLOBAL_DEFAULT;
        }
        return defaultValue;
    },

    _getSavedValueOnClientSide: function($element) {
        var savedValue = xmlUnescape($element.attr("ui-mde-current-value"));
        this.log("_getSavedValueOnClientSide (voor decode): " + savedValue);
        savedValue = this._decodeNewLines(savedValue);
        this.log("_getSavedValueOnClientSide (na decode): " + savedValue);
        return savedValue;
    },

    _saveValueOnClientSide: function($element, newValue, newText) {
        //this.log($element);
        var path = $element.attr("ui-mde-fullpath");
	//this.log(path);
        var attrName = $element.attr("attrname");
        //this.log(attrName);
        
        this.log("_saveValueOnClientSide (voor decode): " + newValue);
        newValue = this._encodeNewLines(newValue);
        newText = this._encodeNewLines(newText);
        this.log("_saveValueOnClientSide (na decode): " + newValue);

        var change = {
            path: path,
            attrName: attrName,
            newValue: newValue,
            newText: newText
        };
        this.changedElements.push(change);

        $element.attr("ui-mde-current-value", xmlEscape(newValue));
        $element.removeClass("ui-mde-default-value").addClass("ui-mde-changed-value");

        this.options.change(true);
    },

    //////////////////////////// Contacts and organizations ////////////////////////

    _getAllContacts: function() {
        var contacts = [];
        this._eachContact(function(contactName, contactContents) {
            contacts.push(contactName);
        });
        contacts.sort();
        return contacts;
    },

    _eachContact: function(callback) {
        $.each(this.options.organisations, function(organisationName, organisationContents) {
            if (organisationContents.contacts) {
                $.each(organisationContents.contacts, function(contactName, contactContents) {
                    callback(contactName, contactContents);
                });
            }
        });
    },

    _createDynamicPicklist: function(id, fillPicklistCallback) {
        var self = this;
        var select = $("<select/>", {
            id: id,
            "class": "ui-mde-picklist",
            keydown: function(event) {return self._checkKey(event);},
            change: function(event) {return self._selectPicklistValue(event);},
            blur: function(event) {return self._destroyPicklist(event);}
        });
        fillPicklistCallback(select);
        return select;
    },

    _isDynamicPicklist: function(id) {
        return $.inArray(id, this.DYNAMIC_PICKLISTS) >= 0;
    },

    _fillOrganisationContactValues: function($section, newValue, contentsObject) {
        if (typeof contentsObject != "undefined") {
            var newOrgContact = contentsObject[newValue];
            if (!!newOrgContact) {
                this._fillOrganisationContactValue($section, this.ORG_XPATH.ADDRESS, newOrgContact.address);
                this._fillOrganisationContactValue($section, this.ORG_XPATH.CITY, newOrgContact.city);
                this._fillOrganisationContactValue($section, this.ORG_XPATH.STATE, newOrgContact.state);
                this._fillOrganisationContactValue($section, this.ORG_XPATH.POSTAL_CODE, newOrgContact.postalCode);
                this._fillOrganisationContactValue($section, this.ORG_XPATH.COUNTRY, newOrgContact.country);
                this._fillOrganisationContactValue($section, this.ORG_XPATH.VOICE, newOrgContact.voice);
                this._fillOrganisationContactValue($section, this.ORG_XPATH.EMAIL, newOrgContact.email);
                this._fillOrganisationContactValue($section, this.ORG_XPATH.URL, newOrgContact.url);
            }
        }
    },


    _fillOrganisationContactValue: function($section, xpathEnd, newValue) {
        var $node = this._findOrganisationContactNode($section, xpathEnd);
        if (newValue && $node.length) {
            this._saveValueOnClientSide($node, newValue);
            
            // Line beneath has a effect that when an organization is selected in 
            // a certain tab that all relevant fields in the mde for this tab. 
            $node.text(newValue); 
        }
    },

    _deleteOrganisationContactValue: function($section, xpathEnd) {
        var $node = this._findOrganisationContactNode($section, xpathEnd);
        if ($node.length > 0) {
            this._saveValueOnClientSide($node, "");
            $node.text(this._getDefaultValue($node));
        }
    },

    _findOrganisationContactNode: function($section, xpath) {
        return $section.find(".ui-mde-value[ui-mde-fullpath$='" + RegExp.escape(xpath) + "']");
    }
});

$.extend($.expr[":"], {
    scrollable: function(element) {
        return  $.inArray($(element).css("overflow" ), ["scroll", "auto"]) != -1 ||
        $.inArray($(element).css("overflowX"), ["scroll", "auto"]) != -1 ||
        $.inArray($(element).css("overflowY"), ["scroll", "auto"]) != -1;
    }
});

})(jQuery);

// TODO: deze 3 functies hieronder moet eigenlijk netter geregeld worden:
String.prototype.startsWith = function(str) {
    return (this.match("^" + str) == str);
}

String.prototype.endsWith = function(str) {
    return (this.match(str + "$") == str);
}

// http://simonwillison.net/2006/Jan/20/escape/
// Used for example for escaping the file/dirname in the "a" rel-attribute.
// It can then be put in a jQuery selector.
RegExp.escape = function(text) {
    return text.replace(/[-[\]{}()*+?.,\\^$|#\s]/g, "\\$&");
}

function xmlUnescape(sXml){
    if (typeof sXml == "undefined" || sXml === null || sXml === "")
        return "";
    return sXml.replace(/&apos;/g,"'").replace(/&quot;/g,"\"").replace(/&gt;/g,">").replace(/&lt;/g,"<").replace(/&amp;/g,"&");
}

function xmlEscape(sXml) {
    if (typeof sXml == "undefined" || sXml === null || sXml === "")
        return "";
    return sXml.replace(/&/g, '&amp;').replace(/</g, '&lt;').replace(/>/g, '&gt;').replace(/"/g, '&quot;').replace(/'/g, '&apos;');
};
