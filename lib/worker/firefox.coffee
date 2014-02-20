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
  #  If *secure* is true, the worker will also respond to options requests
  addPeer: (peer, secure=false) ->
    peer.on "hashRequest", (password) =>
      result = @hashRequest(password)
      peer.emit 'hashResponse', result

    if secure
      peer.on "optionsRequest", (options) =>
        result = @optionsRequest(options)
        peer.emit "optionsResponse", result

  # Remove a communication peer
  removePeer: (peer) ->
    console.log "TODO : Remove peer"
