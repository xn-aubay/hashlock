// Generated by CoffeeScript 1.4.0
(function() {
  var crypto;

  crypto = require("./crypto");

  exports['test sha1'] = function(assert) {
    var result;
    result = crypto.hex_sha1("test");
    return assert.strictEqual("a94a8fe5ccb19ba61c4c0873d391e987982fbbd3", result);
  };

  require("sdk/test").run(exports);

}).call(this);
