crypto = require("./crypto")


exports['test sha1'] = (assert) ->
  result = crypto.hex_sha1("test")

  assert.strictEqual "a94a8fe5ccb19ba61c4c0873d391e987982fbbd3", result


require("sdk/test").run(exports)
