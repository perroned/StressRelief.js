class @Flamethrower extends @Tool
  constructor: (@name) ->
    super @name
    @fireballs = []
    @lastFireballSpawn = 0

  actionStart: ->
    super()
    @sound_Spread true

  actionFinish: ->
    super()
    @switchOn()
    @sound_Spread false
    @sound_Crackle true

  cleanUp: ->
    @fireballs = super([@fireballs])
    @sound_Spread false
    @sound_Crackle false

  loadTool: ->
    @icon = PIXI.Sprite.fromImage("resources/images/tools/tools/flamethrower.png")
    @icon.scale.x = @icon.scale.y = .5
    @shadow = PIXI.Sprite.fromImage("resources/images/tools/tools/flamethrower.png")
    @shadow.scale.x = @shadow.scale.y = .5
    # darken the color. Set 50% transparency
    @shadow.tint = 0x151515
    @shadow.alpha = 0.5
    super()

  showShadow: (mCoords) ->
    @shadow.position.y = mCoords.y+40
    @shadow.position.x = mCoords.x+25

  showTool: (isActive) ->
    if isActive
      mCoords = App.stage.getMousePosition()
      @icon.position.y = mCoords.y+30
      @icon.position.x = mCoords.x+10
      @showShadow(mCoords)

      if @isPressed()
        # spawn a fireball every 20ms or immediately if there are none
        if ((Date.now()-@lastFireballSpawn) > 20) or @lastFireballSpawn is 0
          @lastFireballSpawn = Date.now()
          fireball = PIXI.Sprite.fromImage("resources/images/tools/damage/fireball.png")
          fireball.scale.x = fireball.scale.y = .45
          fireball.position.x = mCoords.x
          fireball.position.y = mCoords.y
          fireball.timeCreated = Date.now() # when it was created
          fireball.lifetime = randNum(4,8)*1000 # how long it will last
          fireball.direction = Math.random() * Math.PI * 2
          fireball.speed = .1
          fireball.turnSpeed = Math.random() - 0.8
          fireball.lastBurn = 0 # the last time a burn mark was drawn
          @fireballs.push fireball
          App.pondContainer.addChild(fireball)

    # if there are no more flames stop the audio
    if @fireballs.length is 0
      @sound_Crackle false

    # process every fireball
    i = 0
    while i < @fireballs.length
      fireball = @fireballs[i]
      # animate the fire ball
      fireball.direction += @fireballs[i].turnSpeed * 0.01
      fireball.position.x += Math.sin(@fireballs[i].direction) * @fireballs[i].speed
      fireball.position.y += Math.cos(@fireballs[i].direction) * @fireballs[i].speed
      fireball.rotation = randNum(1,6)/100

      # draw a new burn mark for each fireball every 2 seconds
      if Date.now()-@fireballs[i].lastBurn > 2000
        @fireballs[i].lastBurn = Date.now()
        burn = PIXI.Sprite.fromImage("resources/images/tools/damage/fireburn#{randNum(0,2)}.png")
        burn.scale.x = burn.scale.y = .5
        burn.position.x = @fireballs[i].position.x
        burn.position.y = @fireballs[i].position.y
        burn.alpha = .5
        @damages.push burn
        App.pondContainer.addChild(burn)
        # keep the fireballs on top of the burns
        App.pondContainer.removeChild @fireballs[i]
        App.pondContainer.addChild @fireballs[i]

      # if the fireball has reached its life expectancy remove it
      if Date.now()-@fireballs[i].timeCreated > @fireballs[i].lifetime
        App.pondContainer.removeChild @fireballs[i]
        @fireballs.splice(i,1)

      i++

  sound_Spread: (start) ->
    App.sound.flamethrower_spread?.stop()
    if start
      App.sound.flamethrower_spread = new Howl({
        urls: ['resources/sounds/flamethrower_spread.ogg']
        loop: true
      }).play()

  sound_Crackle: (start) ->
    App.sound.flamethrower_crackle?.stop()
    if start
      App.sound.flamethrower_crackle = new Howl({
        urls: ['resources/sounds/flamethrower_crackle.ogg']
        loop: true
      }).play()

  switchOff: ->
    super()
    @sound_Spread false

  switchOn: ->
    super()
