class @Machinegun extends @Tool
	shadowOffsetY = 40
	shadowOffsetX = 25
	damageScale = .45
	jitterFlucuation = 7
	shadowJitterFlucuation = 5
	flashOffsetY = 5
	flashOffsetX = 3
	bulletScale = .7
	iconOffsetY = 30
	iconOffsetX = 10
	bulletHorizontalTravel = 4
	bulletFallRotate = .3
	bulletSpawnInterval = 100
	bulletMinDistance = 50
	bulletMaxDistance = 150
	bulletMaxHeight = 5000

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
		@crosshairs.visible = true
		@flash.visible = false

	cleanUp: ->
		@bullets = super([@bullets])

	loadTool: ->
		@icon = PIXI.Sprite.fromImage("../images/tools/tools/Machinegun.png")
		@icon.scale.x = @icon.scale.y = .5
		@shadow = PIXI.Sprite.fromImage("../images/tools/tools/Machinegun.png")
		@shadow.scale.x = @shadow.scale.y = .5
		@crosshairs = PIXI.Sprite.fromImage("../images/tools/damage/machinegun_crosshairs2.png")
		@crosshairs.scale.x = @crosshairs.scale.y = .1
		@flash = PIXI.Sprite.fromImage("../images/tools/damage/machinegun_fire.png")
		@flash.scale.x = @flash.scale.y = 1
		# darken the color. Set 50% transparency
		@shadow.tint = @shadowTint
		@shadow.alpha = 0.5
		App.stage.addChild(@crosshairs)
		App.stage.addChild(@flash)
		super()

	showShadow: (mCoords, offsetX, offsetY) ->
		@shadow.position.y = mCoords.y + shadowOffsetY + offsetY
		@shadow.position.x = mCoords.x + shadowOffsetX + offsetX

	showTool: (isActive) ->
		if isActive
			mCoords = App.stage.getMousePosition()
			offsetX = offsetY = 0
			@flash.visible = false
			# every frame while the tool is fired play its fire sound
			if @isPressed()
				App.sound.machinegun_shoot = new Howl({
					urls: ['../sounds/machinegun_shoot.ogg']
				}).play()

				# produce random jitter for the bullet's location
				offsetX = randNum(-jitterFlucuation, jitterFlucuation)
				offsetY = randNum(-jitterFlucuation, jitterFlucuation)
				damage = PIXI.Sprite.fromImage("../images/tools/damage/bulletDamage#{randNum(0,3)}.png")
				damage.scale.x = damage.scale.y = damageScale
				damage.position.x = mCoords.x+offsetX
				damage.position.y = mCoords.y+offsetY
				@damages.push damage
				App.tools[App.ToolEnum.TERMITES].termiteCheck(damage)
				App.mainContainer.addChild(damage)
				App.tools[App.ToolEnum.EXPLODER].newExplosion(posX: damage.position.x, posY: damage.position.y, removeAfterDone: true, scaleX: 0.1, scaleY: 0.1, loop: false, animationSpeed: 1)

				# produce random jitter for the gun and shadow while shooting
				offsetX = randNum(-shadowJitterFlucuation, shadowJitterFlucuation)
				offsetY = randNum(-shadowJitterFlucuation, shadowJitterFlucuation)
				if (randNum(0, 10) > 4) # 25% chance
					@flash.position.y = mCoords.y + flashOffsetY + offsetY
					@flash.position.x = mCoords.x - flashOffsetX + offsetX
					@flash.visible = true

				# spawn a bullet
				if ((Date.now() - @lastBulletSpawn) > bulletSpawnInterval) or @lastBulletSpawn is 0
					@lastBulletSpawn = Date.now()
					b = PIXI.Sprite.fromImage("../images/tools/damage/machinegunbullet.png")
					b.scale.x = b.scale.y = bulletScale
					b.position.x = mCoords.x + @icon.width + flashOffsetY
					b.position.y = mCoords.y + @icon.height + flashOffsetY
					b.speed = 1
					b.maxHeight = b.position.y - randNum(bulletMinDistance, bulletMaxDistance)
					@bullets.push b
					App.mainContainer.addChild(b)

			@icon.position.y = mCoords.y + iconOffsetY + offsetY
			@icon.position.x = mCoords.x + iconOffsetX + offsetX
			@showShadow(mCoords, offsetX, offsetY)
			@crosshairs.position.y = mCoords.y - (@crosshairs.height / 2) + offsetY
			@crosshairs.position.x = mCoords.x - (@crosshairs.height / 2) + offsetX

		i = 0
		while i < @bullets.length
			if @bullets[i].position.y > @bullets[i].maxHeight
				@bullets[i].position.y -= 5 + -@bullets[i].speed
				@bullets[i].speed -= .05
			else
				@bullets[i].position.y += 1 + @bullets[i].speed
				@bullets[i].speed += .1
				@bullets[i].maxHeight = bulletMaxHeight

			@bullets[i].position.x += bulletHorizontalTravel
			@bullets[i].anchor.x = @bullets[i].anchor.y = .5
			@bullets[i].rotation += bulletFallRotate
			if @bullets[i].position.y > window.innerHeight
				App.mainContainer.removeChild @bullets[i]
				@bullets.splice(i, 1)
				App.sound.machinegun_bullet_land = new Howl({
					urls: ['../sounds/machinegun_bullet_land.ogg']
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
