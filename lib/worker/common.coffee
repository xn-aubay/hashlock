# Central worker for the add-on

PasswordHasher = require('../hasher').PasswordHasher
SiteOptions = require('../options').SiteOptions
OptionsStore = require('../store').OptionsStore

class exports.HashLockAbstractWorker

  constructor: ->
    @hasher = new PasswordHasher()
    @store = new OptionsStore(@getDefaultOptions())

  # Method to override to initially retrieve the default options for new sites
  getDefaultOptions: -> new SiteOptions()

  # Method to override to return the current active webpage's URL
  getCurrentUrl: -> null

  # Get the SiteOptions instance for a given site tag
  getSiteOptions: (site_tag) ->
    @store.getOptions site_tag ? @stripSiteTag(@getCurrentUrl())

  # Respond to a hashRequest
  hashRequest: (base_password) ->
    site_tag = @stripSiteTag(@getCurrentUrl())
    config = @getSiteOptions()

    @hasher.getHash config, base_password

  # Respond to a optionsRequest
  optionsRequest: (options) ->
    # TODO
    @getSiteOptions()

  # Get the site tag from a full URL
  stripSiteTag: (url) ->
    #console.log "getsite <= #{url}"
    if not url?
      return null

    reg = new RegExp("^https?://([^:/]+\\.)?([^.:/]+)\\.([a-z]{2,5})(:\\d+)?/.*$")
    m = reg.exec url
    try
      if "" == m[2]
        return 'generic'
      else
        #console.log "getsite => #{m[2]}"
        return m[2]
    catch e
      return 'generic'
