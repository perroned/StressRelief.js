class @Machinegun extends @Tool
  constructor: (@name) ->
    super @name

  actionStart: ->
    super()
    @crosshairs.visible = false

  actionFinish: ->
    super()
    @switchOn()
    @crosshairs.visible = true

  loadTool: ->
    @icon = PIXI.Sprite.fromImage("resources/images/tools/tools/machinegun.png")
    @icon.scale.x = @icon.scale.y = .5
    @shadow = PIXI.Sprite.fromImage("resources/images/tools/tools/machinegun.png")
    @shadow.scale.x = @shadow.scale.y = .5
    @crosshairs = PIXI.Sprite.fromImage("resources/images/tools/damage/machinegun_crosshairs2.png")
    @crosshairs.scale.x = @crosshairs.scale.y = .1
    # darken the color. Set 50% transparency
    @shadow.tint = 0x151515
    @shadow.alpha = 0.5
    App.stage.addChild(@crosshairs)
    super()

  showShadow: (mCoords, offsetX, offsetY) ->
    @shadow.position.y = mCoords.y+40+offsetY
    @shadow.position.x = mCoords.x+25+offsetX

  showTool: ->
    offsetX = offsetY = offsetY = 0
    if @isPressed()
      offsetX = randNum(-5, 5)
      offsetY = randNum(-5, 5)
    else
      do ->

    mCoords = App.stage.getMousePosition()
    @icon.position.y = mCoords.y+30+offsetY
    @icon.position.x = mCoords.x+10+offsetX
    @showShadow(mCoords, offsetX, offsetY)
    @crosshairs.position.y = mCoords.y - (@crosshairs.height/2)+offsetY
    @crosshairs.position.x = mCoords.x - (@crosshairs.height/2)+offsetX

  switchOff: ->
    super()

  switchOn: ->
    super()
    App?.sound?.stop?()
    # App.sound = new Howl({
    #   urls: ['resources/sounds/chainsaw_rev.ogg']
    #   loop: true
    # }).play()
