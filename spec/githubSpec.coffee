describe 'Github Repositories', ->

  beforeEach ->
    getJSONFixture 'github.json'
    loadFixtures 'origin.html'
    spyOn($, 'ajax').and.callFake (req, obj) ->
      obj.success(getJSONFixture 'github.json')

    @$element = $( '#fixtures' )
    @$element.githubRepo({"coderwall": false})

  describe 'Github API', ->
    it 'should call the correct url', ->
      plugin = new $.githubRepo(
        @$element,
        {"user":"noone", "coderwall": false}
      )
      expect(
        $.ajax.calls.mostRecent().args[0]
      ).toEqual('https://api.github.com/users/noone/repos')

    it 'should call the forced url', ->
      plugin = new $.githubRepo(
        @$element,
        {"githubForceJson":"user.json", "coderwall": false}
      )
      expect(
        $.ajax.calls.mostRecent().args[0]
      ).toEqual('user.json')

  describe 'Repositories', ->
    it 'should be a div.repositories', ->
      expect(
        @$element.children('div.repositories').length
      ).toBe(1)

    it 'should contain each repository in a div.repository', ->
      expect(
        @$element.children('div.repositories').children('div.repository').length
      ).toBe(getJSONFixture('github.json').length)

  it 'should move content in repository body', ->
    expect(
      @$element.find(
        'div.repository[data-github-full-name="user/repo1"] .panel-body'
      )
    ).toContainText('this text describes repo1')

  it 'should only fill existant div.repository if allGithubRepos is false', ->
    loadFixtures('origin.html')
    @$element = $( '#fixtures' )
    @$element.githubRepo({allGithubRepos:false, coderwall:false})
    expect(
      $('.repository[data-github-full-name="user/repo1"] .panel-heading .name')
    ).toBeInDOM()
    expect(
      $('.repository[data-github-full-name="user/small"] ')
    ).not.toBeInDOM()

  describe 'Each repository', ->
    repos = getJSONFixture('github.json')
    for repo in repos
      # describe each repos
      describe repo.full_name, ->
        beforeEach ->
          @$repo = $('.repository[data-github-id="'+repo.id+'"] ')

        it 'should have the same structure as a twbs panel', ->
          expect(@$repo).toBeMatchedBy('div.panel.panel-default')
          children = $(@$repo).children('*')
          expect(children.length).toEqual(3)
          expect(children[0]).toBeMatchedBy('div.panel-heading')
          expect(children[1]).toBeMatchedBy('div.panel-body')
          expect(children[2]).toBeMatchedBy('div.panel-footer')

        it 'should be ided by data-github-id', ->
          expect(
            $('.repositories')[0]
          ).toContainElement('.repository[data-github-id="'+repo.id+'"]')

        it 'should be ided by data-github-full-name', ->
          expect(
            $('.repositories')[0]
          ).toContainElement(
            '.repository[data-github-full-name="'+repo.full_name+'"]'
          )

        it 'should display linked name in (.panel-heading .name)', ->
          link = @$repo.find('.panel-heading .name')[0]
          expect(link).toContainText(repo.name)
          expect(link).toHaveAttr('href', repo.html_url)

        it 'should display linked owner in (.panel-heading .owner)', ->
          link = @$repo.find('.panel-heading .owner')[0]
          expect(link).toContainText(repo.owner.login)
          expect(link).toHaveAttr('href', repo.owner.html_url)

        it 'should display linked watchers', ->
          link = @$repo.find('.panel-heading .watchers')[0]
          expect(link).toContainText(repo.watchers)
          expect(link).toHaveAttr('href', repo.html_url+'/watchers')

        it 'should display linked forks', ->
          link = @$repo.find('.panel-heading .forks')[0]
          expect(link).toContainText(repo.forks)
          expect(link).toHaveAttr('href', repo.html_url+'/forks')

        it 'should display description in (.panel-heading .description)', ->
          expect(
            @$repo.find('.panel-body .description')
          ).toContainText(repo.description)

        it 'should display language in .language', ->
          expect(
            @$repo.find('.language')
          ).toContainText(repo.language)

        it 'should display default_branch in .default_branch', ->
          expect(
            @$repo.find('.default_branch')
          ).toContainText(repo.default_branch)

        it 'should display pushed_at in .pushed_at', ->
          expect(
            @$repo.find('.pushed_at')
          ).toContainText('20')

        it 'should display link to zip in .archive', ->
          expect(
            @$repo.find('a.archive')
          ).toHaveAttr('href', repo.html_url+'/archive/master.zip')

