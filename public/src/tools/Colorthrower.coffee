class @Colorthrower extends @Tool
	@FIRE_INTERVAL: 500 # how often (in ms) the tool can be used
	@MAX_COLORS: 8
	@PAINT_BALL_MOVE_AMOUNT: 2 # how far the paint balls move
	@PAINT_BALL_MOVE_INTERVAL: 10 # how often the paint balls move
	@SHOOT_DISTANCE: 75 # how far the paint balls move before they explode
	paintballInitialOffsetY = 20
	shadowOffsetY = 10
	shadowOffsetX = 50
	iconOffsetY = 30
	iconOffsetX = 10
	splatterOffset = 15
	paintballScaleSize = .4
	
	constructor: (@name) ->
		super @name
		@lastPaintBall = 0
		@paintBalls = []
		@paintSplats = []

	actionStart: ->
		super()
		@makePaintBall()

	actionFinish: ->
		super()
		@shadow.visible = @icon.visible = true

	cleanUp: ->
		super([@paintBalls,@paintSplats])
		@paintSplats = []
		@paintBalls = []

	loadTool: ->
		@icon = PIXI.Sprite.fromImage("../images/tools/tools/colorthrower.png")
		@icon.scale.x = @icon.scale.y = .5
		@shadow = PIXI.Sprite.fromImage("../images/tools/tools/colorthrower.png")
		@shadow.scale.x = @shadow.scale.y = .5
		# darken the color. Set 50% transparency
		@shadow.tint = @shadowTint
		@shadow.alpha = 0.5
		super()

	makePaintBall: ->
		# check if a new paintball can be spawned
		if ((Date.now()-@lastPaintBall) > Colorthrower.FIRE_INTERVAL) or @lastPaintBall is 0
			@lastPaintBall = Date.now()
			# generate a color
			color = randNum(0, Colorthrower.MAX_COLORS)
			paintBall = PIXI.Sprite.fromImage("../images/tools/damage/colorSplats/coloredBlob_#{color}.png")
			paintBall.color = color
			paintBall.scale.x = paintBall.scale.y = .5
			mCoords = App.stage.getMousePosition()
			paintBall.lastMove = 0
			App.mainContainer.addChild(paintBall)
			paintBall.startY = paintBall.position.y = mCoords.y + paintballInitialOffsetY
			paintBall.startX = paintBall.position.x = mCoords.x
			@paintBalls.push paintBall
			App.sound.paint_shoot = new Howl({
				urls: ['../sounds/paint_shoot.ogg']
			}).play()
			App.sound.who = "colorthrower"
			@lastPaintBall = Date.now()

	# transition from a moving paintball to a statically placed splatter
	# and cue audio
	makePaintSplatter: (i) ->
		paintBall = @paintBalls[i]
		# create a splatter based on the paint balls color and a random shape
		splatter = PIXI.Sprite.fromImage("../images/tools/damage/colorSplats/coloredSplat_#{paintBall.color}_#{randNum(0,3)}.png")
		# randomly choose whether to scale up or down
		splatter.scale.y = splatter.scale.x = paintballScaleSize + randNum(-1, 2) / paintballInitialOffsetY
		splatter.position.y = (paintBall.position.y + splatterOffset) + randNum(-10,10)
		splatter.position.x = (paintBall.position.x + splatterOffset) + randNum(-10,10)
		splatter.anchor.y = splatter.anchor.x = .5
		App.mainContainer.addChild splatter
		splatter.rotation = Math.random() * Math.PI * 2
		@paintSplats.push splatter
		App.tools[App.ToolEnum.TERMITES].termiteCheck(splatter)
		App.mainContainer.removeChild paintBall
		@paintBalls.splice(i,1)

		App.sound.paint_splatter = new Howl({
			urls: ['../sounds/paint_splatter.ogg']
		}).play()

	showShadow: (mCoords) ->
		@shadow.position.y = @icon.position.y + shadowOffsetY
		@shadow.position.x = @icon.position.x + shadowOffsetX

	showTool: (isActive) ->
		if isActive
			if @isPressed() # if the button is held keep spawning
				@makePaintBall()

			mCoords = App.stage.getMousePosition()
			@icon.position.y = mCoords.y + iconOffsetY
			@icon.position.x = mCoords.x + iconOffsetX
			@showShadow(mCoords)

	# animate fired paintballs
		i = 0
		while i < @paintBalls.length
			paintBall = @paintBalls[i]
			# splatter the paint ball
			if paintBall.position.y < (paintBall.startY-Colorthrower.SHOOT_DISTANCE) and paintBall.position.x < (paintBall.startX-Colorthrower.SHOOT_DISTANCE)
				# spawn a splatter
				@makePaintSplatter(i)
				continue
			# move the paint ball
			if (((Date.now()-paintBall.lastMove) > Colorthrower.PAINT_BALL_MOVE_INTERVAL) or paintBall.lastMove is 0)
				paintBall.lastMove = Date.now()
				paintBall.position.x -= Colorthrower.PAINT_BALL_MOVE_AMOUNT
				paintBall.position.y -= Colorthrower.PAINT_BALL_MOVE_AMOUNT

			i++

	switchOff: ->
		super()
		App.sound.paint_shoot?.stop()
		App.sound.paint_splatter?.stop()

	switchOn: ->
		super()
