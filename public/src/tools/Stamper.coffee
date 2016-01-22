class @Stamper extends @Tool
	damageOffsetY = 10
	shadowOffsetInUse = 25
	iconScaleX = .7
	iconScaleY = .4
	shadowRotation = 45
	shadowOffsetY = 7
	shadowOffsetX = 25
	iconOffset = 20

	constructor: (@name) ->
		super @name
		@damageIconCount = 10
		@dropAmount = 30

	actionStart: ->
		super()
		damage = PIXI.Sprite.fromImage("../images/tools/damage/stamps/stamp_#{randNum(0, @damageIconCount)}.png")
		damage.scale.x = damage.scale.y = .5
		mCoords = App.stage.getMousePosition()
		damage.position.y = mCoords.y + @dropAmount + damageOffsetY
		damage.position.x = mCoords.x
		App.tools[App.ToolEnum.TERMITES].termiteCheck(damage)
		@damages.push damage
		App.mainContainer.addChild damage
		@icon.position.y = @icon.position.y + @dropAmount
		@handleStampSound()
		@shadow.position.x = mCoords.x + @icon.width + shadowOffsetInUse - @dropAmount

	actionFinish: ->
		super()
		@icon.position.y = @icon.position.y - @dropAmount

	cleanUp: ->
		super()

	handleStampSound: ->
		App.sound.stamper = new Howl({urls: ['../sounds/stamper.ogg']}).play()

	loadTool: ->
		@icon = PIXI.Sprite.fromImage("../images/tools/tools/Stamper.png")
		@icon.anchor.x = @icon.anchor.y = .5
		@icon.scale.x = iconScaleX
		@icon.scale.y = iconScaleY
		@shadow = PIXI.Sprite.fromImage("../images/tools/tools/Stamper.png")
		@shadow.scale.x = iconScaleX
		@shadow.scale.y = iconScaleY
		@shadow.anchor.x = @shadow.anchor.y = .5
		@shadow.rotation = shadowRotation * Math.PI / 2
		# darken the color. Set 50% transparency
		@shadow.tint = @shadowTint
		@shadow.alpha = 0.5
		super()

	showShadow: (mCoords) ->
		@shadow.position.y = mCoords.y + @icon.height - shadowOffsetY
		@shadow.position.x = mCoords.x + @icon.width + shadowOffsetX

	showTool: (isActive) ->
		return if not isActive

		if not @isPressed()
			mCoords = App.stage.getMousePosition()
			@icon.position.y = mCoords.y + iconOffset
			@icon.position.x = mCoords.x + iconOffset
			@showShadow(mCoords)

	switchOff: ->
		super()
		App.sound.stamper?.stop()

	switchOn: ->
		super()
