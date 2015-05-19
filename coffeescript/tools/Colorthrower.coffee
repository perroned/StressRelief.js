class @Colorthrower extends @Tool
  constructor: (@name) ->
    super @name

  actionStart: ->
    super()

  actionFinish: ->
    super()
    @switchOn()

  loadTool: ->
    @icon = PIXI.Sprite.fromImage("resources/images/tools/tools/colorthrower.png")
    @icon.scale.x = @icon.scale.y = .5
    @shadow = PIXI.Sprite.fromImage("resources/images/tools/tools/colorthrower.png")
    @shadow.scale.x = @shadow.scale.y = .5
    # darken the color. Set 50% transparency
    @shadow.tint = 0x151515
    @shadow.alpha = 0.5
    super()

  showShadow: (mCoords) ->
    @shadow.position.y = @icon.position.y + 10
    @shadow.position.x = @icon.position.x + 50

  showTool: ->
    mCoords = App.stage.getMousePosition()
    @icon.position.y = mCoords.y+30
    @icon.position.x = mCoords.x+10
    @showShadow(mCoords)

  switchOff: ->
    super()

  switchOn: ->
    super()
