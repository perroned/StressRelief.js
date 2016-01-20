class @Flamethrower extends @Tool
	@SHOOT_DISTANCE: 60
	shadowOffsetY = 40
	shadowOffsetX = 25
	iconOffsetY = 30
	iconOffsetX = 10
	maxFireballs = 20
	fireballScale = .15
	fireballOffsetY = 25
	fireballOffsetX = 5
	fireballTurningSpeed = .8
	fireballMinLifeTime = 4
	fireballMaxLifeTime = 8
	fireballScaleIncrease = 0.006
	fireBurnTimeout = 2000

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
		@icon = PIXI.Sprite.fromImage("../images/tools/tools/flamethrower.png")
		@icon.scale.x = @icon.scale.y = .5
		@shadow = PIXI.Sprite.fromImage("../images/tools/tools/flamethrower.png")
		@shadow.scale.x = @shadow.scale.y = .5
		# darken the color. Set 50% transparency
		@shadow.tint = @shadowTint
		@shadow.alpha = 0.5
		super()

	showShadow: (mCoords) ->
		@shadow.position.y = mCoords.y + shadowOffsetY
		@shadow.position.x = mCoords.x + shadowOffsetX

	showTool: (isActive) ->
		if isActive
			mCoords = App.stage.getMousePosition()
			@icon.position.y = mCoords.y + iconOffsetY
			@icon.position.x = mCoords.x + iconOffsetX
			@showShadow(mCoords)

			if @isPressed()
				# spawn a fireball every 20ms or immediately if there are none
				if ((Date.now()-@lastFireballSpawn) > maxFireballs) or @lastFireballSpawn is 0
					@lastFireballSpawn = Date.now()
					fireball = PIXI.Sprite.fromImage("../images/tools/damage/fireball.png")
					fireball.scale.x = fireball.scale.y = fireballScale
					fireball.position.x = mCoords.x + fireballOffsetX
					fireball.position.y = mCoords.y + fireballOffsetY
					fireball.timeCreated = Date.now() # when it was created
					fireball.lifetime = randNum(fireballMinLifeTime,fireballMaxLifeTime)*1000 # how long it will last
					fireball.direction = Math.random() * Math.PI * 2
					fireball.speed = .1
					fireball.turnSpeed = Math.random() - fireballTurningSpeed
					fireball.lastBurn = 0 # the last time a burn mark was drawn
					fireball.startY = fireball.position.y
					fireball.startX = fireball.position.x
					fireball.landed = false
					@fireballs.push fireball
					App.mainContainer.addChild(fireball)

		# if there are no more flames stop the audio
		if @fireballs.length is 0
			@sound_Crackle false

		# process every fireball
		i = 0
		while i < @fireballs.length
			fireball = @fireballs[i]
			# move the fireball until it has 'landed'
			if not fireball.landed
				if fireball.position.y < (fireball.startY-Flamethrower.SHOOT_DISTANCE) and fireball.position.x < (fireball.startX-Flamethrower.SHOOT_DISTANCE)
					fireball.landed = true
					App.tools[App.ToolEnum.TERMITES].termiteCheck(fireball)
				else
					fireball.position.x -= 1
					fireball.position.y -= 1
					fireball.scale.x = fireball.scale.y += fireballScaleIncrease

			# animate the fire ball
			fireball.direction += fireball.turnSpeed * 0.01
			fireball.position.x += Math.sin(fireball.direction) * fireball.speed
			fireball.position.y += Math.cos(fireball.direction) * fireball.speed
			fireball.rotation = randNum(1,6)/100

			# draw a new burn mark for each fireball every 2 seconds
			if fireball.landed and Date.now() - fireball.lastBurn > fireBurnTimeout
				fireball.lastBurn = Date.now()
				burn = PIXI.Sprite.fromImage("../images/tools/damage/fireburn#{randNum(0,2)}.png")
				burn.scale.x = burn.scale.y = .5
				burn.position.x = fireball.position.x
				burn.position.y = fireball.position.y
				burn.alpha = .5
				@damages.push burn
				App.mainContainer.addChild(burn)
				# keep the fireballs on top of the burns
				App.mainContainer.removeChild fireball
				App.mainContainer.addChild fireball

			# if the fireball has reached its life expectancy remove it
			if Date.now() - fireball.timeCreated > fireball.lifetime
				App.mainContainer.removeChild fireball
				@fireballs.splice(i,1)

			i++

	# the sound the flamethrower makes while it is being used
	sound_Spread: (start) ->
		App.sound.flamethrower_spread?.stop()
		if start
			App.sound.flamethrower_spread = new Howl({
				urls: ['../sounds/flamethrower_spread.ogg']
				loop: true
			}).play()

	# for dying fireballs
	sound_Crackle: (start) ->
		App.sound.flamethrower_crackle?.stop()
		if start
			App.sound.flamethrower_crackle = new Howl({
				urls: ['../sounds/flamethrower_crackle.ogg']
				loop: true
			}).play()

	switchOff: ->
		super()
		@sound_Spread false

	switchOn: ->
		super()
