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
  switchOff: -> @shadow.visible = @icon.visible = false
  switchOn: -> @shadow.visible = @icon.visible = true

@changeTool = (selection) ->
  App.tools[App.currentTool].switchOff()
  App.currentTool = selection
  App.tools[App.currentTool].switchOn()

@cleanupDamage = ->
  j = 0
  while j < App.tools.damages.length
    App.pondContainer.removeChild(App.tools.damages[j])
    j++
  App.tools.damages = []

@setupTools = ->
  App.tools = []
  App.tools.damages = []
  App.currentTool = 0
  App.tools.push (new Hammer "Hammer")
  App.tools.push (new Chainsaw "Chainsaw")
  (tool.loadTool(); tool.switchOff()) for tool in App.tools
  @changeTool(App.currentTool)

@showTool = ->
  App.tools[App.currentTool].showTool()
