# Features to inject as content-script, common to all supported browsers
# It uses jQuery v2 to bind to the content's password inputs

class window.HashLockAbstractHandler

  constructor: ->
    # TODO Monitor dynamically created inputs
    for item in jQuery('input[type="password"]')
      @bindToInput jQuery(item)

    @configPanel = jQuery('#hashLockConfig')
    for item in @configPanel
      @bindConfig jQuery(item)

    @sendOptionsRequest()

  # Asynchronous method to send hashRequest and receive hashResponse
  hashRequest: (password, callback) ->
    callback()

  # Asynchronous method to send optionsRequest and receive optionsResponse
  optionsRequest: (options, callback) ->
    callback()

  # Fill the config panel from a SiteOptions
  fillConfigPanel: (options) ->
    jQuery(".site_tag", @configPanel).text options.site_tag
    jQuery(".private_key", @configPanel).val options.private_key
    jQuery(".length", @configPanel).val options.length

    if jQuery("#options_specific", @configPanel).prop("checked")
      jQuery(".private_key", @configPanel).prop "disabled", false
      jQuery(".length", @configPanel).prop "disabled", false
    else
      jQuery(".private_key", @configPanel).prop "disabled", true
      jQuery(".length", @configPanel).prop "disabled", true

  # Send an optionsRequest and process its result
  sendOptionsRequest: (options) ->
    @optionsRequest options, @fillConfigPanel

  # Serialize options from the config panel
  serializeOptions: ->
    # TODO
    {}

  # Apply the config panel
  bindConfig: (body) ->
    jQuery("#options_global,#options_specific", body).click =>
      @sendOptionsRequest @serializeOptions()

  # Bind to a jQuery selected input
  bindToInput: (input) ->
    hashed = false
    maxlength = input.attr("maxlength")
    old_background = input.css('backgroundColor')

    if input.hasClass("nopasshash") or input.hasClass("nopwgen") or input.hasClass("nohashlock")
      return

    if maxlength
      input.attr "maxlength", "100"

    input.click =>
      if hashed
        input.val ""
        input.css 'backgroundColor', old_background
        hashed = false

    input.blur =>
      value = input.val()
      if value.length > 0 and value[0] == '#'
        @hashRequest value.substring(1), (hashed_password) =>
          if hashed_password
            hashed = true
            input.val hashed_password
            input.css 'backgroundColor', '#D2D2D2'

    input.keypress (e) =>
      if e.which == 13
        input.blur()
        input.form.submit()
        e.preventDefault()
