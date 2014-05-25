fs    = require 'fs'
path  = require 'path'
shell = require 'shell'

TravisCi        = require './travis-ci'
BuildStatusView = require './build-status-view'

module.exports =
  # Internal: The build status status bar entry view.
  buildStatusView: null

  # Internal: Active the package.
  #
  # Returns nothing.
  activate: ->
    return unless @isGitHubRepo() and @isTravisProject()

    atom.travis = new TravisCi

    atom.workspaceView.command 'travis-ci-status:open-on-travis', =>
      @openOnTravis()

    createStatusEntry = =>
      nwo = @getNameWithOwner()
      @buildStatusView = new BuildStatusView(nwo)

    if atom.workspaceView.statusBar
      createStatusEntry()
    else
      atom.packages.once 'activated', ->
        createStatusEntry()

  # Internal: Deactive the package and destroys any views.
  #
  # Returns nothing.
  deactivate: ->
    atom.travis = null
    @buildStatusView?.destroy()

  # Internal: Serialize each view state so it can be restored when activated.
  #
  # Returns an object containing key/value pairs of view state data.
  serialize: ->

  # Internal: Get whether the project repository exists and is hosted on GitHub.
  #
  # Returns true if the repository exists and is hosted on GitHub, else false.
  isGitHubRepo: ->
    repo = atom.project.getRepo()
    return false unless repo?
    /(.)*github\.com/i.test(repo.getOriginUrl())

  # Internal: Get the repoistory's name with owner.
  #
  # Returns a string of the name with owner, or null if the origin URL doesn't
  # exist.
  getNameWithOwner: ->
    repo = atom.project.getRepo()
    url  = repo.getOriginUrl()
    return null unless url?
    /([^\/:]+)\/([^\/]+)$/.exec(url.replace(/\.git$/, ''))[0]

  # Internal: Check there is a .travis.yml configuration file.
  #
  # Returns nothing.
  isTravisProject: (callback) ->
    return false unless atom.project.path?
    fs.existsSync(path.join(atom.project.path, '.travis.yml'))

  # Internal: Open the project on Travis CI in the default browser.
  #
  # Returns nothing.
  openOnTravis: ->
    nwo = @getNameWithOwner()
    shell.openExternal("https://travis-ci.org/#{nwo}")
