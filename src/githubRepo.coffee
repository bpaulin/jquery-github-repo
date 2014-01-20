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
      repo = @$element.data('repository')
      texte = @$element.html()
      @$element.empty()

      # Decoration du div
      @$element.addClass('panel panel-primary')
      heading = $('<div>').addClass('panel-heading')
              .append(repo)
      body = $('<div>').addClass('panel-body')
              .append(texte)
      footer = $('<div>').addClass('panel-footer')
              .append('http://github.com/'+repo)
      @$element.append(heading).append(body).append(footer)

      # Appel de l'API repo
      $.ajax 'https://api.github.com/repos/'+repo,
        success: (data, textStatus, jqXHR) ->
          # Heading
          heading.empty()
          heading.append $('<h1>')
                          .addClass('panel-title')
                          .append data.name
          heading.append $('<small>')
                          .append data.description

          # Footer
          footer.empty()
          footer.append $('<a>')
                          .attr('href', data.html_url)
                          .append(data.html_url)

          # Appel de l'API branches
          $.ajax 'https://api.github.com/repos/'+repo+'/branches',
            success: (data, textStatus, jqXHR) ->
              dl = $('<dl>')
                    .addClass("dl-horizontal")
              for index, branche of data
                # Appel de l'API branche
                $.ajax 'https://api.github.com/repos/'+
                        repo+'/branches/'+branche.name,
                  success: (data, textStatus, jqXHR) ->
                    dt = $('<dt>')
                          .append $('<a>')
                            .attr(
                              'href',
                              'http://github.com/'+repo+'/tree/'+data.name
                            )
                            .append data.name

                    dd = $('<dd>')
                    dd.append $('<span>')
                              .append data.commit.commit.author.date
                                .substring(0,10)
                    dd.append $('<img>')
                                .attr(
                                  'src',
                                  'https://travis-ci.org/'+
                                    repo+'.png?branch='+data.name
                                )
                    urlCommit = 'https://github.com/'+repo+
                                  '/commit/'+data.commit.sha
                    dd.append $('<a>')
                              .attr('href', urlCommit)
                              .append data.commit.commit.message
                                .substring(0,25)
                    dl.append dt
                    dl.append dd

              footer.append dl

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
