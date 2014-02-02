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

    # Format date
    @formatDate = ( isoDate ) ->
      date = new Date(isoDate)
      return ("0"+date.getDate()).slice(-2) +
        '-' + ("0"+(date.getMonth()+1)).slice(-2) +
        '-' + date.getFullYear()

    # Coderwall badges
    @coderwall = ->
      # DOM element to use
      if @$element.find('div.badges').length>0
        # use existing div.badges if any
        $divBadges = @$element.find('div.badges')
      else
        # create a div.badges
        $divBadges = $('<div>').addClass('badges')
        @$element.append(
          $divBadges
        )

      # api url definition
      urlCoderwall = "http://www.coderwall.com/#{ @settings.user }.json"
      if @settings.coderwallForceJson
        urlCoderwall = @settings.coderwallForceJson

      # api call
      that = @
      $.ajax urlCoderwall,
        success: (data, textStatus, jqXHR) ->
          # Filter badges
          badges = data.badges.slice(0)
          for dataBadge in data.badges
            levels = new Array()
            for badge in data.badges
              if badge.name.indexOf(dataBadge.name)!=-1
                levels.push(badge)
            # keep only top levels badges
            if levels.length>1
              for level in levels when levels.indexOf(level) != levels.length-1
                badges.splice(badges.indexOf(level),1)

          # Display badges
          for dataBadge in badges
            $divBadges.append("""
<div class="cw-badge row"
  data-badge-name="#{ dataBadge.name }">
  <div class="col-sm-1 col-xs-2">
    <img src="#{ dataBadge.badge }"
      alt="#{ dataBadge.name }"
      class="img-responsive"
      style="margin-top:20px"/>
  </div>
  <div class="col-sm-11 col-xs-10">
    <h3 class="name">
      #{ dataBadge.name }
      <small class="created">#{ that.formatDate(dataBadge.created) }</small>
    </h3>
    <p class="description">#{ dataBadge.description }</p>
  </div>
</div>
""")

    # GitHub Repositories
    @github = ->
      # DOM element to use
      if @$element.find('div.repositories').length>0
        # use existing div.repositories if any
        repositories = @$element.find('div.repositories')[0]
      else
        # create a div.repositories
        repositories = $('<div>').addClass('repositories')
        @$element.append(
          repositories
        )

      # api url definition
      urlGithub = 'https://api.github.com/users/'+@settings.user+'/repos'
      if @settings.githubForceJson
        urlGithub = @settings.githubForceJson

      # api call
      settings = @settings
      that = @
      $.ajax urlGithub,
        success: (data, textStatus, jqXHR) ->
          for dataRepo in data
            # select DOM element to use for this repository
            cssRepo = "[data-github-full-name='#{ dataRepo.full_name }']"
            if $(repositories).find(cssRepo).length>0
              # div.repository already exists
              repository = $(repositories).find(cssRepo)[0]
            else
              if settings.allGithubRepos
                # create new div.repository
                repository = $('<div>').addClass('repository')
                $(repositories).append(repository)
              else
                # we don't want to display this repo
                break

            # Save Original Content
            origine = $(repository).contents()
            $(repository).empty()

            # Prepare content
            pushed_at = that.formatDate(dataRepo.pushed_at)
            if dataRepo.fork
              fork = '<span class="label label-warning">fork</span>'
            else
              fork = ''

            # Display repository
            $(repository).addClass("panel panel-default")
              .attr('data-github-id', dataRepo.id)
              .attr('data-github-full-name', dataRepo.full_name)
              .append("""
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
    <div class="description">#{ dataRepo.description }</div>
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
""")
            # Restore original content
            $(repository).children('.panel-body').append(origine)


    @init = ->
      @settings = $.extend( {}, @defaults, options )
      settings = @settings
      if @settings.github
        @github()
      if @settings.coderwall
        @coderwall()

      @setState 'ready'

    # initialise the plugin
    @init()

    # make the plugin chainable
    this

  # default plugin settings
  $.githubRepo::defaults =
      user: 'user'
      github: true
      githubForceJson: false
      allGithubRepos: true
      coderwall: true
      coderwallForceJson: false

  $.fn.githubRepo = ( options ) ->
    this.each ->
      if $( this ).data( 'githubRepo' ) is undefined
        plugin = new $.githubRepo( this, options )
        $( this).data( 'githubRepo', plugin )
