# Container for options used to generate passwords

# Attributes :
#  - private_key : Private key
#  - length : Length of the password to generate
#  - char_mode : Character set to use (currently, only 'alnum' is supported)
#  - site_tag : Base tag for the web site
#  - bump : Number of times the password has been bumped

generatePrivateKey = ->
  guid = 'xxxxxxxx-xxxx-4xxx-yxxx-xxxxxxxxxxxx'.replace /[xy]/g, (c) ->
    r = Math.random() * 16 | 0
    v = if c == 'x' then r else (r&0x3|0x8)
    v.toString(16)
  guid.toUpperCase()

class exports.SiteOptions

  constructor: (@private_key, @length, @char_mode, @site_tag, @bump) ->
    if not @private_key
      @private_key = generatePrivateKey()
      #console.log "Generated private key : #{@private_key}"

    @length ?= 12
    @char_mode ?= "alnum"
    @site_tag ?= null
    @bump ?= 0

    if @length < 1
      @length = 1

  # Generate a random private key
  @generatePrivateKey: generatePrivateKey

  # Create a copy for a specific site
  getCopy: (sitetag) ->
    new SiteOptions(@private_key, @length, @char_mode, sitetag, 0)

  # Create a serializable object
  toDict: ->
    private_key: @private_key
    length: @length
    char_mode: @char_mode
    site_tag: @site_tag
    bump: @bump

  # Create a SiteOptions from a serializable object
  @fromDict: (dict) ->
    new SiteOptions(dict['private_key'], dict['length'], dict['char_mode'], dict['site_tag'], dict['bump'])

  # Get the full tag for the stored options
  getFullTag: ->
    if not @site_tag
      "generic"
    else if @bump > 0
      "#{@site_tag}:#{@bump}"
    else
      @site_tag
