describe 'coderwall badges', ->

  beforeEach ->
    loadFixtures('origin.html')
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
