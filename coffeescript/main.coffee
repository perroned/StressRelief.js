# set up global namespace
@App = @App or {}

@init = ->
  App.registerKeys();
  setupScene()
  setupFish()
  setupTools()
  setupHitbox();

  @animate = ->
    animateFish()
    showTool()
    App.renderer.render App.stage
    requestAnimFrame animate
    return

  requestAnimFrame animate

animateFish = ->
  i = 0
  while i < App.fishs.length
    fish = App.fishs[i]
    fish.direction += fish.turnSpeed * 0.01
    fish.position.x += Math.sin(fish.direction) * fish.speed
    fish.position.y += Math.cos(fish.direction) * fish.speed
    fish.rotation = -fish.direction - (Math.PI / 2)
    # wrap..
    if fish.position.x < App.bounds.x
      fish.position.x += App.bounds.width
    if fish.position.x > App.bounds.x + App.bounds.width
      fish.position.x -= App.bounds.width
    if fish.position.y < App.bounds.y
      fish.position.y += App.bounds.height
    if fish.position.y > App.bounds.y + App.bounds.height
      fish.position.y -= App.bounds.height
    i++

logo = ->
  ###
  # Add a pixi Logo!
  ###
  logo = PIXI.Sprite.fromImage('resources/images/logo_small.png')
  App.stage.addChild logo
  logo.anchor.x = 1
  logo.anchor.y = 1
  logo.position.x = 630
  logo.scale.x = logo.scale.y = 0.5
  logo.position.y = 400
  logo.interactive = true
  logo.buttonMode = true
  logo.click =
  logo.tap = ->
    window.open 'https://github.com/GoodBoyDigital/pixi.js', '_blank'
    return
