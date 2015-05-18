class @Chainsaw extends @Tool
  constructor: (@name) ->
    super @name

  actionStart: ->
    super()

  actionFinish: ->
    super()

  loadTool: ->
    @icon = PIXI.Sprite.fromImage("resources/images/tools/tools/chainsaw.png")
    @icon.scale.x = @icon.scale.y = .5
    App.stage.addChild(@icon)

    @shadow = PIXI.Sprite.fromImage("resources/images/tools/tools/chainsaw.png")
    @shadow.scale.x = @shadow.scale.y = .5
    App.stage.addChild(@shadow)
    # darken the color. Set 50% transparency
    @shadow.tint = 0x151515
    @shadow.alpha = 0.5

  showShadow: (mCoords) ->
    @shadow.position.y = mCoords.y+40
    @shadow.position.x = mCoords.x+45

  showTool: ->
    mCoords = App.stage.getMousePosition()
    @icon.position.y = mCoords.y
    @icon.position.x = mCoords.x
    @showShadow(mCoords)

  switchOff: ->
    super()

  switchOn: ->
    super()
