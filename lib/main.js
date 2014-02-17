// The main module of the HashLock Add-on.

var Widget = require("sdk/widget").Widget;
var Panel = require("sdk/panel").Panel;
var data = require("sdk/self").data;
var PageMod = require("sdk/page-mod").PageMod;
var SimplePrefs = require('sdk/simple-prefs');
var tabs = require("sdk/tabs");

var config_panel = null;
var page_mod = null;
var default_config = null;

function dispatchConfig() {
    if (default_config) {
        if (config_panel) {
            config_panel.port.emit('config', default_config);
        }
    }
}

function generate_guid () {
    return 'xxxxxxxx-xxxx-4xxx-yxxx-xxxxxxxxxxxx'.replace (/[xy]/g, function(c) {
        var r = Math.random ()*16|0, v = c == 'x' ? r : (r&0x3|0x8);
        return v.toString (16);
    }).toUpperCase ();
}

function loadConfig() {
    var prefs = SimplePrefs.prefs;
    
    // setup initial values
    if (prefs['key'] == '') {
        prefs['key'] = generate_guid();
    }
    
    default_config = {
        'key': prefs['key'],
        'length': prefs['length'],
        'site': 'generic'
    };
    
    // watch for changes
    SimplePrefs.on("key", function(){
        default_config['key'] = prefs['key'];
        dispatchConfig();
    });
    SimplePrefs.on("length", function(){
        if (prefs['length'] < 1) {
            prefs['length'] = 1;
        }
        default_config['length'] = prefs['length'];
        dispatchConfig();
    });
    
    dispatchConfig();
}

function getsite(url) {
    //console.log("hashlock getsite : "+url);
    var reg = new RegExp("^https?://([^:/]+\\.)?([^.:/]+)\\.([a-z]{2,5})(:\\d+)?/.*$");
    var m = reg.exec(url);
    try {
        if ("" == m[2]) {
            throw 'generic';
        }
        return m[2];
    } catch (e) {
        return 'generic';
    }
}

exports.main = function() {

    config_panel = Panel({
        width: 400,
        height: 200,
        contentURL: data.url('popup.html'),
        contentScriptFile: [
            data.url("jquery-2.0.3.min.js"),
            data.url("sha1.js"),
            data.url("hashlock-config.js"),
            data.url("hashlock-hashing.js"),
            data.url("hashlock-input.js"),
            data.url("hashlock-popup.js")
        ]
    });
    
    new Widget({
        id: "hashlock-widget",
        label: "HashLock",
        contentURL: data.url("images/hashlock.png"),
        panel: config_panel
    });
    
    // Content script on any page
    page_mod = PageMod({
        include: "*",
        contentScriptFile: [
            data.url("jquery-2.0.3.min.js"),
            data.url("sha1.js"),
            data.url("hashlock-config.js"),
            data.url("hashlock-hashing.js"),
            data.url("hashlock-input.js"),
            data.url("hashlock-webpage.js")
        ],
        onAttach: function(worker) {
            var dispatch = function(){
                var config = {
                    'key': default_config['key'],
                    'length': default_config['length'],
                    'site' : getsite(worker.url)
                };
                worker.port.emit('config', config);
            };
            var tab = worker.tab;
            tab.on('pageshow', dispatch);
            worker.on('detach', function(){
                tab.removeListener('pageshow', dispatch);
            });
            dispatch();
        }
    });
    
    loadConfig();
};
