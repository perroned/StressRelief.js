@setupHitbox = ->
  hitBox = new PIXI.Graphics();
  App.stage.addChild hitBox
  hitBox.hitArea = new PIXI.Rectangle(0, 0, window.innerWidth, window.innerHeight);
  hitBox.interactive = true;
  hitBox.mousedown = (e) ->
    App.tools[App.currentTool].actionStart()
  hitBox.mouseup = (e) ->
    App.tools[App.currentTool].actionFinish()

@setupFish = ->
  App.fishs = []
  i = 0
  while i < 20
    fishId = i % 4
    fishId += 1
    fish = PIXI.Sprite.fromImage('resources/images/displacement_fish' + fishId + '.png')
    fish.anchor.x = fish.anchor.y = 0.5
    App.pondContainer.addChild fish
    fish.direction = Math.random() * Math.PI * 2
    fish.speed = .3
    fish.turnSpeed = Math.random() - 0.8
    fish.position.x = Math.random() * App.bounds.width
    fish.position.y = Math.random() * App.bounds.height
    fish.scale.x = fish.scale.y = .2
    App.fishs.push fish
    i++
  overlay = new (PIXI.TilingSprite)(PIXI.Texture.fromImage('resources/images/zeldaWaves.png'), 630, 410)
  overlay.alpha = 0.1
  App.pondContainer.addChild overlay

@setupScene = ->
  setupRenderer()
  # create an new instance of a pixi stage
  App.stage = new (PIXI.Stage)(0xFF0000, true)
  App.pondContainer = new (PIXI.DisplayObjectContainer)
  App.stage.addChild App.pondContainer
  App.stage.interactive = true
  bg = PIXI.Sprite.fromImage('resources/images/displacement_BG.jpg')
  App.pondContainer.addChild bg
  padding = 100
  App.bounds = new (PIXI.Rectangle)(-padding, -padding, 630 + padding * 2, 410 + padding * 2)

@setupRenderer = ->
  # use Canvas, because WebGL is broke
  App.renderer = new PIXI.CanvasRenderer(630, 410)
  App.renderer.view.style.position = 'absolute'
  App.renderer.view.style.width = window.innerWidth + 'px'
  App.renderer.view.style.height = window.innerHeight + 'px'
  App.renderer.view.style.display = 'block'
  # # add render view to DOM
  document.body.appendChild App.renderer.view
