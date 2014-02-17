# Container for options used to generate passwords

# Attributes :
#  - private_key : Private key
#  - length : Length of the password to generate
#  - char_mode : Character set to use (currently, only 'alnum' is supported)
#  - site_tag : Base tag for the web site
#  - bump : Number of times the password has been bumped

root = exports ? this

generatePrivateKey = ->
  guid = 'xxxxxxxx-xxxx-4xxx-yxxx-xxxxxxxxxxxx'.replace /[xy]/g, (c) ->
    r = Math.random() * 16 | 0
    v = if c == 'x' then r else (r&0x3|0x8)
    v.toString(16)
  guid.toUpperCase()

class root.SiteOptions

  constructor: (@private_key=null, @length=12, @char_mode="alnum", @site_tag=null, @bump=0) ->
    if not @private_key
      @private_key = generatePrivateKey()
      console.log "Generated private key : #{@private_key}"

  # Generate a random private key
  @generatePrivateKey: generatePrivateKey

  # Get the full tag for the stored options
  getFullTag: ->
    if not @site_tag
      "generic"
    else if @bump > 0
      "#{@site_tag}:#{@bump}"
    else
      @site_tag
