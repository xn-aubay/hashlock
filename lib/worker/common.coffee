# Central worker for the add-on

PasswordHasher = require('../hasher').PasswordHasher
SiteOptions = require('../options').SiteOptions

class exports.HashLockAbstractWorker

  constructor: ->
    @hasher = new PasswordHasher()
    @default_options = @getDefaultOptions()

  # Method to override to initially retrieve the default options for new sites
  getDefaultOptions: -> new SiteOptions()

  # Method to override to return the current active webpage's URL
  getCurrentUrl: -> null

  getSiteOptions: (site_tag) ->
    # TODO Use a store for site-specific options
    options_dict = @default_options.toDict()
    options_dict['site_tag'] = site_tag
    new SiteOptions.fromDict(options_dict)

  getHash: (base_password) ->
    site_tag = @stripSiteTag @getCurrentUrl()
    config = @getSiteOptions site_tag
    return @hasher.getHash config, base_password

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
