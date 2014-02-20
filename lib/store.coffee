# This store saves SiteOptions objects, specific to each site tag

class exports.OptionsStore

  constructor: (@globalOptions) ->
    @mapping = {}

  # Count the number of options stored
  mappingCount: () ->
    Object.keys(@mapping).length

  # Set the global (default) options for all sites
  setGlobalOptions: (options) ->
    @globalOptions = options

  # Get the SiteOptions for a given tag
  getOptions: (sitetag) ->
    options = @mapping[sitetag]

    if not options?
      options = @globalOptions.getCopy(sitetag)
      @mapping[sitetag] = options

    return options
