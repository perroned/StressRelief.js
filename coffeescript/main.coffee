# set up global namespace
@App = @App or {}

@init = ->
  window.onload = ->
    $('#ToolsModal').foundation('reveal', 'open');
    App.sound = {}
    setupScene()
    setupTools()
    App.registerKeys()
    setupHitbox()

    @animate = ->
      showTool()
      App.renderer.render App.stage
      requestAnimFrame animate
      return

    requestAnimFrame animate

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
