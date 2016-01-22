class @Chainsaw extends @Tool
	termiteCheckZone = 10
	shadowOffsetY = 20
	shadowOffsetX = 25
	cuttingVerticalOffset = 40
	
	constructor: (@name) ->
		super @name
		@cutIcon = null

	actionStart: ->
		super()
		mCoords = App.stage.getMousePosition()
		App.tools[App.ToolEnum.TERMITES].termiteCheck({width:termiteCheckZone, height:termiteCheckZone, position: {x: mCoords.x, y:mCoords.y}})
		@switchOff()
		@sound_Rev false
		@sound_Cut true
		@cutIcon.visible = true

	actionFinish: ->
		super()
		@switchOn()
		@sound_Cut false
		@sound_Rev true
		@cutIcon.visible = false

	cleanUp: ->
		super()

	loadTool: ->
		@icon = PIXI.Sprite.fromImage("../images/tools/tools/Chainsaw.png")
		@icon.scale.x = @icon.scale.y = .5
		App.stage.addChild(@icon)

		@shadow = PIXI.Sprite.fromImage("../images/tools/tools/Chainsaw.png")
		@shadow.scale.x = @shadow.scale.y = .5
		App.stage.addChild(@shadow)
		# darken the color. Set 50% transparency
		@shadow.tint = @shadowTint
		@shadow.alpha = 0.5

		@cutIcon = PIXI.Sprite.fromImage("../images/tools/tools/chainsaw_cut.png")
		mCoords = App.stage.getMousePosition()
		@cutIcon.position.y = mCoords.y - cuttingVerticalOffset
		@cutIcon.position.x = mCoords.x
		@cutIcon.scale.x = @cutIcon.scale.y = .5
		App.mainContainer.addChild @cutIcon

	showShadow: (mCoords) ->
		@shadow.position.y = mCoords.y + shadowOffsetY
		@shadow.position.x = mCoords.x + shadowOffsetX

	# if the tool is being used add a damage sprite
	showTool: (isActive) ->
		return if not isActive
		if @isPressed()
			mCoords = App.stage.getMousePosition()
			@cutIcon.position.y = mCoords.y - cuttingVerticalOffset
			@cutIcon.position.x = mCoords.x
			# cutting
			damage = PIXI.Sprite.fromImage("../images/tools/damage/chainsawDamage.png")
			damage.scale.x = damage.scale.y = 2 # make twice as big
			damage.position.x = mCoords.x
			damage.position.y = mCoords.y
			@damages.push damage
			App.mainContainer.addChild(damage)
		else
			mCoords = App.stage.getMousePosition()
			@icon.position.y = mCoords.y
			@icon.position.x = mCoords.x
			@showShadow(mCoords)

	# played only while cutting
	sound_Cut: (start) ->
		App.sound.chainsaw_cut?.stop()
		if start
			App.sound.chainsaw_cut = new Howl({
				urls: ['../sounds/chainsaw_cut.ogg']
				loop: true
			}).play()

	# this sound is constantly playing
	sound_Rev: (start) ->
		App.sound.chainsaw_rev?.stop()
		if start
			App.sound.chainsaw_rev = new Howl({
				urls: ['../sounds/chainsaw_rev.ogg']
				loop: true
			}).play()

	switchOff: ->
		super()
		@cutIcon.visible = false
		@sound_Cut false
		@sound_Rev false

	switchOn: ->
		super()
		@sound_Cut false
		@sound_Rev true
		App.mainContainer.removeChild @cutIcon
		App.mainContainer.addChild @cutIcon
