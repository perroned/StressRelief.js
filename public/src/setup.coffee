@setupHitbox = ->
	App.hitBox = new PIXI.Graphics();
	App.stage.addChild App.hitBox
	App.hitBox.hitArea = new PIXI.Rectangle(0, 0, window.innerWidth, window.innerHeight);
	App.hitBox.interactive = true;
	App.hitBox.mousedown = (e) ->
		App.tools[App.currentTool].actionStart()
	App.hitBox.mouseup = (e) ->
		App.tools[App.currentTool].actionFinish()

@setupScene = ->
	setupRenderer()
	# create an new instance of a pixi stage
	App.stage = new (PIXI.Stage)(0xFFFFFF, true)
	setupHitbox()
	App.mainContainer = new (PIXI.DisplayObjectContainer)
	App.stage.addChild App.mainContainer
	App.stage.interactive = true
	App.backgroundColor = PIXI.Sprite.fromImage('../images/backgroundColors/default.png')
	App.currentBackgroundColor = 'default'
	App.mainContainer.addChild App.backgroundColor
	App.trueBackgroundImage = {}
	uploadBackground('../images/bg.png')
	uploadBackgroundColor App.backgroundColor

@resize = ->
	App.renderer.resize(window.innerWidth, window.innerHeight)
	App.renderer.view.style.width = window.innerWidth + 'px'
	App.renderer.view.style.height = window.innerHeight + 'px'
	App.hitBox.hitArea = new PIXI.Rectangle(0, 0, window.innerWidth, window.innerHeight);
	App.backgroundColor.width = window.innerWidth
	App.backgroundColor.height = window.innerHeight
	newHeight = newWidth = null

	if App.trueBackgroundImage.width <= App.trueBackgroundImage.height
		newWidth = window.innerHeight * App.trueBackgroundImage.width / App.trueBackgroundImage.height
		if window.innerWidth < window.innerWidth
			newHeight = window.innerHeight * window.innerWidth / newWidth
			newWidth = window.innerWidth
		else newHeight = window.innerHeight
	else
		newHeight = window.innerWidth * App.trueBackgroundImage.height / App.trueBackgroundImage.width
		if window.innerHeight < newHeight
			newWidth = window.innerWidth * window.innerHeight / newHeight
			newHeight = window.innerHeight
		else newWidth = window.innerWidth
	[App.backgroundImage.width, App.backgroundImage.height] = [newWidth, newHeight]

	# center
	App.backgroundImage.position.x = window.innerWidth/2 - App.backgroundImage.width/2
	App.backgroundImage.position.y = window.innerHeight/2 - App.backgroundImage.height/2

@setupRenderer = ->
	# use Canvas, because WebGL is broke
	App.renderer = new PIXI.CanvasRenderer(window.innerWidth, window.innerHeight)
	App.renderer.view.style.position = 'absolute'
	App.renderer.view.style.width = window.innerWidth + 'px'
	App.renderer.view.style.height = window.innerHeight + 'px'
	App.renderer.view.style.display = 'block'
	# add render view to DOM
	document.body.appendChild App.renderer.view
	window.addEventListener('resize', resize, false)

@uploadBackground = (path, callback) ->
	(App.mainContainer.removeChild App.backgroundImage) if App.backgroundImage?
	App.backgroundImage = PIXI.Sprite.fromImage(path)
	if App.backgroundImage.texture.baseTexture.hasLoaded
		[App.trueBackgroundImage.width, App.trueBackgroundImage.height] = [App.backgroundImage.texture.width, App.backgroundImage.texture.height]
		App.mainContainer.addChildAt App.backgroundImage, 1
		resize()
		callback?()
	else
		App.backgroundImage.texture.baseTexture.on 'loaded', ->
			[App.trueBackgroundImage.width, App.trueBackgroundImage.height] = [App.backgroundImage.texture.width, App.backgroundImage.texture.height]
			App.mainContainer.addChildAt App.backgroundImage, 1
			resize()
			callback?()

@uploadBackgroundColor = (img) ->
	App.mainContainer.removeChild App.backgroundColor
	App.backgroundColor = img
	App.mainContainer.addChildAt App.backgroundColor, 0
	resize()
