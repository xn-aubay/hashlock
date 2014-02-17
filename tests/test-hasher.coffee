SiteOptions = require("./options").SiteOptions
PasswordHasher = require("./hasher").PasswordHasher


exports['test getHash'] = (assert) ->
  config = new SiteOptions("5DB6DAF0-8F1D-4FB2-9845-F3E2390FB5BB", 12, "alnum", "test")
  hasher = new PasswordHasher

  result = hasher.getHash(config, "password")

  assert.strictEqual "JNiDEjUp0oKs", result, "Resulting hash differs"

require("sdk/test").run(exports)
