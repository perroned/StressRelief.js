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
    @damages ?= []
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

  switchOn: ->
    @shadow.visible = @icon.visible = true

@changeTool = (selection) ->
  $('#ToolsModal').foundation('reveal', "close")
  App.tools[App.currentTool].switchOff()
  App.currentTool = selection
  App.tools[App.currentTool].switchOn()

@cleanupDamage = ->
  for tool in App.tools
    tool.cleanUp()
  0

@setupTools = ->
  App.tools = []
  App.ToolEnum =
    HAMMER: 0
    CHAINSAW: 1
    MACHINEGUN: 2
    FLAMETHROWER: 3
    COLORTHROWER: 4
    PHASER: 5
    STAMPER: 6
    EXPLODER: 7
    TERMITES: 8
  App.currentTool = App.ToolEnum.HAMMER

  App.tools.push (new Hammer "Hammer")
  App.tools.push (new Chainsaw "Chainsaw")
  App.tools.push (new Machinegun "Machinegun")
  App.tools.push (new Flamethrower "Flamethrower")
  App.tools.push (new Colorthrower "Colorthrower")
  App.tools.push (new Phaser "Phaser")
  App.tools.push (new Stamper "Stamper")
  App.tools.push (new Exploder "Exploder")
  App.tools.push (new Termites "Termites")
  (tool.loadTool(); tool.switchOff()) for tool in App.tools
  @changeTool(App.currentTool)
  setupToolsMenu()

@setupToolsMenu = ->
  i = 0
  el = ''
  while i < App.tools.length
    tool = App.tools[i]
    el += '<tr>' if i % 3 is 0 or i is 0
    el += "<td class=\"toolSelector\" data-toolSelector=#{i}>"
    el += '<div id=\'b\'>'
    el += "<img src=\"resources/images/tools/tools/#{tool.name}.png\">"
    el += '<br/>'
    el += "<p id=\"title\">#{i+1}: #{tool.name}</p>"
    el += '</div>'
    el += '</td>'
    el += '</tr>' if (i+1) % 3 is 0 or i is App.tools.length-1
    i++

  $('#ToolsMenu').append el

  $("#cleanScreen").click ->
    cleanupDamage()
    $('#ToolsModal').foundation('reveal', 'close');

  $(".toolSelector").click ->
    $('#ToolsModal').foundation('reveal', 'close')
    changeTool parseInt(@getAttribute('data-toolSelector'))

@showTool = (isActive) ->
  for tool, i in App.tools
    tool.showTool(i is App.currentTool)
