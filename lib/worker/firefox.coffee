# Implementation of HashLockAbstractWorker for Firefox

HashLockAbstractWorker = require('./common').HashLockAbstractWorker
SiteOptions = require('../options').SiteOptions
SimplePrefs = require('sdk/simple-prefs')
tabs = require('sdk/tabs')

class exports.HashLockFirefoxWorker extends HashLockAbstractWorker

  getDefaultOptions: ->
    options = SiteOptions.fromDict(SimplePrefs.prefs)

    @saveDefaultOptions(options)

    for name, value of options.toDict()
      SimplePrefs.on name, =>
        @default_options = SiteOptions.fromDict(SimplePrefs.prefs)
        @saveDefaultOptions @default_options

    return options

  getCurrentUrl: -> tabs.activeTab.url

  # Save the default options to preferences
  saveDefaultOptions: (options) ->
    for name, value of options.toDict()
      if value?
        SimplePrefs.prefs[name] = value

  # Add a communication peer to receive hash requests and send responses
  addPeer: (peer) ->
    peer.on "hashRequest", (password) =>
      result = @getHash password
      peer.emit 'hashResponse', result

  # Remove a communication peer
  removePeer: (peer) ->
    console.log "TODO : Remove peer"
