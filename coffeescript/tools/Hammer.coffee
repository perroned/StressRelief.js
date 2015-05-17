class @Hammer extends @Tool
  constructor: (@name) ->
    super @name
    @damageIconCount = 3

  doAction: ->
    console.log "using hammer"
    d = PIXI.Sprite.fromImage("images/tools/damage/hammerDamage#{randNum(0, @damageIconCount)}.png")
    d.scale.x = d.scale.y = .6
    mCoords = App.stage.getMousePosition()
    d.position.y = mCoords.y
    d.position.x = mCoords.x
    App.tools.damages.push d
    App.pondContainer.addChild d

  loadTool: ->
    @icon = PIXI.Sprite.fromImage("images/tools/tools/hammer.png")
    @icon.scale.x = @icon.scale.y = .5
    App.stage.addChild(@icon)

  showShadow: ->

  showTool: ->
    mCoords = App.stage.getMousePosition()
    @icon.position.y = mCoords.y
    @icon.position.x = mCoords.x
    @showShadow()
