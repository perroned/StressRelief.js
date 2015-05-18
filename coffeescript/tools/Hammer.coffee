class @Hammer extends @Tool
  constructor: (@name) ->
    super @name
    @damageIconCount = 3
    @areaToInspect = 5

  actionStart: ->
    super()
    damage = PIXI.Sprite.fromImage("resources/images/tools/damage/hammerDamage#{randNum(0, @damageIconCount)}.png")
    damage.scale.x = damage.scale.y = .6
    mCoords = App.stage.getMousePosition()
    damage.position.y = mCoords.y- 10
    damage.position.x = mCoords.x-40
    App.tools.damages.push damage
    App.pondContainer.addChild damage
    @icon.rotation =  @shadow.rotation = -.75
    @shadow.position.y = (@icon.position.y - 0)
    @shadow.position.x= (@icon.position.x - 30)
    @handleSmashSound(mCoords)

  actionFinish: ->
    super()
    @icon.rotation = @shadow.rotation = 0

  avgColorInHitArea: (mCoords) ->
    # take a square portion of pixels in the area clicked on
    data = App.renderer.view.getContext("2d").getImageData(
      mCoords.x-@areaToInspect,
      mCoords.y-@areaToInspect,
      @areaToInspect,
      @areaToInspect
    )
    # calculate the average color in the selected area
    i = c = red = green = blue = 0
    while i < data.data.length
      c = 0 if (c % 4 is 0)
      red+=data.data[i] if c is 0
      green+=data.data[i] if c is 1
      blue+=data.data[i] if c is 2
      i++; c++;

    red /= data.data.length
    green /= data.data.length
    blue /= data.data.length
    (red*0.299 + green*0.587 + blue*0.114) # calculate luminance

  handleSmashSound: (mCoords) ->
    # play noise (harder for the darker the area)
    luminance = @avgColorInHitArea(mCoords)
    if luminance > 40
      App.sound = new Howl({urls: ['resources/sounds/hammer_normal.ogg']}).play()
    else if luminance > 25
      App.sound = new Howl({urls: ['resources/sounds/hammer_used.ogg']}).play()
    else
      App.sound = new Howl({urls: ['resources/sounds/hammer_dead.ogg']}).play()

  loadTool: ->
    @icon = PIXI.Sprite.fromImage("resources/images/tools/tools/hammer.png")
    @icon.anchor.x = @icon.anchor.y = .5
    @icon.scale.x = @icon.scale.y = .5
    @shadow = PIXI.Sprite.fromImage("resources/images/tools/tools/hammer.png")
    @shadow.scale.x = @shadow.scale.y = .5
    # darken the color. Set 50% transparency
    @shadow.tint = 0x151515
    @shadow.alpha = 0.5
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
