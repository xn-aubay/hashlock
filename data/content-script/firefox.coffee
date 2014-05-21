# Firefox-specific content-script features

class HashLockFirefoxHandler extends HashLockAbstractHandler

  constructor: () ->
    self.port.on "refresh", =>
      this.sendOptionsRequest()

  hashRequest: (password, callback) ->
    self.port.emit "hashRequest", password
    self.port.once "hashResponse", (hashed_password) =>
      #console.log "Received response: #{hashed_password}"
      callback hashed_password

  optionsRequest: (options, callback) ->
    self.port.emit "optionsRequest", options
    self.port.once "optionsResponse", (response_options) =>
      #console.log "Received response: #{response_options}"
      callback response_options

handler = new HashLockFirefoxHandler()
