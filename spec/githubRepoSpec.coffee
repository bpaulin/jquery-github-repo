describe 'githubRepo', ->
  options =
    message: 'Hello World'

  beforeEach ->
    @$element = $( '#fixtures' )

  describe 'plugin behavior', ->
    it 'should be available on the jQuery object', ->
      expect( $.fn.githubRepo ).toBeDefined()

    it 'should be chainable', ->
      expect( @$element.githubRepo() ).toBe @$element

    it 'should offers default values', ->
      plugin = new $.githubRepo( @$element )

      expect( plugin.defaults ).toBeDefined()

    it 'should overwrites the settings', ->
      plugin = new $.githubRepo( @$element, options )

      expect( plugin.settings.message ).toBe( options.message )

  describe 'plugin state', ->
    beforeEach ->
      @plugin = new $.githubRepo( @$element )

    it 'should have a ready state', ->
      expect( @plugin.getState() ).toBe 'ready'

    it 'should be updatable', ->
      @plugin.setState( 'new state' )

      expect( @plugin.getState() ).toBe 'new state'
