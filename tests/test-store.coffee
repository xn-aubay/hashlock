OptionsStore = require("./store").OptionsStore
SiteOptions = require("./options").SiteOptions


exports['test new'] = (assert) ->
  store = new OptionsStore(new SiteOptions())

  assert.strictEqual 0, store.mappingCount()

  store.getOptions "test"

  assert.strictEqual 1, store.mappingCount()

  store.getOptions "test"

  assert.strictEqual 1, store.mappingCount()

require("sdk/test").run(exports)
