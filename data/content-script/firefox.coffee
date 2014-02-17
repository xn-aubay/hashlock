# Firefox-specific content-script features

class HashLockFirefoxHandler extends HashLockAbstractHandler

  hashPasswordAsync: (password, callback) ->
    self.port.emit "hashRequest", password
    self.port.once "hashResponse", (hashed_password) =>
      console.log "Received response: #{hashed_password}"
      callback hashed_password

handler = new HashLockFirefoxHandler()
