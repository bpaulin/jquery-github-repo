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

  describe 'allGithubRepos param', ->
    it 'should be true as default', ->
      plugin = new $.githubRepo()
      expect( plugin.settings.allGithubRepos ).toBe( true )
