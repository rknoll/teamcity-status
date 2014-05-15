{View} = require 'atom'

module.exports =
class TravisCiStatusLiteView extends View
  @content: ->
    @div class: 'travis-ci-status-lite overlay from-top', =>
      @div "The TravisCiStatusLite package is Alive! It's ALIVE!", class: "message"

  initialize: (serializeState) ->
    atom.workspaceView.command "travis-ci-status-lite:toggle", => @toggle()

  # Returns an object that can be retrieved when package is activated
  serialize: ->

  # Tear down any state and detach
  destroy: ->
    @detach()

  toggle: ->
    console.log "TravisCiStatusLiteView was toggled!"
    if @hasParent()
      @detach()
    else
      atom.workspaceView.append(this)
