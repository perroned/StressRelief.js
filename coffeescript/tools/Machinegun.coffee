class @Machinegun extends @Tool
  constructor: (@name) ->
    super @name
    @bullets = []
    @MAX_BULLETS = 5

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
      # produce random jitter for the bullet's location
      offsetX = randNum(-7, 7)
      offsetY = randNum(-7, 7)
      damage = PIXI.Sprite.fromImage("resources/images/tools/damage/bulletDamage#{randNum(0,3)}.png")
      damage.scale.x = damage.scale.y = .45
      damage.position.x = mCoords.x+offsetX
      damage.position.y = mCoords.y+offsetY
      App.tools.damages.push damage
      App.pondContainer.addChild(damage)

      # produce random jitter for the gun and shadow while shooting
      offsetX = randNum(-5, 5)
      offsetY = randNum(-5, 5)
      if (chances=randNum(0, 10)) > 4
        @flash.position.y = mCoords.y+5+offsetY
        @flash.position.x = mCoords.x-3+offsetX
        @flash.visible = true

      # spawn a bullet
      # switch to timing later... lazy
      if (chances=randNum(-100, 100)) > 90
        if @bullets.length < @MAX_BULLETS
          b = PIXI.Sprite.fromImage("resources/images/tools/damage/machinegunbullet.png")
          b.scale.x = b.scale.y = 2
          b.position.x = mCoords.x
          b.position.y = mCoords.y
          @bullets.push b
          App.pondContainer.addChild(b)

    @icon.position.y = mCoords.y+30+offsetY
    @icon.position.x = mCoords.x+10+offsetX
    @showShadow(mCoords, offsetX, offsetY)
    @crosshairs.position.y = mCoords.y - (@crosshairs.height/2)+offsetY
    @crosshairs.position.x = mCoords.x - (@crosshairs.height/2)+offsetX

    i = 0
    while i < @bullets.length
      @bullets[i].position.y += 1
      @bullets[i].position.x += randNum(-5,5)
      if @bullets[i].position.y > 500
        App.pondContainer.removeChild @bullets[i]
        @bullets.splice(i,1)
        App.sound = new Howl({
          urls: ['resources/sounds/machinegun_bullet_land.ogg']
        }).play()

      i++


  switchOff: ->
    super()
    @crosshairs.visible = false

  switchOn: ->
    super()
    @crosshairs.visible = true
