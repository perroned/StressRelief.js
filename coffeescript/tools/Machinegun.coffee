class @Machinegun extends @Tool
  constructor: (@name) ->
    super @name
    @bullets = []
    @lastBulletSpawn = 0

  actionStart: ->
    super()
    @crosshairs.visible = false
    @flash.visible = true

  actionFinish: ->
    super()
    @switchOn()
    App.sound.machinegun_shoot = new Howl({urls: ['resources/sounds/machinegun_shoot.ogg']}).play()
    @crosshairs.visible = true
    @flash.visible = false

  cleanUp: ->
    @bullets = super([@bullets])

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

  showTool: (isActive) ->
    if isActive
      mCoords = App.stage.getMousePosition()
      offsetX = offsetY = 0
      @flash.visible = false
      if @isPressed()
        App.sound.machinegun_shoot = new Howl({
          urls: ['resources/sounds/machinegun_shoot.ogg']
        }).play()

        # produce random jitter for the bullet's location
        offsetX = randNum(-7, 7)
        offsetY = randNum(-7, 7)
        damage = PIXI.Sprite.fromImage("resources/images/tools/damage/bulletDamage#{randNum(0,3)}.png")
        damage.scale.x = damage.scale.y = .45
        damage.position.x = mCoords.x+offsetX
        damage.position.y = mCoords.y+offsetY
        @damages.push damage
        App.pondContainer.addChild(damage)
        App.tools[App.ToolEnum.EXPLODER].newExplosion(posX: damage.position.x, posY: damage.position.y, removeAfterDone: true, scaleX: 0.1, scaleY: 0.1, loop: false, animationSpeed: 1)

        # produce random jitter for the gun and shadow while shooting
        offsetX = randNum(-5, 5)
        offsetY = randNum(-5, 5)
        if (chances=randNum(0, 10)) > 4
          @flash.position.y = mCoords.y+5+offsetY
          @flash.position.x = mCoords.x-3+offsetX
          @flash.visible = true

        # spawn a bullet
        if ((Date.now()-@lastBulletSpawn) > 100) or @lastBulletSpawn is 0
          @lastBulletSpawn = Date.now()
          b = PIXI.Sprite.fromImage("resources/images/tools/damage/machinegunbullet.png")
          b.scale.x = b.scale.y = .7
          b.position.x = mCoords.x + @icon.width+5
          b.position.y = mCoords.y + @icon.height+5
          b.speed = 1
          b.maxHeight = b.position.y - randNum(50,150)
          @bullets.push b
          App.pondContainer.addChild(b)

      @icon.position.y = mCoords.y+30+offsetY
      @icon.position.x = mCoords.x+10+offsetX
      @showShadow(mCoords, offsetX, offsetY)
      @crosshairs.position.y = mCoords.y - (@crosshairs.height/2)+offsetY
      @crosshairs.position.x = mCoords.x - (@crosshairs.height/2)+offsetX

    i = 0
    while i < @bullets.length
      if @bullets[i].position.y > @bullets[i].maxHeight
        @bullets[i].position.y -= 5 + -@bullets[i].speed
        @bullets[i].speed -= .05
      else
        @bullets[i].position.y += 1+ @bullets[i].speed
        @bullets[i].speed += .1
        @bullets[i].maxHeight=5000

      @bullets[i].position.x += 4
      @bullets[i].anchor.x = @bullets[i].anchor.y = .5
      @bullets[i].rotation += .3
      if @bullets[i].position.y > 500
        App.pondContainer.removeChild @bullets[i]
        @bullets.splice(i,1)
        App.sound.machinegun_bullet_land = new Howl({
          urls: ['resources/sounds/machinegun_bullet_land.ogg']
        }).play()

      i++

  switchOff: ->
    super()
    @crosshairs.visible = false
    @flash.visible = false
    App.sound.machinegun_bullet_land?.stop()
    App.sound.machinegun_shoot?.stop()

  switchOn: ->
    super()
    @crosshairs.visible = true
