class @Machinegun extends @Tool
  constructor: (@name) ->
    super @name

  actionStart: ->
    super()
    @crosshairs.visible = false
    @flash.visible = true
    App.sound = new Howl({
      urls: ['resources/sounds/machinegun_shoot.ogg']
      loop: true
      sprite: {thing: [0, 100]}
    }).play("thing")

  actionFinish: ->
    super()
    @switchOn()
    App.sound = new Howl({urls: ['resources/sounds/machinegun_shoot.ogg']}).play()
    @crosshairs.visible = true
    @flash.visible = false

  loadTool: ->
    @icon = PIXI.Sprite.fromImage("resources/images/tools/tools/machinegun.png")
    @icon.scale.x = @icon.scale.y = .5
    @shadow = PIXI.Sprite.fromImage("resources/images/tools/tools/machinegun.png")
    @shadow.scale.x = @shadow.scale.y = .5
    @crosshairs = PIXI.Sprite.fromImage("resources/images/tools/damage/machinegun_crosshairs2.png")
    @crosshairs.scale.x = @crosshairs.scale.y = .1
    @flash = PIXI.Sprite.fromImage("resources/images/tools/damage/machinegun_fire.png")
    @flash.scale.x = @flash.scale.y = 1
    # darken the color. Set 50% transparency
    @shadow.tint = 0x151515
    @shadow.alpha = 0.5
    App.stage.addChild(@crosshairs)
    App.stage.addChild(@flash)
    super()

  showShadow: (mCoords, offsetX, offsetY) ->
    @shadow.position.y = mCoords.y+40+offsetY
    @shadow.position.x = mCoords.x+25+offsetX

  showTool: ->
    mCoords = App.stage.getMousePosition()
    offsetX = offsetY = offsetY = 0
    @flash.visible = false
    if @isPressed()
      offsetX = randNum(-5, 5)
      offsetY = randNum(-5, 5)
      if randNum(0, 10) > 4
        @flash.position.y = mCoords.y+5+offsetY
        @flash.position.x = mCoords.x-3+offsetX
        @flash.visible = true
    else
      do ->


    @icon.position.y = mCoords.y+30+offsetY
    @icon.position.x = mCoords.x+10+offsetX
    @showShadow(mCoords, offsetX, offsetY)
    @crosshairs.position.y = mCoords.y - (@crosshairs.height/2)+offsetY
    @crosshairs.position.x = mCoords.x - (@crosshairs.height/2)+offsetX

  switchOff: ->
    super()

  switchOn: ->
    super()
