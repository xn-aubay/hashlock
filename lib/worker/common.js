// Generated by CoffeeScript 1.4.0
(function() {
  var PasswordHasher, SiteOptions;

  PasswordHasher = require('../hasher').PasswordHasher;

  SiteOptions = require('../options').SiteOptions;

  exports.HashLockAbstractWorker = (function() {

    function HashLockAbstractWorker() {
      this.hasher = new PasswordHasher();
      this.default_options = this.getDefaultOptions();
    }

    HashLockAbstractWorker.prototype.getDefaultOptions = function() {
      return new SiteOptions();
    };

    HashLockAbstractWorker.prototype.getCurrentUrl = function() {
      return null;
    };

    HashLockAbstractWorker.prototype.getSiteOptions = function(site_tag) {
      var options_dict;
      options_dict = this.default_options.toDict();
      options_dict['site_tag'] = site_tag;
      return new SiteOptions.fromDict(options_dict);
    };

    HashLockAbstractWorker.prototype.getHash = function(base_password) {
      var config, site_tag;
      site_tag = this.stripSiteTag(this.getCurrentUrl());
      config = this.getSiteOptions(site_tag);
      return this.hasher.getHash(config, base_password);
    };

    HashLockAbstractWorker.prototype.stripSiteTag = function(url) {
      var m, reg;
      if (!(url != null)) {
        return null;
      }
      reg = new RegExp("^https?://([^:/]+\\.)?([^.:/]+)\\.([a-z]{2,5})(:\\d+)?/.*$");
      m = reg.exec(url);
      try {
        if ("" === m[2]) {
          return 'generic';
        } else {
          return m[2];
        }
      } catch (e) {
        return 'generic';
      }
    };

    return HashLockAbstractWorker;

  })();

}).call(this);