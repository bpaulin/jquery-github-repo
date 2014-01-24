describe 'coderwall badges', ->

  beforeEach ->
    getJSONFixture 'coderwall.json'
    loadFixtures 'origin.html'
    spyOn($, 'ajax').and.callFake (req, obj) ->
      obj.success(getJSONFixture 'coderwall.json')

    @$element = $( '#fixtures' )
    @$element.githubRepo()

  describe 'coderwall API', ->
    it 'should call the correct url', ->
      plugin = new $.githubRepo(@$element, {"user":"noone"})
      expect(
        $.ajax.calls.mostRecent().args[0]
      ).toEqual('http://www.coderwall.com/noone.json')

    it 'should call the forced url', ->
      plugin = new $.githubRepo(
        @$element,
        {"coderwallForceJson":"coderwall.json"}
      )
      expect(
        $.ajax.calls.mostRecent().args[0]
      ).toEqual('coderwall.json')

  describe 'simple case (A skill)', ->
    it 'should be in a div.cw-badge ided by data-badge-name', ->
      expect(
        @$element.find(
          'div.badges div.cw-badge[data-badge-name="A skill"]'
        ).length
      ).toBe(1)

    it 'should display badge image', ->
      expect(
        @$element.find(
          'div.badges div.cw-badge[data-badge-name="A skill"] img'
        )
      ).toHaveAttr('src', 'https://path.to/skill.png')

    it 'should display badge description in .description', ->
      expect(
        @$element.find(
          'div.badges div.cw-badge[data-badge-name="A skill"] .description'
        )
      ).toContainText('Have a skill')

    it 'should display badge creation date in .created', ->
      expect(
        @$element.find(
          'div.badges div.cw-badge[data-badge-name="A skill"] .created'
        )
      ).toContainText('01-01-2012')

    describe 'multi level skills', ->
      it 'should not display low level skills', ->
        expect(
          @$element.find(
            'div.badges div.cw-badge[data-badge-name="A multilevel skill"]'
          ).length
        ).toBe(0)
        expect(
          @$element.find(
            'div.badges div.cw-badge[data-badge-name="A multilevel skill 2"]'
          ).length
        ).toBe(0)

      it 'should display max level skills', ->
        expect(
          @$element.find(
            'div.badges div.cw-badge[data-badge-name="A multilevel skill 3"]'
          ).length
        ).toBe(1)

