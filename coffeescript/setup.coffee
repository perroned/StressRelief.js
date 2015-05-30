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
  App.pondContainer = new (PIXI.DisplayObjectContainer)
  App.stage.addChild App.pondContainer
  App.stage.interactive = true
  App.backgroundColor = PIXI.Sprite.fromImage('resources/images/background.png')
  App.backgroundColor.width = window.innerWidth
  App.backgroundColor.height = window.innerHeight
  App.pondContainer.addChild App.backgroundColor
  bg = PIXI.Sprite.fromImage('resources/images/displacement_BG.jpg')
  App.pondContainer.addChild bg

@resize = ->
  App.renderer.resize(window.innerWidth, window.innerHeight)
  App.renderer.view.style.width = window.innerWidth + 'px'
  App.renderer.view.style.height = window.innerHeight + 'px'
  App.hitBox.hitArea = new PIXI.Rectangle(0, 0, window.innerWidth, window.innerHeight);
  App.backgroundColor.width = window.innerWidth
  App.backgroundColor.height = window.innerHeight

@setupRenderer = ->
  # use Canvas, because WebGL is broke
  App.renderer = new PIXI.CanvasRenderer(window.innerWidth, window.innerHeight)
  App.renderer.view.style.position = 'absolute'
  App.renderer.view.style.width = window.innerWidth + 'px'
  App.renderer.view.style.height = window.innerHeight + 'px'
  App.renderer.view.style.display = 'block'
  # # add render view to DOM
  document.body.appendChild App.renderer.view
  window.addEventListener('resize', resize, false)
