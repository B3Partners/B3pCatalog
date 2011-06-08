// values and functions in this file can be overridden in a deploy script

if (typeof B3pCatalog == "undefined") B3pCatalog = {};

// used for all mde types (view/edit/etc.) for all users.
B3pCatalog.basicMdeOptions = {
    richTextMode: true,
    extraTitleAboveTabs: false,
    iso19115PreviewImageInsideGeotab: true,
    tabContainerSelector: "#mde-tabs"
};

// used for a non-csw editor/viewer
B3pCatalog.getExtraMdeOptions = function(isGeo, viewMode) {
    var extraOptions = {
        profile: "nl_md_1.2_with_fc",
        dcMode: true,
        dcPblMode: true,
        synchroniseDC: true,
        iso19115oneTab: true,
        commentMode: true
    };
    
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
    
    return extraOptions;
}

// called after a non-csw editor/viewer is created
B3pCatalog.afterInit = function(isGeo, viewMode) {
    
}

