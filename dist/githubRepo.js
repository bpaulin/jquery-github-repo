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
        var body, footer, heading, repo, texte;
        this.settings = $.extend({}, this.defaults, options);
        repo = this.$element.data('repository');
        texte = this.$element.html();
        this.$element.empty();
        this.$element.addClass('panel panel-primary');
        heading = $('<div>').addClass('panel-heading').append(repo);
        body = $('<div>').addClass('panel-body').append(texte);
        footer = $('<div>').addClass('panel-footer').append('http://github.com/' + repo);
        this.$element.append(heading).append(body).append(footer);
        $.ajax('https://api.github.com/repos/' + repo, {
          success: function(data, textStatus, jqXHR) {
            heading.empty();
            heading.append($('<h1>').addClass('panel-title').append(data.name));
            heading.append($('<small>').append(data.description));
            footer.empty();
            footer.append($('<a>').attr('href', data.html_url).append(data.html_url));
            return $.ajax('https://api.github.com/repos/' + repo + '/branches', {
              success: function(data, textStatus, jqXHR) {
                var branche, dl, index;
                dl = $('<dl>').addClass("dl-horizontal");
                for (index in data) {
                  branche = data[index];
                  $.ajax('https://api.github.com/repos/' + repo + '/branches/' + branche.name, {
                    success: function(data, textStatus, jqXHR) {
                      var dd, dt, urlCommit;
                      dt = $('<dt>').append($('<a>').attr('href', 'http://github.com/' + repo + '/tree/' + data.name).append(data.name));
                      dd = $('<dd>');
                      dd.append($('<span>').append(data.commit.commit.author.date.substring(0, 10)));
                      dd.append($('<img>').attr('src', 'https://travis-ci.org/' + repo + '.png?branch=' + data.name));
                      urlCommit = 'https://github.com/' + repo + '/commit/' + data.commit.sha;
                      dd.append($('<a>').attr('href', urlCommit).append(data.commit.commit.message.substring(0, 25)));
                      dl.append(dt);
                      return dl.append(dd);
                    }
                  });
                }
                return footer.append(dl);
              }
            });
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
