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
      texte = @$element.html()
      @$element.empty()

      # Decoration du div
      @$element.addClass('panel panel-primary')
      heading = $('<div>').addClass('panel-heading')
              .append(@$element.data('repository'))
      body = $('<div>').addClass('panel-body')
              .append(texte)
      footer = $('<div>').addClass('panel-footer')
              .append('http://github.com/'+@$element.data('repository'))
      @$element.append(heading).append(body).append(footer)

      # Appel de l'API
      $.ajax 'https://api.github.com/repos/'+@$element.data('repository'),
        success: (data, textStatus, jqXHR) ->
          # Heading
          heading.empty()
          heading.append $('<h1>').addClass('panel-title').append(data.name)
          heading.append $('<small>').append data.description

          # Body

          # Footer
          footer.empty()
          footer.append $('<a>').attr('href', data.url).append(data.url)

      @setState 'ready'

    # initialise the plugin
    @init()

    # make the plugin chainable
    this

  # default plugin settings
  $.githubRepo::defaults =
      message: 'Hello world'  # option description

  $.fn.githubRepo = ( options ) ->
    this.each ->
      if $( this ).data( 'githubRepo' ) is undefined
        plugin = new $.githubRepo( this, options )
        $( this).data( 'githubRepo', plugin )