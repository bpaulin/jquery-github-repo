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
      this.formatDate = function(isoDate) {
        var date;
        date = new Date(isoDate);
        return ("0" + date.getDate()).slice(-2) + '-' + ("0" + (date.getMonth() + 1)).slice(-2) + '-' + date.getFullYear();
      };
      this.coderwall = function() {
        var $divBadges, that, urlCoderwall;
        if (this.$element.find('div.badges').length > 0) {
          $divBadges = this.$element.find('div.badges');
        } else {
          $divBadges = $('<div>').addClass('badges');
          this.$element.append($divBadges);
        }
        urlCoderwall = "http://www.coderwall.com/" + this.settings.user + ".json";
        if (this.settings.coderwallForceJson) {
          urlCoderwall = this.settings.coderwallForceJson;
        }
        that = this;
        return $.ajax(urlCoderwall, {
          success: function(data, textStatus, jqXHR) {
            var badge, badges, dataBadge, level, levels, _i, _j, _k, _l, _len, _len1, _len2, _len3, _ref, _ref1, _results;
            badges = data.badges.slice(0);
            _ref = data.badges;
            for (_i = 0, _len = _ref.length; _i < _len; _i++) {
              dataBadge = _ref[_i];
              levels = new Array();
              _ref1 = data.badges;
              for (_j = 0, _len1 = _ref1.length; _j < _len1; _j++) {
                badge = _ref1[_j];
                if (badge.name.indexOf(dataBadge.name) !== -1) {
                  levels.push(badge);
                }
              }
              if (levels.length > 1) {
                for (_k = 0, _len2 = levels.length; _k < _len2; _k++) {
                  level = levels[_k];
                  if (levels.indexOf(level) !== levels.length - 1) {
                    badges.splice(badges.indexOf(level), 1);
                  }
                }
              }
            }
            _results = [];
            for (_l = 0, _len3 = badges.length; _l < _len3; _l++) {
              dataBadge = badges[_l];
              _results.push($divBadges.append("<div class=\"cw-badge row\"\n  data-badge-name=\"" + dataBadge.name + "\">\n  <div class=\"col-sm-1 col-xs-2\">\n    <img src=\"" + dataBadge.badge + "\"\n      alt=\"" + dataBadge.name + "\"\n      class=\"img-responsive\"\n      style=\"margin-top:20px\"/>\n  </div>\n  <div class=\"col-sm-11 col-xs-10\">\n    <h3 class=\"name\">\n      " + dataBadge.name + "\n      <small class=\"created\">" + (that.formatDate(dataBadge.created)) + "</small>\n    </h3>\n    <p class=\"description\">" + dataBadge.description + "</p>\n  </div>\n</div>"));
            }
            return _results;
          }
        });
      };
      this.github = function() {
        var repositories, settings, that, urlGithub;
        if (this.$element.find('div.repositories').length > 0) {
          repositories = this.$element.find('div.repositories')[0];
        } else {
          repositories = $('<div>').addClass('repositories');
          this.$element.append(repositories);
        }
        urlGithub = 'https://api.github.com/users/' + this.settings.user + '/repos';
        if (this.settings.githubForceJson) {
          urlGithub = this.settings.githubForceJson;
        }
        settings = this.settings;
        that = this;
        return $.ajax(urlGithub, {
          success: function(data, textStatus, jqXHR) {
            var cssRepo, dataRepo, fork, origine, pushed_at, repository, _i, _len, _results;
            _results = [];
            for (_i = 0, _len = data.length; _i < _len; _i++) {
              dataRepo = data[_i];
              cssRepo = "[data-github-full-name='" + dataRepo.full_name + "']";
              if ($(repositories).find(cssRepo).length > 0) {
                repository = $(repositories).find(cssRepo)[0];
              } else {
                if (settings.allGithubRepos) {
                  repository = $('<div>').addClass('repository');
                  $(repositories).append(repository);
                } else {
                  continue;
                }
              }
              origine = $(repository).contents();
              $(repository).empty();
              pushed_at = that.formatDate(dataRepo.pushed_at);
              if (dataRepo.fork) {
                fork = '<span class="label label-warning">fork</span>';
              } else {
                fork = '';
              }
              $(repository).addClass("panel panel-default").attr('data-github-id', dataRepo.id).attr('data-github-full-name', dataRepo.full_name).append("<div class=\"panel-heading\">\n  <strong>\n    <a href=\"" + dataRepo.owner.html_url + "\" class=\"owner\">\n      " + dataRepo.owner.login + "</a> /\n    <a href=\"" + dataRepo.html_url + "\" class=\"name\">\n      " + dataRepo.name + "</a>\n  </strong>\n  <div class=\"pull-right btn-group btn-group-xs\">\n    <a href=\"" + dataRepo.html_url + "/watchers\"\n        class=\"btn btn-default watchers\">\n      <i class=\"fa fa-eye\"></i> " + dataRepo.watchers + "\n    </a>\n    <a href=\"" + dataRepo.html_url + "/forks\" class=\"btn btn-default forks\">\n      <i class=\"fa fa-code-fork\"></i> " + dataRepo.forks + "\n    </a>\n  </div>\n  <div class=\"spacer\" style=\"clear: both;\"></div>\n</div>\n<div class=\"panel-body\">\n  <div class=\"description\">" + dataRepo.description + "</div>\n</div>\n<div class=\"panel-footer\">\n  " + fork + "\n  <span class=\"label label-primary language\">\n    " + dataRepo.language + "\n  </span>\n  <div class=\"pull-right\">\n    <small>\n      Dernier commit sur\n      <strong class=\"default_branch\">" + dataRepo.default_branch + "</strong>\n      le <span class=\"pushed_at\">" + pushed_at + "</pushed_at>\n    </small>\n    <a href=\"" + dataRepo.html_url + "/archive/master.zip\"\n        class=\"archive btn btn-default btn-xs\">\n      <i class=\"fa fa-download\"></i>\n    </a>\n  </div>\n</div>");
              _results.push($(repository).children('.panel-body').append(origine));
            }
            return _results;
          }
        });
      };
      this.init = function() {
        var settings;
        this.settings = $.extend({}, this.defaults, options);
        settings = this.settings;
        if (this.settings.github) {
          this.github();
        }
        if (this.settings.coderwall) {
          this.coderwall();
        }
        return this.setState('ready');
      };
      this.init();
      return this;
    };
    $.githubRepo.prototype.defaults = {
      user: 'user',
      github: true,
      githubForceJson: false,
      allGithubRepos: true,
      coderwall: true,
      coderwallForceJson: false
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
