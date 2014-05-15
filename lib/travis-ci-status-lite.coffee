TravisCiStatusLiteView = require './travis-ci-status-lite-view'

module.exports =
  travisCiStatusLiteView: null

  activate: (state) ->
    @travisCiStatusLiteView = new TravisCiStatusLiteView(state.travisCiStatusLiteViewState)

  deactivate: ->
    @travisCiStatusLiteView.destroy()

  serialize: ->
    travisCiStatusLiteViewState: @travisCiStatusLiteView.serialize()
