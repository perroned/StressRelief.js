class @Exploder extends @Animator
	constructor: (@name) ->
		@spriteSheet = "bulletExplosion"
		@spriteName = "Explosion_Sequence_A "
		@spriteCount = 26
		super(@name, @spriteSheet, @spriteName, @spriteCount)

	actionStart: ->
		super()
		mCoords = App.stage.getMousePosition()
		@newExplosion(posX: mCoords.x, posY: mCoords.y, removeAfterDone: false, scaleX: 0.3, scaleY: 0.3, loop: false, animationSpeed: 1, getHandle: false)

	actionFinish: ->
		super()

	cleanUp: ->
		super()

	loadTool: ->
		@icon = PIXI.Sprite.fromImage("../images/tools/tools/Hammer.png")
		@icon.anchor.x = @icon.anchor.y = .5
		@icon.scale.x = @icon.scale.y = .5
		@shadow = PIXI.Sprite.fromImage("../images/tools/tools/Hammer.png")
		@shadow.scale.x = @shadow.scale.y = .5
		# darken the color. Set 50% transparency
		@shadow.tint = 0x151515
		@shadow.alpha = 0.5
		super()
		@icon.visible = @shadow.visible = false

	newExplosion: (config)->
		@newAnimation(config)

	showShadow: (mCoords) ->
		super()

	showTool: (isActive) ->
		super()

	switchOff: ->
		super()

	switchOn: ->
		@switchOff()
