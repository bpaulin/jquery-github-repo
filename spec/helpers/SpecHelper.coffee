beforeEach ->
  getJSONFixture 'github_user.json'
  loadFixtures 'origin.html'
  spyOn($, 'ajax').and.callFake (req, obj) ->
    obj.success(getJSONFixture 'github_user.json')
