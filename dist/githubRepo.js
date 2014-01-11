(function() {
  jQuery(function() {
    $.githubRepo = function(element, options) {
      var state;
      state = '';
      this.settings = {};
      this.$element = $(element);
      this.setState = function(_state) {
        return state = _state;
      };
      this.getState = function() {
        return state;
      };
      this.getSetting = function(key) {
        return this.settings[key];
      };
      this.callSettingFunction = function(name, args) {
        if (args == null) {
          args = [];
        }
        return this.settings[name].apply(this, args);
      };
      this.init = function() {
        this.settings = $.extend({}, this.defaults, options);
        return this.setState('ready');
      };
      this.init();
      return this;
    };
    $.githubRepo.prototype.defaults = {
      message: 'Hello world'
    };
    return $.fn.githubRepo = function(options) {
      return this.each(function() {
        var plugin;
        if ($(this).data('githubRepo') === void 0) {
          plugin = new $.githubRepo(this, options);
          return $(this).data('githubRepo', plugin);
        }
      });
    };
  });

}).call(this);
