# Main worker class for password hashing

crypto = require("./crypto")

class exports.PasswordHasher

  # IMPORTANT: This function should be changed carefully.  It must be
  # completely deterministic and consistent between releases.  Otherwise
  # users would be forced to update their passwords.  In other words, the
  # algorithm must always be backward-compatible.  It's only acceptable to
  # violate backward compatibility when new options are used.
  # SECURITY: The optional adjustments are positioned and calculated based
  # on the sum of all character codes in the raw hash string.  So it becomes
  # far more difficult to guess the injected special characters without
  # knowing the master key.
  # TODO: Is it ok to assume ASCII is ok for adjustments?
  generateHashWord: (siteTag, masterKey, hashWordSize, requireDigit, requirePunctuation, requireMixedCase, restrictSpecial, restrictDigits) ->

    # Start with the SHA1-encrypted master key/site tag.
    s = crypto.b64_hmac_sha1(masterKey, siteTag);

    # Use the checksum of all characters as a pseudo-randomizing seed to
    # avoid making the injected characters easy to guess.  Note that it
    # isn't random in the sense of not being deterministic (i.e.
    # repeatable).  Must share the same seed between all injected
    # characters so that they are guaranteed unique positions based on
    # their offsets.
    sum = 0
    for i in [0...s.length]
      sum += s.charCodeAt(i)

    # Restrict digits just does a mod 10 of all the characters
    if restrictDigits
      s = this.convertToDigits(s, sum, hashWordSize)
    else
      # Inject digit, punctuation, and mixed case as needed.
      if requireDigit
        s = this.injectSpecialCharacter(s, 0, 4, sum, hashWordSize, 48, 10)
      if requirePunctuation && !restrictSpecial
        s = this.injectSpecialCharacter(s, 1, 4, sum, hashWordSize, 33, 15)
      if requireMixedCase
        s = this.injectSpecialCharacter(s, 2, 4, sum, hashWordSize, 65, 26)
        s = this.injectSpecialCharacter(s, 3, 4, sum, hashWordSize, 97, 26)
      # Strip out special characters as needed.
      if restrictSpecial
        s = this.removeSpecialCharacters(s, sum, hashWordSize)

    # Trim it to size.
    return s.substr(0, hashWordSize)


  # This is a very specialized method to inject a character chosen from a
  # range of character codes into a block at the front of a string if one of
  # those characters is not already present.
  # Parameters:
  #  sInput   = input string
  #  offset   = offset for position of injected character
  #  reserved = # of offsets reserved for special characters
  #  seed     = seed for pseudo-randomizing the position and injected character
  #  lenOut   = length of head of string that will eventually survive truncation.
  #  cStart   = character code for first valid injected character.
  #  cNum     = number of valid character codes starting from cStart.
  injectSpecialCharacter: (sInput, offset, reserved, seed, lenOut, cStart, cNum) ->

    pos0 = seed % lenOut;
    pos = (pos0 + offset) % lenOut;
    # Check if a qualified character is already present
    # Write the loop so that the reserved block is ignored.
    for i in [0...lenOut - reserved]
      i2 = (pos0 + reserved + i) % lenOut
      c = sInput.charCodeAt(i2)
      if c >= cStart && c < cStart + cNum
        # Already present - nothing to do
        return sInput

    sHead = if pos > 0 then sInput.substring(0, pos) else ""
    sInject = String.fromCharCode(((seed + sInput.charCodeAt(pos)) % cNum) + cStart)
    sTail = if pos + 1 < sInput.length then sInput.substring(pos+1, sInput.length) else ""

    return sHead + sInject + sTail


  # Another specialized method to replace a class of character, e.g.
  # punctuation, with plain letters and numbers.
  # Parameters:
  #  sInput = input string
  #  seed   = seed for pseudo-randomizing the position and injected character
  #  lenOut = length of head of string that will eventually survive truncation.
  removeSpecialCharacters: (sInput, seed, lenOut) ->

    s = ''
    i = 0

    while (i < lenOut)

      j = sInput.substring(i).search(/[^a-z0-9]/i)
      if j < 0
        break
      if j > 0
        s += sInput.substring(i, i + j)
      s += String.fromCharCode((seed + i) % 26 + 65)
      i += (j + 1)

    if (i < sInput.length)
      s += sInput.substring(i)

    return s


  # Convert input string to digits-only.
  # Parameters:
  #  sInput = input string
  #  seed   = seed for pseudo-randomizing the position and injected character
  #  lenOut = length of head of string that will eventually survive truncation.
  convertToDigits: (sInput, seed, lenOut) ->

    s = ''
    i = 0

    while (i < lenOut)

      j = sInput.substring(i).search(/[^0-9]/i)
      if (j < 0)
        break
      if (j > 0)
        s += sInput.substring(i, i + j)
      s += String.fromCharCode((seed + sInput.charCodeAt(i)) % 10 + 48)
      i += (j + 1)

    if (i < sInput.length)
      s += sInput.substring(i)

    return s


  # Get the final hashed password for a given SiteOptions
  getHash: (options, base_password) ->

    # Hash the site name against the private key, to obtain a site key
    site_key = this.generateHashWord(
        options.private_key,
        options.getFullTag(),
        24,
        true,
        true,
        true,
        false,
        false
    )

    # Hash the base password against the site key, to obtain the final key
    final_hash = this.generateHashWord(
        site_key,
        base_password,
        options.length,
        true,
        false,
        true,
        true,
        false
    )

    #console.log "getHash #{options.private_key}/#{options.length}/#{options.getFullTag()}/#{base_password} => #{final_hash}"

    return final_hash
