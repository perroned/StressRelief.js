class @Stamper extends @Tool
  constructor: (@name) ->
    super @name
    @damageIconCount = 10
    @dropAmount = 30

  actionStart: ->
    super()
    damage = PIXI.Sprite.fromImage("resources/images/tools/damage/stamps/stamp_#{randNum(0, @damageIconCount)}.png")
    damage.scale.x = damage.scale.y = .5
    mCoords = App.stage.getMousePosition()
    damage.position.y = mCoords.y+@dropAmount+10
    damage.position.x = mCoords.x
    @damages.push damage
    App.pondContainer.addChild damage
    @icon.position.y = @icon.position.y + @dropAmount
    @handleStampSound()
    @shadow.position.x = mCoords.x+@icon.width+25-@dropAmount

  actionFinish: ->
    super()
    @icon.position.y = @icon.position.y - @dropAmount

  cleanUp: ->
    super()

  handleStampSound: ->
    App.sound.stamper = new Howl({urls: ['resources/sounds/stamper.ogg']}).play()

  loadTool: ->
    @icon = PIXI.Sprite.fromImage("resources/images/tools/tools/stamper.png")
    @icon.anchor.x = @icon.anchor.y = .5
    @icon.scale.x = .7
    @icon.scale.y = .4
    @shadow = PIXI.Sprite.fromImage("resources/images/tools/tools/stamper.png")
    @shadow.scale.x = .4
    @shadow.scale.y = .7
    @shadow.anchor.x = @shadow.anchor.y = .5
    @shadow.rotation = 45 * Math.PI / 2
    # darken the color. Set 50% transparency
    @shadow.tint = 0x151515
    @shadow.alpha = 0.5
    super()

  showShadow: (mCoords) ->
    @shadow.position.y = mCoords.y+@icon.height-7
    @shadow.position.x = mCoords.x+@icon.width+25

  showTool: (isActive) ->
    return if not isActive

    if not @isPressed()
      mCoords = App.stage.getMousePosition()
      @icon.position.y = mCoords.y+20
      @icon.position.x = mCoords.x+20
      @showShadow(mCoords)

  switchOff: ->
    super()
    App.sound.stamper?.stop()

  switchOn: ->
    super()
