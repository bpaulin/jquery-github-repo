describe 'githubRepo Parameters', ->

  beforeEach ->
    @$element = $( '#fixtures' )

  describe 'user param', ->
    it 'should be "bpaulin" as default', ->
      plugin = new $.githubRepo()
      expect( plugin.settings.user ).toBe( "bpaulin" )

  describe 'githubForceJson param', ->
    it 'should be false as default', ->
      plugin = new $.githubRepo()
      expect( plugin.settings.githubForceJson ).toBe( false )

  describe 'coderwallForceJson param', ->
    it 'should be false as default', ->
      plugin = new $.githubRepo()
      expect( plugin.settings.coderwallForceJson ).toBe( false )

  describe 'github param', ->
    it 'should be true as default', ->
      plugin = new $.githubRepo()
      expect( plugin.settings.github ).toBe( true )

    it 'should leave div.repositories untouched if false', ->
      loadFixtures('origin.html')
      @$element = $( '#fixtures' )
      origin = @$element.find('div.repositories').html()
      @$element.githubRepo({'github':false})
      expect(
        @$element.find('div.repositories').html()
      ).toEqual( origin )

  describe 'coderwall param', ->
    it 'should be true as default', ->
      plugin = new $.githubRepo()
      expect( plugin.settings.coderwall ).toBe( true )

    it 'should leave div.badges untouched if false', ->
      loadFixtures('origin.html')
      @$element = $( '#fixtures' )
      origin = @$element.find('div.badges').html()
      @$element.githubRepo({'github':false})
      expect(
        @$element.find('div.badges').html()
      ).toEqual( origin )
