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
            date = new Date(dataRepo.pushed_at)
            pushed_at = ("0"+date.getDate()).slice(-2) +
              '-' + ("0"+(date.getMonth()+1)).slice(-2) +
              '-' + date.getFullYear()
            fork = ''
            if dataRepo.fork
              fork = '<span class="label label-warning">fork</span>'
            template =
            """
<div class="repository panel panel-default"
  data-github-id="#{ dataRepo.id }"
  data-github-full-name="#{ dataRepo.full_name }">
  <div class="panel-heading">
    <strong>
      <a href="#{ dataRepo.owner.html_url }" class="owner">
        #{ dataRepo.owner.login }</a> /
      <a href="#{ dataRepo.html_url }" class="name">
        #{ dataRepo.name }</a>
    </strong>
    <div class="pull-right btn-group btn-group-xs">
      <a href="#{ dataRepo.html_url }/watchers"
          class="btn btn-default watchers">
        <i class="fa fa-eye"></i> #{ dataRepo.watchers }
      </a>
      <a href="#{ dataRepo.html_url }/forks" class="btn btn-default forks">
        <i class="fa fa-code-fork"></i> #{dataRepo.forks }
      </a>
    </div>
    <div class="spacer" style="clear: both;"></div>
  </div>
  <div class="panel-body">
    <span class="description">#{ dataRepo.description }</span>
  </div>
  <div class="panel-footer">
    #{ fork }
    <span class="label label-primary language">
      #{ dataRepo.language }
    </span>
    <div class="pull-right">
      <small>
        Dernier commit sur
        <strong class="default_branch">#{ dataRepo.default_branch }</strong>
        le <span class="pushed_at">#{ pushed_at }</pushed_at>
      </small>
      <a href="#{ dataRepo.html_url }/archive/master.zip"
          class="archive btn btn-default btn-xs">
        <i class="fa fa-download"></i>
      </a>
    </div>
  </div>
</div>
"""
            # Ajout au repositories
            repositories.append(
              $(template)
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
