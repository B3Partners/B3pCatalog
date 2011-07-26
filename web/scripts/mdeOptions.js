// values and functions in this file can be overridden in a deploy script

if (typeof B3pCatalog == "undefined") B3pCatalog = {};

// used for all mde types (view/edit/etc.) for all users.
B3pCatalog.basicMdeOptions = {
    synchroniseEsri: false,
    logMode: true,
    richTextMode: true,
    extraTitleAboveTabs: false,
    iso19115PreviewImageInsideGeotab: true,
    tabContainerSelector: "#mde-tabs",
    organisations: organisations
};

// used for a non-csw editor/viewer
B3pCatalog.getExtraMdeOptions = function(isGeo, viewMode) {
    var extraOptions = {
        fcMode: true,
        dcMode: true,
        dcPblMode: true,
        synchroniseDC: true,
        iso19115oneTab: true,
        commentMode: true,
        afterInit: B3pMde.afterInit
    };
    
    if (typeof isGeo === "boolean" && !isGeo) {
        $.extend(extraOptions, {
            geoTabsMinimizable: true,
            geoTabsMinimized: true
        });
    }
    if (typeof viewMode === "boolean") {
        $.extend(extraOptions, {
            viewMode: viewMode
        });
    }
    
    return extraOptions;
}

