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

      $.ajax 'https://api.github.com/users/'+@settings.user+'/repos',
        success: (data, textStatus, jqXHR) ->
          for dataRepo in data
            repository = $('<div class="repository panel panel-default">')
              .attr('data-github-id', dataRepo.id)
              .append($('<div class="panel-heading">'))
              .append($('<div class="panel-body">'))
              .append($('<div class="panel-footer">'))
            repositories.append(
              repository
            )

      @setState 'ready'

    # initialise the plugin
    @init()

    # make the plugin chainable
    this

  # default plugin settings
  $.githubRepo::defaults =
      user: 'bpaulin'

  $.fn.githubRepo = ( options ) ->
    this.each ->
      if $( this ).data( 'githubRepo' ) is undefined
        plugin = new $.githubRepo( this, options )
        $( this).data( 'githubRepo', plugin )
