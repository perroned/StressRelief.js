# set up global namespace
@App = @App or {}
renderer = PIXI.autoDetectRenderer(630, 410)

@init = ->
  App.registerKeys();
  renderer.view.style.position = 'absolute'
  renderer.view.style.width = window.innerWidth + 'px'
  renderer.view.style.height = window.innerHeight + 'px'
  renderer.view.style.display = 'block'
  filtersSwitchs = [
    true
    false
    false
    false
    false
    false
    false
    false
    false
    false
    false
  ]
  # add render view to DOM
  document.body.appendChild renderer.view
  gui = new (dat.GUI)({})
  #//
  displacementTexture = PIXI.Texture.fromImage('images/displacement_map.jpg')
  displacementFilter = new (PIXI.DisplacementFilter)(displacementTexture)
  displacementFolder = gui.addFolder('Displacement')
  displacementFolder.add(filtersSwitchs, '0').name 'apply'
  displacementFolder.add(displacementFilter.scale, 'x', 1, 200).name 'scaleX'
  displacementFolder.add(displacementFilter.scale, 'y', 1, 200).name 'scaleY'

  blurFilter = new (PIXI.BlurFilter)
  blurFolder = gui.addFolder('Blur')
  blurFolder.add(filtersSwitchs, '1').name 'apply'
  blurFolder.add(blurFilter, 'blurX', 0, 32).name 'blurX'
  blurFolder.add(blurFilter, 'blurY', 0, 32).name 'blurY'
  #//
  pixelateFilter = new (PIXI.PixelateFilter)
  pixelateFolder = gui.addFolder('Pixelate')
  pixelateFolder.add(filtersSwitchs, '2').name 'apply'
  pixelateFolder.add(pixelateFilter.size, 'x', 1, 32).name 'PixelSizeX'
  pixelateFolder.add(pixelateFilter.size, 'y', 1, 32).name 'PixelSizeY'
  #//
  invertFilter = new (PIXI.InvertFilter)
  invertFolder = gui.addFolder('Invert')
  invertFolder.add(filtersSwitchs, '3').name 'apply'
  invertFolder.add(invertFilter, 'invert', 0, 1).name 'Invert'
  #//
  twistFilter = new (PIXI.TwistFilter)
  twistFolder = gui.addFolder('Twist')
  twistFolder.add(filtersSwitchs, '4').name 'apply'
  twistFolder.add(twistFilter, 'angle', 0, 10).name 'Angle'
  twistFolder.add(twistFilter, 'radius', 0, 1).name 'Radius'
  twistFolder.add(twistFilter.offset, 'x', 0, 1).name 'offset.x'
  twistFolder.add(twistFilter.offset, 'y', 0, 1).name 'offset.y'
  #//

  filterCollection = [
    displacementFilter
    blurFilter
    pixelateFilter
    invertFilter
    twistFilter
  ]
  # create an new instance of a pixi stage
  App.stage = new (PIXI.Stage)(0xFF0000, true)
  pondContainer = new (PIXI.DisplayObjectContainer)
  App.stage.addChild pondContainer
  App.stage.interactive = true
  bg = PIXI.Sprite.fromImage('images/displacement_BG.jpg')
  pondContainer.addChild bg

  padding = 100
  bounds = new (PIXI.Rectangle)(-padding, -padding, 630 + padding * 2, 410 + padding * 2)
  fishs = []
  i = 0
  while i < 20
    fishId = i % 4
    fishId += 1
    fish = PIXI.Sprite.fromImage('images/displacement_fish' + fishId + '.png')
    fish.anchor.x = fish.anchor.y = 0.5
    pondContainer.addChild fish
    fish.direction = Math.random() * Math.PI * 2
    fish.speed = .3
    fish.turnSpeed = Math.random() - 0.8
    fish.position.x = Math.random() * bounds.width
    fish.position.y = Math.random() * bounds.height
    fish.scale.x = fish.scale.y = .2
    fishs.push fish
    i++
  overlay = new (PIXI.TilingSprite)(PIXI.Texture.fromImage('images/zeldaWaves.png'), 630, 410)
  overlay.alpha = 0.1

  pondContainer.addChild overlay
  displacementFilter.scale.x = 0
  displacementFilter.scale.y = 0
  count = 0
  switchy = false

  @animate = ->
    count = 0
    count += 0.1
    blurAmount = Math.cos(count)
    blurAmount2 = Math.sin(count * 0.8)
    filtersToApply = []
    i = 0
    while i < filterCollection.length
      if filtersSwitchs[i]
        filtersToApply.push filterCollection[i]
      i++
    pondContainer.filters = if filtersToApply.length > 0 then filtersToApply else null
    i = 0
    while i < fishs.length
      fish = fishs[i]
      fish.direction += fish.turnSpeed * 0.01
      fish.position.x += Math.sin(fish.direction) * fish.speed
      fish.position.y += Math.cos(fish.direction) * fish.speed
      fish.rotation = -fish.direction - (Math.PI / 2)
      # wrap..
      if fish.position.x < bounds.x
        fish.position.x += bounds.width
      if fish.position.x > bounds.x + bounds.width
        fish.position.x -= bounds.width
      if fish.position.y < bounds.y
        fish.position.y += bounds.height
      if fish.position.y > bounds.y + bounds.height
        fish.position.y -= bounds.height
      i++

    overlay.tilePosition.x = count * -10
    overlay.tilePosition.y = count * -10
    renderer.render App.stage
    requestAnimFrame animate
    return

  requestAnimFrame animate

logo = ->
  ###
  # Add a pixi Logo!
  ###
  logo = PIXI.Sprite.fromImage('images/logo_small.png')
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
