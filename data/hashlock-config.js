// Configuration container for content scripts

var hashlock_current_config = {
    'key': '',
    'site': '',
    'length': 1
};

if (self && self.port) {
    self.port.on('config', function(config){
        hashlock_current_config['key'] = config['key'];
        hashlock_current_config['site'] = config['site'];
        hashlock_current_config['length'] = config['length'];
    });
}
