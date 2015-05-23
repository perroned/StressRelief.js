class @Tool
  constructor: (@name) ->
    @damageIconCount = 0
    @damages = []
    @icon = null
    @pressed = false
    @shadow = null
  actionStart: -> @pressed = true
  actionFinish: -> @pressed = false
  cleanUp: (additional) ->
    additional ?= []
    for d in ([@damages].concat additional)
      i = 0
      while i < d.length
        App.pondContainer.removeChild d[i]
        i++
    @damages = []
    []

  getName: -> @name
  isPressed: ->
    @pressed

  loadTool: ->
    # place shadow behind icon
    App.stage.addChild(@shadow) if @shadow?
    App.stage.addChild(@icon) if @icon?

  showShadow: ->
  showTool: ->
  switchOff: ->
    @shadow.visible = @icon.visible = false
    App?.sound?.stop?()

  switchOn: ->
    @shadow.visible = @icon.visible = true
    App?.sound?.stop?()

@changeTool = (selection) ->
  App.tools[App.currentTool].switchOff()
  App.currentTool = selection
  App.tools[App.currentTool].switchOn()

@cleanupDamage = ->
  for tool in App.tools
    tool.cleanUp()
  0

@setupTools = ->
  App.tools = []
  App.currentTool = 0
  App.tools.push (new Hammer "Hammer")
  App.tools.push (new Chainsaw "Chainsaw")
  App.tools.push (new Machinegun "Machinegun")
  App.tools.push (new Flamethrower "Flamethrower")
  App.tools.push (new Colorthrower "Colorthrower")
  App.tools.push (new Phaser "Phaser")
  App.tools.push (new Stamper "Stamper")
  (tool.loadTool(); tool.switchOff()) for tool in App.tools
  @changeTool(App.currentTool)

@showTool = (isActive) ->
  for tool, i in App.tools
    tool.showTool(i is App.currentTool)
