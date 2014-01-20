describe 'githubRepo Parameters', ->

  beforeEach ->
    @$element = $( '#fixtures' )

  describe 'user param', ->
    it 'should be "bpaulin" as default', ->
      plugin = new $.githubRepo()
      expect( plugin.settings.user ).toBe( "bpaulin" )
