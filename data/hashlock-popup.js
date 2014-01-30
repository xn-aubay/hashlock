// Script to handle the config popup

$(function(){
    
    // Fill global config
    self.port.on("config", function(config){
        $("#inputKey").val(config['key']);
    });

    // Setup the test area
    hashlockBindToInput($("#inputTest"));
})

