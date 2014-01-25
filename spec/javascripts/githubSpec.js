(function() {
  describe('Github Repositories', function() {
    beforeEach(function() {
      getJSONFixture('github.json');
      loadFixtures('origin.html');
      spyOn($, 'ajax').and.callFake(function(req, obj) {
        return obj.success(getJSONFixture('github.json'));
      });
      this.$element = $('#fixtures');
      return this.$element.githubRepo({
        "coderwall": false
      });
    });
    describe('Github API', function() {
      it('should call the correct url', function() {
        var plugin;
        plugin = new $.githubRepo(this.$element, {
          "user": "noone",
          "coderwall": false
        });
        return expect($.ajax.calls.mostRecent().args[0]).toEqual('https://api.github.com/users/noone/repos');
      });
      return it('should call the forced url', function() {
        var plugin;
        plugin = new $.githubRepo(this.$element, {
          "githubForceJson": "user.json",
          "coderwall": false
        });
        return expect($.ajax.calls.mostRecent().args[0]).toEqual('user.json');
      });
    });
    describe('Repositories', function() {
      it('should be a div.repositories', function() {
        return expect(this.$element.children('div.repositories').length).toBe(1);
      });
      return it('should contain each repository in a div.repository', function() {
        return expect(this.$element.children('div.repositories').children('div.repository').length).toBe(getJSONFixture('github.json').length);
      });
    });
    it('should move content in repository body', function() {
      return expect(this.$element.find('div.repository[data-github-full-name="user/repo1"] .panel-body')).toContainText('this text describes repo1');
    });
    it('should only fill existant div.repository if allGithubRepos is false', function() {
      loadFixtures('origin.html');
      this.$element = $('#fixtures');
      this.$element.githubRepo({
        allGithubRepos: false,
        coderwall: false
      });
      expect($('.repository[data-github-full-name="user/repo1"] ')).toBeInDOM();
      return expect($('.repository[data-github-full-name="user/small"] ')).not.toBeInDOM();
    });
    return describe('Each repository', function() {
      var repo, repos, _i, _len, _results;
      repos = getJSONFixture('github.json');
      _results = [];
      for (_i = 0, _len = repos.length; _i < _len; _i++) {
        repo = repos[_i];
        _results.push(describe(repo.full_name, function() {
          beforeEach(function() {
            return this.$repo = $('.repository[data-github-id="' + repo.id + '"] ');
          });
          it('should have the same structure as a twbs panel', function() {
            var children;
            expect(this.$repo).toBeMatchedBy('div.panel.panel-default');
            children = $(this.$repo).children('*');
            expect(children.length).toEqual(3);
            expect(children[0]).toBeMatchedBy('div.panel-heading');
            expect(children[1]).toBeMatchedBy('div.panel-body');
            return expect(children[2]).toBeMatchedBy('div.panel-footer');
          });
          it('should be ided by data-github-id', function() {
            return expect($('.repositories')[0]).toContainElement('.repository[data-github-id="' + repo.id + '"]');
          });
          it('should be ided by data-github-full-name', function() {
            return expect($('.repositories')[0]).toContainElement('.repository[data-github-full-name="' + repo.full_name + '"]');
          });
          it('should display linked name in (.panel-heading .name)', function() {
            var link;
            link = this.$repo.find('.panel-heading .name')[0];
            expect(link).toContainText(repo.name);
            return expect(link).toHaveAttr('href', repo.html_url);
          });
          it('should display linked owner in (.panel-heading .owner)', function() {
            var link;
            link = this.$repo.find('.panel-heading .owner')[0];
            expect(link).toContainText(repo.owner.login);
            return expect(link).toHaveAttr('href', repo.owner.html_url);
          });
          it('should display linked watchers', function() {
            var link;
            link = this.$repo.find('.panel-heading .watchers')[0];
            expect(link).toContainText(repo.watchers);
            return expect(link).toHaveAttr('href', repo.html_url + '/watchers');
          });
          it('should display linked forks', function() {
            var link;
            link = this.$repo.find('.panel-heading .forks')[0];
            expect(link).toContainText(repo.forks);
            return expect(link).toHaveAttr('href', repo.html_url + '/forks');
          });
          xit('should display link to github in (.github)', function() {
            return expect(this.$repo.find('a.github')).toHaveAttr('href', repo.html_url);
          });
          it('should display description in (.panel-heading .description)', function() {
            return expect(this.$repo.find('.panel-body .description')).toContainText(repo.description);
          });
          it('should display language in .language', function() {
            return expect(this.$repo.find('.language')).toContainText(repo.language);
          });
          it('should display default_branch in .default_branch', function() {
            return expect(this.$repo.find('.default_branch')).toContainText(repo.default_branch);
          });
          it('should display pushed_at in .pushed_at', function() {
            return expect(this.$repo.find('.pushed_at')).toContainText('20');
          });
          return it('should display link to zip in .archive', function() {
            return expect(this.$repo.find('a.archive')).toHaveAttr('href', repo.html_url + '/archive/master.zip');
          });
        }));
      }
      return _results;
    });
  });

}).call(this);
