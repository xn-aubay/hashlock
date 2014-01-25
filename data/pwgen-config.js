// Configuration container for content scripts

var pwgen_current_config = {
    'key': '',
    'site': '',
    'length': 1
};

if (self && self.port) {
    self.port.on('config', function(config){
        pwgen_current_config['key'] = config['key'];
        pwgen_current_config['site'] = config['site'];
        pwgen_current_config['length'] = config['length'];
    });
}
