// Generated by CoffeeScript 1.4.0
(function() {

  window.HashLockAbstractHandler = (function() {

    function HashLockAbstractHandler() {
      var item, _i, _j, _len, _len1, _ref, _ref1;
      _ref = jQuery('input[type="password"]');
      for (_i = 0, _len = _ref.length; _i < _len; _i++) {
        item = _ref[_i];
        this.bindToInput(jQuery(item));
      }
      this.configPanel = jQuery('#hashLockConfig');
      _ref1 = this.configPanel;
      for (_j = 0, _len1 = _ref1.length; _j < _len1; _j++) {
        item = _ref1[_j];
        this.bindConfig(jQuery(item));
      }
      this.sendOptionsRequest();
    }

    HashLockAbstractHandler.prototype.hashRequest = function(password, callback) {
      return callback();
    };

    HashLockAbstractHandler.prototype.optionsRequest = function(options, callback) {
      return callback();
    };

    HashLockAbstractHandler.prototype.fillConfigPanel = function(options) {
      jQuery(".site_tag", this.configPanel).text(options.site_tag);
      jQuery(".private_key", this.configPanel).val(options.private_key);
      jQuery(".length", this.configPanel).val(options.length);
      if (jQuery("#options_specific", this.configPanel).prop("checked")) {
        jQuery(".private_key", this.configPanel).prop("disabled", false);
        return jQuery(".length", this.configPanel).prop("disabled", false);
      } else {
        jQuery(".private_key", this.configPanel).prop("disabled", true);
        return jQuery(".length", this.configPanel).prop("disabled", true);
      }
    };

    HashLockAbstractHandler.prototype.sendOptionsRequest = function(options) {
      return this.optionsRequest(options, this.fillConfigPanel);
    };

    HashLockAbstractHandler.prototype.serializeOptions = function() {
      return {};
    };

    HashLockAbstractHandler.prototype.bindConfig = function(body) {
      var _this = this;
      return jQuery("#options_global,#options_specific", body).click(function() {
        return _this.sendOptionsRequest(_this.serializeOptions());
      });
    };

    HashLockAbstractHandler.prototype.bindToInput = function(input) {
      var hashed, maxlength, old_background,
        _this = this;
      hashed = false;
      maxlength = input.attr("maxlength");
      old_background = input.css('backgroundColor');
      if (input.hasClass("nopasshash") || input.hasClass("nopwgen") || input.hasClass("nohashlock")) {
        return;
      }
      if (maxlength) {
        input.attr("maxlength", "100");
      }
      input.click(function() {
        if (hashed) {
          input.val("");
          input.css('backgroundColor', old_background);
          return hashed = false;
        }
      });
      input.blur(function() {
        var value;
        value = input.val();
        if (value.length > 0 && value[0] === '#') {
          return _this.hashRequest(value.substring(1), function(hashed_password) {
            if (hashed_password) {
              hashed = true;
              input.val(hashed_password);
              return input.css('backgroundColor', '#D2D2D2');
            }
          });
        }
      });
      return input.keypress(function(e) {
        if (e.which === 13) {
          input.blur();
          input.form.submit();
          return e.preventDefault();
        }
      });
    };

    return HashLockAbstractHandler;

  })();

}).call(this);
