// values and functions in this file can be overridden in a deploy script

if (typeof B3pCatalog == "undefined") B3pCatalog = {};

// used for all mde types (view/edit/etc.) for all users.
B3pCatalog.basicMdeOptions = {
    logMode: true,
    richTextMode: true,
    iso19115PreviewImageInsideGeotab: true,
    tabContainerSelector: "#page-tabs",
    //TODO CvL: deze mag weg
    organisations: organisations
};

// used for a non-csw editor/viewer
B3pCatalog.getExtraMdeOptions = function(isGeo, viewMode) {
    var extraOptions = {
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
    
};

