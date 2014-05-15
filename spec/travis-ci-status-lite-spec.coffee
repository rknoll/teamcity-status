{WorkspaceView} = require 'atom'
TravisCiStatusLite = require '../lib/travis-ci-status-lite'

# Use the command `window:run-package-specs` (cmd-alt-ctrl-p) to run specs.
#
# To run a specific `it` or `describe` block add an `f` to the front (e.g. `fit`
# or `fdescribe`). Remove the `f` to unfocus the block.

describe "TravisCiStatusLite", ->
  activationPromise = null

  beforeEach ->
    atom.workspaceView = new WorkspaceView
    activationPromise = atom.packages.activatePackage('travis-ci-status-lite')

  describe "when the travis-ci-status-lite:toggle event is triggered", ->
    it "attaches and then detaches the view", ->
      expect(atom.workspaceView.find('.travis-ci-status-lite')).not.toExist()

      # This is an activation event, triggering it will cause the package to be
      # activated.
      atom.workspaceView.trigger 'travis-ci-status-lite:toggle'

      waitsForPromise ->
        activationPromise

      runs ->
        expect(atom.workspaceView.find('.travis-ci-status-lite')).toExist()
        atom.workspaceView.trigger 'travis-ci-status-lite:toggle'
        expect(atom.workspaceView.find('.travis-ci-status-lite')).not.toExist()
