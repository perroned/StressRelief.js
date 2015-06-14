class @Phaser extends @Tool
	constructor: (@name) ->
		super @name
		@finish = 0
		@duration = 500

	actionStart: ->
		super()
		mCoords = App.stage.getMousePosition()
		App.tools[App.ToolEnum.TERMITES].termiteCheck({width:10,height:10, position: {x: mCoords.x, y:mCoords.y}})
		@crosshairs.visible = false
		@flash.visible = true
		@finish = Date.now() + @duration
		@phaserAction.visible = true
		App.sound.phaser_shoot = new Howl({
			urls: ['../sounds/phaser.ogg']
		}).play()

	actionFinish: ->
		super()
		@switchOn()
		@crosshairs.visible = true
		@flash.visible = false
		@finish = 0
		@phaserAction.visible = false

	cleanUp: ->
		super()

	loadTool: ->
		@icon = PIXI.Sprite.fromImage("../images/tools/tools/phaser.png")
		@icon.scale.x = @icon.scale.y = .5
		@shadow = PIXI.Sprite.fromImage("../images/tools/tools/phaser.png")
		@shadow.scale.x = @shadow.scale.y = .5
		@crosshairs = PIXI.Sprite.fromImage("../images/tools/damage/machinegun_crosshairs2.png")
		@crosshairs.scale.x = @crosshairs.scale.y = .1
		@flash = PIXI.Sprite.fromImage("../images/tools/damage/phaser_beam.png")
		@flash.scale.x = @flash.scale.y = .6
		@phaserAction = PIXI.Sprite.fromImage("../images/tools/damage/phaser_action.png")
		@phaserAction.visible = false
		@phaserAction.scale.x = @phaserAction.scale.y = .5
		@phaserAction.anchor.x = @phaserAction.anchor.y = .5

		# darken the color. Set 50% transparency
		@shadow.tint = 0x151515
		@shadow.alpha = 0.5
		App.stage.addChild(@crosshairs)
		App.stage.addChild(@flash)
		App.stage.addChild @phaserAction
		super()

	showShadow: (mCoords) ->
		@shadow.position.y = @icon.position.y+5
		@shadow.position.x = @icon.position.x+@icon.width-5

	showTool: (isActive) ->

		if isActive
			mCoords = App.stage.getMousePosition()
			@flash.visible = false
			@icon.position.y = mCoords.y+@shadow.height-5
			@icon.position.x = mCoords.x+@shadow.width-5
			@showShadow(mCoords)
			@crosshairs.position.y = mCoords.y - (@crosshairs.height/2)
			@crosshairs.position.x = mCoords.x - (@crosshairs.height/2)

			if @finish > Date.now()
				if @isPressed()
					damage = PIXI.Sprite.fromImage("../images/tools/damage/phaser_damage.png")
					damage.scale.x = damage.scale.y = .5
					damage.position.x = mCoords.x
					damage.position.y = mCoords.y
					damage.anchor.x = damage.anchor.y = .5
					damage.rotation = Math.random() * Math.PI / 2
					damage.alpha = .1
					@damages.push damage
					App.pondContainer.addChild(damage)
					@flash.position.y = mCoords.y
					@flash.position.x = mCoords.x-2
					@flash.visible = true

					@phaserAction.position.x = mCoords.x
					@phaserAction.position.y = mCoords.y
					@phaserAction.anchor.x = @phaserAction.anchor.y = .5
					@phaserAction.rotation = Math.random() * Math.PI / 2
			else
				@phaserAction.visible = false

	switchOff: ->
		super()
		@crosshairs.visible = false
		@flash.visible = false
		App.sound.phaser_shoot?.stop()

	switchOn: ->
		super()
		@crosshairs.visible = true
