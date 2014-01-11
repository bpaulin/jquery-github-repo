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
        var body, footer, heading, texte;
        this.settings = $.extend({}, this.defaults, options);
        texte = this.$element.html();
        this.$element.empty();
        this.$element.addClass('panel panel-primary');
        heading = $('<div>').addClass('panel-heading').append(this.$element.data('repository'));
        body = $('<div>').addClass('panel-body').append(texte);
        footer = $('<div>').addClass('panel-footer').append('http://github.com/' + this.$element.data('repository'));
        this.$element.append(heading).append(body).append(footer);
        $.ajax('https://api.github.com/repos/' + this.$element.data('repository'), {
          success: function(data, textStatus, jqXHR) {
            heading.empty();
            heading.append($('<h1>').addClass('panel-title').append(data.name));
            heading.append($('<small>').append(data.description));
            footer.empty();
            return footer.append($('<a>').attr('href', data.url).append(data.url));
          }
        });
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
