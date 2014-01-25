(function() {
  describe('githubRepo Parameters', function() {
    beforeEach(function() {
      return this.$element = $('#fixtures');
    });
    describe('user param', function() {
      return it('should be "user" as default', function() {
        var plugin;
        plugin = new $.githubRepo();
        return expect(plugin.settings.user).toBe("user");
      });
    });
    describe('githubForceJson param', function() {
      return it('should be false as default', function() {
        var plugin;
        plugin = new $.githubRepo();
        return expect(plugin.settings.githubForceJson).toBe(false);
      });
    });
    describe('allGithubRepos param', function() {
      return it('should be true as default', function() {
        var plugin;
        plugin = new $.githubRepo();
        return expect(plugin.settings.allGithubRepos).toBe(true);
      });
    });
    describe('coderwallForceJson param', function() {
      return it('should be false as default', function() {
        var plugin;
        plugin = new $.githubRepo();
        return expect(plugin.settings.coderwallForceJson).toBe(false);
      });
    });
    describe('github param', function() {
      it('should be true as default', function() {
        var plugin;
        plugin = new $.githubRepo();
        return expect(plugin.settings.github).toBe(true);
      });
      return it('should leave div.repositories untouched if false', function() {
        var origin;
        loadFixtures('origin.html');
        this.$element = $('#fixtures');
        origin = this.$element.find('div.repositories').html();
        this.$element.githubRepo({
          'github': false
        });
        return expect(this.$element.find('div.repositories').html()).toEqual(origin);
      });
    });
    return describe('coderwall param', function() {
      it('should be true as default', function() {
        var plugin;
        plugin = new $.githubRepo();
        return expect(plugin.settings.coderwall).toBe(true);
      });
      return it('should leave div.badges untouched if false', function() {
        var origin;
        loadFixtures('origin.html');
        this.$element = $('#fixtures');
        origin = this.$element.find('div.badges').html();
        this.$element.githubRepo({
          'github': false
        });
        return expect(this.$element.find('div.badges').html()).toEqual(origin);
      });
    });
  });

}).call(this);
