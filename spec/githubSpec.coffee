describe 'Github Repositories', ->

  beforeEach ->
    loadFixtures('origin.html')
    @$element = $( '#fixtures' )
    @$element.githubRepo()

  describe 'Github API', ->
    it 'should call the correct url', ->
      plugin = new $.githubRepo(@$element, {"user":"noone"})
      expect(
        $.ajax.calls.mostRecent().args[0]
      ).toEqual('https://api.github.com/users/noone/repos')

    it 'should call the forced url', ->
      plugin = new $.githubRepo(@$element, {"githubForceJson":"bpaulin.json"})
      expect(
        $.ajax.calls.mostRecent().args[0]
      ).toEqual('bpaulin.json')

  describe 'Repositories', ->
    it 'should be a div.repositories', ->
      expect(
        @$element.children('div.repositories').length
      ).toBe(1)

    it 'should contain each repository in a div.repository', ->
      expect(
        @$element.children('div.repositories').children('div.repository').length
      ).toBe(getJSONFixture('github_user.json').length)

  describe 'A repository', ->
    it 'should be ided by data-github-id', ->
      data = getJSONFixture('github_user.json')
      for repo in data
        expect(
          $('.repositories')[0]
        ).toContainElement('.repository[data-github-id="'+repo.id+'"]')

    it 'should have the same structure as a twbs panel', ->
      $('#fixtures div.repositories div.repository').each (i, e)->
        expect(e).toBeMatchedBy('div.panel.panel-default')
        children = $(e).children('*')
        expect(children.length).toEqual(3)
        expect(children[0]).toBeMatchedBy('div.panel-heading')
        expect(children[1]).toBeMatchedBy('div.panel-body')
        expect(children[2]).toBeMatchedBy('div.panel-footer')

    it 'should display name in (.panel-heading .name)', ->
      repos = getJSONFixture('github_user.json')
      for repo in repos
        expect(
          $('.repository[data-github-id="'+repo.id+'"] .panel-heading .name')
        ).toContainText(repo.name)

