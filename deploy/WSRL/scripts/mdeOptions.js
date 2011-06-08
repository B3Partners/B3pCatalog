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
        //synchroniseDC: true,
        iso19115oneTab: true,
        commentMode: true,
        afterInit: B3pMde.afterInit
    };
    
    if (typeof isGeo === "boolean" && !isGeo) {
        $.extend(extraOptions, {
            dcMode: true,
            dcPblMode: true,
            geoTabsMinimizable: true,
            geoTabsStartMinimized: true
        });
    }
    if (typeof viewMode === "boolean") {
        $.extend(extraOptions, {
            viewMode: viewMode
        });
        if (!viewMode) {
            $.extend(extraOptions, {
                extraPreprocessors: [
                    "preprocessors/preprocessorWSRL.xsl"
                ]
            });
        }
    }
    
    return extraOptions;
}
