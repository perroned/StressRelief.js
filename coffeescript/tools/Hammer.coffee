class @Hammer extends @Tool
  pressed = false
  constructor: (@name) ->
    super @name
    @damageIconCount = 3

  actionStart: ->
    super()
    damage = PIXI.Sprite.fromImage("images/tools/damage/hammerDamage#{randNum(0, @damageIconCount)}.png")
    damage.scale.x = damage.scale.y = .6
    mCoords = App.stage.getMousePosition()
    damage.position.y = mCoords.y- 10
    damage.position.x = mCoords.x-40
    App.tools.damages.push damage
    App.pondContainer.addChild damage

    @icon.rotation =  @shadow.rotation = -.75
    @shadow.position.y = (@icon.position.y - 0)
    @shadow.position.x= (@icon.position.x - 30)

  actionFinish: ->
    super()
    @icon.rotation = @shadow.rotation = 0

  loadTool: ->
    @icon = PIXI.Sprite.fromImage("images/tools/tools/hammer.png")
    @icon.anchor.x = @icon.anchor.y = .5
    @icon.scale.x = @icon.scale.y = .5
    @shadow = PIXI.Sprite.fromImage("images/tools/tools/hammer.png")
    @shadow.scale.x = @shadow.scale.y = .5
    # darken every color. Set 50% transparency
    shadeMatrix =  [0,0,0,-.5,0,0,0,-.5,0,0,0,-.5,0,0,0,.5];
    shadeFilter = new PIXI.ColorMatrixFilter()
    shadeFilter.matrix = shadeMatrix
    @shadow.filters=[shadeFilter]
    # place shadow behind icon
    App.stage.addChild(@shadow)
    App.stage.addChild(@icon)

  showShadow: (mCoords) ->
    @shadow.position.y = mCoords.y+30
    @shadow.position.x = mCoords.x

  showTool: ->
    if not @isPressed()
      mCoords = App.stage.getMousePosition()
      @icon.position.y = mCoords.y+30
      @icon.position.x = mCoords.x
      @showShadow(mCoords)

  switchOff: ->
    super()

  switchOn: ->
    super()
