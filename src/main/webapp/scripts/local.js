

function LocalAccess() {
    this.appletInitialized = false;
    
    //this.CALLBACK = "LocalAccess_callback";
    //this.ERROR_CALLBACK = "LocalAccess_errorCallback";
    this.id = "local_access_applet";
}

LocalAccess.prototype.getApplet = function() {
    return document.getElementById(this.id);
}
    
    /*
    this.callApplet = function(method, params, callback, errorCallback) {
        var requestId = method + "_" + LocalAccess_callbackIndex++;
        LocalAccess_callbacks[requestId] = {success: callback, error: errorCallback};
        
        
        var realParams = params.concat(requestId, this.CALLBACK, this.ERROR_CALLBACK);

        this.getApplet()[method].apply(this.getApplet(), realParams);
    }
    */
   
LocalAccess.prototype.callApplet = function() {
    var method = arguments[0];
    var params = Array.prototype.slice.call(arguments,1);

    var callId = localAccessCallbackIndex++;

    // Passing actual function closures does not work properly through
    // LiveConnect
    var functions = [];
    for(var i in params) {
        var param = params[i];

        if(typeof param == "function") {
            params[i] = callId + "-" + functions.length;
            functions.push(param);
        }                
    }
    if(functions.length > 0) {
        localAccessCallbacks[callId] = functions;
    }
    
    // XXX bug with IE LiveConnect throws NoSuchFieldException with the following line:
    // this.getApplet()[method].apply(this.getApplet(), params);
    // switch statement is needed as Function.apply() does not work...

    switch(method) {
        case "selectDirectory":
            this.getApplet().selectDirectory(params[0], params[1], params[2]);
            break;
        case "listDirectory":
            this.getApplet().listDirectory(params[0], params[1], params[2]);
            break;
        case "readFileUTF8":
            this.getApplet().readFileUTF8(params[0], params[1], params[2]);
            break;
        case "writeFileUTF8":
            this.getApplet().writeFileUTF8(params[0], params[1], params[2], params[3]);
            break;
        case "getShapefileMetadata":
            this.getApplet().getShapefileMetadata(params[0], params[1], params[2]);
            break;
        case "getNCDump":
            this.getApplet().getNCDump(params[0], params[1], params[2]);
            break;
        case "getNCML":
            this.getApplet().getNCML(params[0], params[1], params[2]);
            break;
        case "setNCTitle":
            this.getApplet().setNCTitle(params[0], params[1], params[2], params[3]);
            break;
        default:
    }
}

var localAccessCallbackIndex = 0;
var localAccessCallbacks = {};

function localAccessAppletCallback() {
    var magic = arguments[0].split("-");
    
    var callId = magic[0];
    var index = magic[1];
    
    var args = Array.prototype.slice.call(arguments,1);
    localAccessCallbacks[callId][index].apply(this, args);
    
    // Java applet should only call a single callback
    // if more callbacks are needed we need an extra parameter to tell it is the
    // last so we can delete the functions to prevent memory buildup of callbacks
    delete localAccessCallbacks[callId];        
}

// Because the applet uses a worker thread, these callbacks may be called out-of-order
//var LocalAccess_callbacks = { };
//var LocalAccess_callbackIndex = 0;



/*
function LocalAccess_callback() {
    var requestId = arguments[0];
    var args = Array.prototype.slice.call(arguments,1);  
    LocalAccess_callbacks[requestId].success.apply(this, args);
    delete LocalAccess_callbacks[requestId];
}

function LocalAccess_errorCallback() {
    var requestId = arguments[0];
    var args = Array.prototype.slice.call(arguments,1);    
    LocalAccess_callbacks[requestId].error.apply(this, args);
    delete LocalAccess_callbacks[requestId];
}*/

var localAccessAppletLoaded = function() {};

LocalAccess.prototype.initApplet = function(codeArchivePath, placeholderId, callback) {
    if(this.appletInitialized) {
        return;
    }
    
    this.appletInitialized = true;
    
    if(callback) {
        localAccessAppletLoaded = callback;
    }
    
    var attributes = {
        id:         this.id,
        code:       "nl.b3p.applet.local.LocalAccessApplet",
        archive:    codeArchivePath + "/local-access-applet.jar, " + codeArchivePath + "/ncCore-4.2.jar",
        width:      document.getElementById(placeholderId).scrollWidth,
        height:     document.getElementById(placeholderId).scrollHeight,
        placeholder: placeholderId
    };
    var parameters = {classloader_cache:"false", jnlp_href: codeArchivePath + "/launch.jnlp"}; 
    var version = "1.6"; 
    deployJava.runApplet(attributes, parameters, version);    
}

/*
LocalAccess.prototype.selectDirectory = function(title, callback, errorCallback) {
    var requestId = "sd" + LocalAccess_callbackIndex++;
    LocalAccess_callbacks[requestId] = {success: callback, error: errorCallback};
    this.getApplet().selectDirectory(title, requestId, this.CALLBACK, this.ERROR_CALLBACK);
}

LocalAccess.prototype.listDirectory = function(dir, callback, errorCallback) {
    var requestId = "ld" + LocalAccess_callbackIndex++;    
    LocalAccess_callbacks[requestId] = {success: callback, error: errorCallback};
    this.getApplet().listDirectory(dir, requestId, this.CALLBACK, this.ERROR_CALLBACK);
}

LocalAccess.prototype.readFileUTF8 = function(file, callback, errorCallback) {
    var requestId = "r" + LocalAccess_callbackIndex++;    
    LocalAccess_callbacks[requestId] = {success: callback, error: errorCallback};
    this.getApplet().readFileUTF8(file, requestId, this.CALLBACK, this.ERROR_CALLBACK);
}

function LocalAccess_notFoundCallback() {
    var requestId = arguments[0];
    var args = Array.prototype.slice.call(arguments,1);    
    LocalAccess_callbacks[requestId].notFound.apply(this, args);
    delete LocalAccess_callbacks[requestId];
}

LocalAccess.prototype.readFileIfExistsUTF8 = function(file, callback, notFoundCallback, errorCallback) {
    var requestId = "rfnf" + LocalAccess_callbackIndex++;    
    LocalAccess_callbacks[requestId] = {success: callback, error: errorCallback, notFound: notFoundCallback};
    this.getApplet().readFileIfExistsUTF8(file, "LocalAccess_notFoundCallback", requestId, this.CALLBACK, this.ERROR_CALLBACK);
}

LocalAccess.prototype.writeFileUTF8 = function(file, content, callback, errorCallback) {
    var requestId = "w" + LocalAccess_callbackIndex++;    
    LocalAccess_callbacks[requestId] = {success: callback, error: errorCallback};
    this.getApplet().writeFileUTF8(file, content, requestId, this.CALLBACK, this.ERROR_CALLBACK);
}

LocalAccess.prototype.getShapefileMetadata = function(file, callback, errorCallback) {
    var requestId = "sm" + LocalAccess_callbackIndex++;
    LocalAccess_callbacks[requestId] = { success: callback, error: errorCallback };
    this.getApplet().getShapefileMetadata(file, requestId, this.CALLBACK, this.ERROR_CALLBACK);
}

//LocalAccess.prototype.selectDirectory2 = function(title, callback, errorCallback) {
//    this.callApplet("selectDirectory2", [ file ], callback, errorCallback);
//}
LocalAccess.prototype.getNetCDFMetadata = function(file, callback, errorCallback) {
    this.callApplet("getNetCDFMetadata", [ file ], callback, errorCallback);
}*/