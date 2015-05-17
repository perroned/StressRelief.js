class @Hammer extends @Tool
  constructor: (@name) ->
    super @name
    @damageIconCount = 3

  doAction: ->
    hammer = PIXI.Sprite.fromImage("images/tools/damage/hammerDamage#{randNum(0, @damageIconCount)}.png")
    hammer.scale.x = hammer.scale.y = .6
    mCoords = App.stage.getMousePosition()
    hammer.position.y = mCoords.y
    hammer.position.x = mCoords.x
    App.tools.damages.push hammer
    App.pondContainer.addChild hammer

  loadTool: ->
    @icon = PIXI.Sprite.fromImage("images/tools/tools/hammer.png")
    @icon.scale.x = @icon.scale.y = .5
    App.stage.addChild(@icon)

    @shadow = PIXI.Sprite.fromImage("images/tools/tools/hammer.png")
    @shadow.scale.x = @shadow.scale.y = .5
    App.stage.addChild(@shadow)
    # darken every color. Set 50% transparency
    shadeMatrix =  [0,0,0,-.5,0,0,0,-.5,0,0,0,-.5,0,0,0,.5];
    shadeFilter = new PIXI.ColorMatrixFilter()
    shadeFilter.matrix = shadeMatrix
    @shadow.filters=[shadeFilter]
    @shadow.anchor.x = @shadow.anchor.y = .5
    @shadow.rotation = .70

  showShadow: (mCoords) ->
    @shadow.position.y = mCoords.y+50
    @shadow.position.x = mCoords.x+50

  showTool: ->
    mCoords = App.stage.getMousePosition()
    @icon.position.y = mCoords.y
    @icon.position.x = mCoords.x
    @showShadow(mCoords)
