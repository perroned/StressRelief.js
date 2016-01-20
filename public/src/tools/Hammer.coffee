class @Hammer extends @Tool
	luminanceRed = 0.299
	luminanceGreen = 0.587
	luminanceBlue = 0.114
	luminanceUpper = 30
	luminanceLower = 15
	hammerOffset = 20
	damageScale = .6
	iconAngle = .75
	iconOffsetX = 5
	shadowOffsetY = 0
	shadowOffsetX = 30

	constructor: (@name) ->
		super @name
		@damageIconCount = 3
		@areaToInspect = 5

	actionStart: ->
		super()
		mCoords = App.stage.getMousePosition()
		damage = PIXI.Sprite.fromImage("../images/tools/damage/hammerDamage#{randNum(0, @damageIconCount)}.png")
		damage.scale.x = damage.scale.y = damageScale
		damage.position.y = mCoords.y
		damage.position.x = mCoords.x
		App.tools[App.ToolEnum.TERMITES].termiteCheck(damage)
		# randomly angle the randomly selected damage sprite
		damage.anchor.x = damage.anchor.y = .5
		damage.rotation = Math.random() * 360
		@damages.push damage
		App.pondContainer.addChild damage
		@icon.rotation =	@shadow.rotation = -iconAngle
		@icon.position.x = @icon.position.x - iconOffsetX
		@shadow.position.y = @icon.position.y - shadowOffsetY
		@shadow.position.x = @icon.position.x - shadowOffsetX
		@handleSmashSound(mCoords)

	actionFinish: ->
		super()
		@icon.rotation = @shadow.rotation = 0

	# determine what the average color of pixels in the area
	# beneath the ahmmer strike
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
			# 4 = [red, green, blue, alpha]
			c = 0 if (c % 4 is 0)
			red+=data.data[i] if c is 0
			green+=data.data[i] if c is 1
			blue+=data.data[i] if c is 2
			i++; c++;

		red /= data.data.length
		green /= data.data.length
		blue /= data.data.length
		(red*luminanceRed + green*luminanceGreen + blue*luminanceBlue) # calculate luminance

	cleanUp: ->
		super()

	handleSmashSound: (mCoords) ->
		# play noise (harder for the darker the area)
		luminance = @avgColorInHitArea(mCoords)
		if luminance > luminanceUpper
			App.sound.hammer_normal = new Howl({urls: ['../sounds/hammer_normal.ogg']}).play()
		else if luminance > luminanceLower
			App.sound.hammer_used = new Howl({urls: ['../sounds/hammer_used.ogg']}).play()
		else
			App.sound.hammer_dead = new Howl({urls: ['../sounds/hammer_dead.ogg']}).play()

	loadTool: ->
		@icon = PIXI.Sprite.fromImage("../images/tools/tools/hammer.png")
		@icon.anchor.x = @icon.anchor.y = .5
		@icon.scale.x = @icon.scale.y = .5
		@shadow = PIXI.Sprite.fromImage("../images/tools/tools/hammer.png")
		@shadow.scale.x = @shadow.scale.y = .5
		# darken the color. Set 50% transparency
		@shadow.tint = @shadowTint
		@shadow.alpha = 0.5
		super()

	showShadow: (mCoords) ->
		@shadow.position.y = mCoords.y + hammerOffset
		@shadow.position.x = mCoords.x + hammerOffset

	showTool: (isActive) ->
		return if not isActive

		if not @isPressed()
			mCoords = App.stage.getMousePosition()
			@icon.position.y = mCoords.y + hammerOffset
			@icon.position.x = mCoords.x + hammerOffset
			@showShadow(mCoords)

	switchOff: ->
		super()
		App.sound.hammer_normal?.stop()
		App.sound.hammer_used?.stop()
		App.sound.hammer_dead?.stop()

	switchOn: ->
		super()
