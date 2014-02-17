SiteOptions = require("./options").SiteOptions


exports['test constructor'] = (assert) ->
  options = new SiteOptions()
  assert.strictEqual 36, options.private_key.length
  assert.strictEqual 12, options.length
  assert.strictEqual "alnum", options.char_mode
  assert.strictEqual null, options.site_tag
  assert.strictEqual 0, options.bump


exports['test generatePrivateKey'] = (assert) ->
  result = SiteOptions.generatePrivateKey()
  assert.equal "string", typeof result
  assert.equal 36, result.length


exports['test getFullTag'] = (assert) ->
  options = new SiteOptions("xxx", 12, "alnum", null)
  assert.strictEqual "generic", options.getFullTag()

  options = new SiteOptions("xxx", 12, "alnum", "thunderk")
  assert.strictEqual "thunderk", options.getFullTag()

  options = new SiteOptions("xxx", 12, "alnum", "thunderk", 0)
  assert.strictEqual "thunderk", options.getFullTag()

  options = new SiteOptions("xxx", 12, "alnum", "thunderk", 1)
  assert.strictEqual "thunderk:1", options.getFullTag()


require("sdk/test").run(exports)
