class @Chainsaw extends @Tool
  constructor: (@name) ->
    super @name
    @cutIcon = null

  actionStart: ->
    super()
    @switchOff()
    App.sound = new Howl({
      urls: ['resources/sounds/chainsaw_cut.ogg']
      loop: true
    }).play()
    @cutIcon = PIXI.Sprite.fromImage("resources/images/tools/tools/chainsaw_cut.png")
    mCoords = App.stage.getMousePosition()
    @cutIcon.position.y = mCoords.y-40
    @cutIcon.position.x = mCoords.x
    @cutIcon.scale.x = @cutIcon.scale.y = .5
    App.pondContainer.addChild @cutIcon

  actionFinish: ->
    super()
    App.pondContainer.removeChild @cutIcon
    @cutIcon = null
    @switchOn()

  loadTool: ->
    @icon = PIXI.Sprite.fromImage("resources/images/tools/tools/chainsaw.png")
    @icon.scale.x = @icon.scale.y = .5
    App.stage.addChild(@icon)

    @shadow = PIXI.Sprite.fromImage("resources/images/tools/tools/chainsaw.png")
    @shadow.scale.x = @shadow.scale.y = .5
    App.stage.addChild(@shadow)
    # darken the color. Set 50% transparency
    @shadow.tint = 0x151515
    @shadow.alpha = 0.5

  showShadow: (mCoords) ->
    @shadow.position.y = mCoords.y+20
    @shadow.position.x = mCoords.x+25

  showTool: ->
    if @isPressed()
      mCoords = App.stage.getMousePosition()
      @cutIcon.position.y = mCoords.y-40
      @cutIcon.position.x = mCoords.x
      # cutting
      @d = PIXI.Sprite.fromImage("resources/images/tools/damage/chainsawDamage.png")
      @d.scale.x = @d.scale.y = 2
      @d.position.x = mCoords.x
      @d.position.y = mCoords.y
      App.stage.addChild(@d)
    else
      mCoords = App.stage.getMousePosition()
      @icon.position.y = mCoords.y
      @icon.position.x = mCoords.x
      @showShadow(mCoords)

  switchOff: ->
    super()

  switchOn: ->
    super()
    App?.sound?.stop?()
    App.sound = new Howl({
      urls: ['resources/sounds/chainsaw_rev.ogg']
      loop: true
    }).play()
