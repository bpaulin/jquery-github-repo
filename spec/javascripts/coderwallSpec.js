(function() {
  describe('coderwall badges', function() {
    beforeEach(function() {
      getJSONFixture('coderwall.json');
      loadFixtures('origin.html');
      spyOn($, 'ajax').and.callFake(function(req, obj) {
        return obj.success(getJSONFixture('coderwall.json'));
      });
      this.$element = $('#fixtures');
      return this.$element.githubRepo();
    });
    describe('coderwall API', function() {
      it('should call the correct url', function() {
        var plugin;
        plugin = new $.githubRepo(this.$element, {
          "user": "noone"
        });
        return expect($.ajax.calls.mostRecent().args[0]).toEqual('http://www.coderwall.com/noone.json');
      });
      return it('should call the forced url', function() {
        var plugin;
        plugin = new $.githubRepo(this.$element, {
          "coderwallForceJson": "coderwall.json"
        });
        return expect($.ajax.calls.mostRecent().args[0]).toEqual('coderwall.json');
      });
    });
    return describe('simple case (A skill)', function() {
      it('should be in a div.cw-badge ided by data-badge-name', function() {
        return expect(this.$element.find('div.badges div.cw-badge[data-badge-name="A skill"]').length).toBe(1);
      });
      it('should display badge image', function() {
        return expect(this.$element.find('div.badges div.cw-badge[data-badge-name="A skill"] img')).toHaveAttr('src', 'https://path.to/skill.png');
      });
      it('should display badge description in .description', function() {
        return expect(this.$element.find('div.badges div.cw-badge[data-badge-name="A skill"] .description')).toContainText('Have a skill');
      });
      it('should display badge name in .name', function() {
        return expect(this.$element.find('div.badges div.cw-badge[data-badge-name="A skill"] .name')).toContainText('A skill');
      });
      it('should display badge creation date in .created', function() {
        return expect(this.$element.find('div.badges div.cw-badge[data-badge-name="A skill"] .created')).toContainText('01-01-2012');
      });
      return describe('multi level skills', function() {
        it('should not display low level skills', function() {
          expect(this.$element.find('div.badges div.cw-badge[data-badge-name="A multilevel skill"]').length).toBe(0);
          return expect(this.$element.find('div.badges div.cw-badge[data-badge-name="A multilevel skill 2"]').length).toBe(0);
        });
        return it('should display max level skills', function() {
          return expect(this.$element.find('div.badges div.cw-badge[data-badge-name="A multilevel skill 3"]').length).toBe(1);
        });
      });
    });
  });

}).call(this);
