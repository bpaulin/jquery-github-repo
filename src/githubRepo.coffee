jQuery ->
  $.githubRepo = ( element, options ) ->
    # current state
    state = ''

    # plugin settings
    @settings = {}

    # jQuery version of DOM element attached to the plugin
    @$element = $ element

    # set current state
    @setState = ( _state ) -> state = _state

    #get current state
    @getState = -> state

    # get particular plugin setting
    @getSetting = ( key ) ->
      @settings[ key ]

    # call one of the plugin setting functions
    @callSettingFunction = ( name, args = [] ) ->
      @settings[name].apply( this, args )

    @init = ->
      @settings = $.extend( {}, @defaults, options )
      settings = @settings

      @$element.empty()

      # GitHub
      repositories = $('<div>').addClass('repositories')
      @$element.append(
        repositories
      )

      urlGithub = 'https://api.github.com/users/'+@settings.user+'/repos'
      if @settings.githubForceJson
        urlGithub = @settings.githubForceJson

      $.ajax urlGithub,
        success: (data, textStatus, jqXHR) ->
          for dataRepo in data
            # div du Heading
            divHeading = $('<div class="panel-heading">')
            spanFullName = $('<span class="name">')
            divHeading.append(spanFullName)
            # div du Body
            divBody = $('<div class="panel-body">')
            # div du Footer
            divFooter = $('<div class="panel-footer">')
            # div du Repo
            divRepo = $('<div class="repository panel panel-default">')
            divRepo
              .append(divHeading)
              .append(divBody)
              .append(divFooter)

            # Remplissage des données
            divRepo.attr('data-github-id', dataRepo.id)
            spanFullName.text(dataRepo.name)

            # Ajout au repositories
            repositories.append(
              divRepo
            )

      @setState 'ready'

    # initialise the plugin
    @init()

    # make the plugin chainable
    this

  # default plugin settings
  $.githubRepo::defaults =
      user: 'bpaulin'
      githubForceJson: false


  $.fn.githubRepo = ( options ) ->
    this.each ->
      if $( this ).data( 'githubRepo' ) is undefined
        plugin = new $.githubRepo( this, options )
        $( this).data( 'githubRepo', plugin )
