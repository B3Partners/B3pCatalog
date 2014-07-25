// values and functions in this file can be overridden in a deploy script

if (typeof B3pCatalog == "undefined") B3pCatalog = {};

// used for all mde types (view/edit/etc.) for all users.
B3pCatalog.basicMdeOptions = {
    logMode: true,
    richTextMode: true,
    extraTitleAboveTabs: false,
    iso19115PreviewImageInsideGeotab: true,
    tabContainerSelector: "#page-tabs",
    //TODO CvL: deze mag weg
    organisations: organisations
};

// used for a non-csw editor/viewer
B3pCatalog.getExtraMdeOptions = function(isGeo, viewMode) {
    var extraOptions = {
       //TODO CvL: dit moet via config.xml
//        fcMode: true,
//        iso19115oneTab: true,
//        commentMode: true,
        afterInit: B3pMde.afterInit
    };
    
    if (typeof isGeo === "boolean" && !isGeo) {
        $.extend(extraOptions, {
        //TODO CvL: dit moet via config.xml
//            dcMode: true,
//            dcPblMode: true,
            geoTabsMinimizable: true,
            geoTabsMinimized: true
        });
    }
    if (typeof viewMode === "boolean") {
        $.extend(extraOptions, {
            viewMode: viewMode
        });
        //TODO CvL: dit moet via extra preprocessor in config.xml
//        if (!viewMode) {
//            $.extend(extraOptions, {
//                extraPreprocessors: [
//                    "preprocessors/preprocessorWSRL.xsl"
//                ]
//            });
//        }
    }
    
    return extraOptions;
}
