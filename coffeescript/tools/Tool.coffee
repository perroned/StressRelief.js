@setupTools = ->
  App.tools = []
  App.tools.push (new Hammer "Hammer")
  App.tools.push (new Chainsaw "Chainsaw")
  App.currentTool = 0
  tool.loadTool() for tool in App.tools
  App.tools.damages = []

@showTool = ->
  App.tools[App.currentTool].showTool()

class @Tool
  icon = null
  damageIconCount = 0
  constructor: (@name) ->
  doAction: ->
  getName: -> @name
  loadTool: ->
  showShadow: ->
  showTool: ->
