describe 'githubRepo Parameters', ->

  beforeEach ->
    jasmine.getFixtures().fixturesPath = 'spec/fixtures/'
    loadFixtures 'fragment.html'
    @$element = $( '#fixtures' )

  describe 'user param', ->
    it 'should be "bpaulin" as default', ->
      plugin = new $.githubRepo()
      expect( plugin.settings.user ).toBe( "bpaulin" )
