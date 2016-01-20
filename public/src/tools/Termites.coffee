class @Termites extends @Animator
	termiteScale = 1.5
	termiteRotation = 45

	constructor: (@name) ->
		App.sound.termite_noise = null
		@directions = LEFT: 0, UP: 1, RIGHT: 2, DOWN: 3
		@termiteAnimator = null
		@spriteSheet = "Termite_Hands"
		@spriteName = "Termite_Hand_"
		@spriteCount = 2
		@termiteMaxTravel = 20
		@termiteMovementAmount = 0.1
		@termiteSplats = []
		super(@name, @spriteSheet, @spriteName, @spriteCount)

	actionStart: ->
		super()
		mCoords = App.stage.getMousePosition()
		t = @termiteAnimator.newAnimation(posX: mCoords.x, posY: mCoords.y, removeAfterDone: false, scaleX: 1, scaleY: 1, loop: true, animationSpeed: .1, getHandle: true)
		@redirectTermite (@termiteAnimator.animations.push t)-1
		App.sound.termite_noise ?= new Howl({
			urls: ['../sounds/termite.ogg']
			loop: true
		}).play()

	actionFinish: ->
		super()

	cleanUp: ->
		@termiteAnimator.cleanUp()
		super()
		@termiteSplats = Tool::cleanUp([@termiteSplats])

	killTermite: (i) ->
		termite = @termiteAnimator.animations[i]
		posX = termite.position.x
		posY = termite.position.y
		App.pondContainer.removeChild(termite);
		@termiteAnimator.animations.splice(i,1)
		termite = PIXI.Sprite.fromImage("../images/tools/damage/termite_splat.png")
		termite.scale.x = termite.scale.y = termiteScale
		termite.position.y = posY
		termite.position.x = posX
		@termiteSplats.push(termite)
		App.pondContainer.addChild(termite);

	loadTool: ->
		super()
		App.stage.removeChild(@shadow)
		App.stage.removeChild(@icon)
		@termiteAnimator = new Animator("Termite Animator", "Termites", "Termite_", 2)
		@termiteAnimator.loadTool()
		App.stage.removeChild(@termiteAnimator.shadow)
		App.stage.removeChild(@termiteAnimator.icon)

	redirectTermite: (index) ->
		termite = @termiteAnimator.animations[index]
		termite.movementRemaining = randNum(1, @termiteMaxTravel)
		termite.direction = randNum(0, Object.keys(@directions).length)

		switch termite.direction
			when @directions.LEFT
				termite.scale.x = -(Math.abs termite.scale.x)
				termite.rotation = 0
			when @directions.UP
				termite.rotation = -(termiteRotation * (Math.PI / 2))
				termite.scale.x = Math.abs termite.scale.x
			when @directions.DOWN
				termite.rotation = (termiteRotation * (Math.PI / 2))
				termite.scale.x = Math.abs termite.scale.x
			when @directions.RIGHT
				termite.scale.x = Math.abs termite.scale.x
				termite.rotation = 0

	showShadow: (mCoords) ->
		super()

	showTool: (isActive) ->
		if isActive
			mCoords = App.stage.getMousePosition()
			@icon?.position?.y = mCoords.y
			@icon?.position?.x = mCoords.x

		i = 0
		while i < @termiteAnimator?.animations.length
			termite = @termiteAnimator.animations[i]
			# reached end of travels
			if termite.movementRemaining <= 0
				@redirectTermite i

			switch termite.direction
				when @directions.LEFT then termite.position.x -= @termiteMovementAmount
				when @directions.UP then termite.position.y -= @termiteMovementAmount
				when @directions.RIGHT then termite.position.x += @termiteMovementAmount
				when @directions.DOWN then termite.position.y += @termiteMovementAmount
			#
			termite.movementRemaining -= @termiteMovementAmount
			i++

		if @termiteAnimator?.animations.length is 0
			App.sound.termite_noise?.stop?()
			App.sound.termite_noise = null

	switchOff: ->
		super()

	switchOn: ->
		mCoords = App.stage.getMousePosition()
		@icon = @newAnimation(posX: mCoords.x, posY: mCoords.y, removeAfterDone: false, scaleX: 1, scaleY: 1, loop: true, animationSpeed: .1, getHandle: true)
		super()

	termiteCheck: (damage) ->
		i = 0
		while i < @termiteAnimator?.animations.length
			termite = @termiteAnimator.animations[i]
			offset = 10
			damageBox = {x: damage.position.x - offset, y: damage.position.y - offset, width: damage.width + offset*2, height: damage.height + offset}
			termiteBox = {x: termite.position.x - offset, y: termite.position.y - offset, width: termite.width + offset*2, height: termite.height + offset}

			if (damageBox.x < termiteBox.x + termiteBox.width &&
				damageBox.x + damageBox.width > termiteBox.x &&
				damageBox.y < termiteBox.y + termiteBox.height &&
				damageBox.height + damageBox.y > termiteBox.y)
					@killTermite i
			i++
