class @Tool
  icon = null
  shadow = null
  damageIconCount = 0
  constructor: (@name) ->
  doAction: ->
  getName: -> @name
  loadTool: ->
  showShadow: ->
  showTool: ->

@cleanupDamage = ->
  j = 0
  while j < App.tools.damages.length
    App.pondContainer.removeChild(App.tools.damages[j])
    j++
  App.tools.damages = []

@setupTools = ->
  App.tools = []
  App.tools.push (new Hammer "Hammer")
  App.tools.push (new Chainsaw "Chainsaw")
  App.currentTool = 0
  tool.loadTool() for tool in App.tools
  App.tools.damages = []

@showTool = ->
  App.tools[App.currentTool].showTool()
