class @Chainsaw extends @Tool
  constructor: (@name) ->
    super @name
    @cutIcon = null

  actionStart: ->
    super()
    mCoords = App.stage.getMousePosition()
    App.tools[App.ToolEnum.TERMITES].termiteCheck({width:10,height:10, position: {x: mCoords.x, y:mCoords.y}})
    @switchOff()
    @sound_Rev false
    @sound_Cut true
    @cutIcon.visible = true

  actionFinish: ->
    super()
    @switchOn()
    @sound_Cut false
    @sound_Rev true
    @cutIcon.visible = false

  cleanUp: ->
    super()

  loadTool: ->
    @icon = PIXI.Sprite.fromImage("../images/tools/tools/chainsaw.png")
    @icon.scale.x = @icon.scale.y = .5
    App.stage.addChild(@icon)

    @shadow = PIXI.Sprite.fromImage("../images/tools/tools/chainsaw.png")
    @shadow.scale.x = @shadow.scale.y = .5
    App.stage.addChild(@shadow)
    # darken the color. Set 50% transparency
    @shadow.tint = 0x151515
    @shadow.alpha = 0.5

    @cutIcon = PIXI.Sprite.fromImage("../images/tools/tools/chainsaw_cut.png")
    mCoords = App.stage.getMousePosition()
    @cutIcon.position.y = mCoords.y-40
    @cutIcon.position.x = mCoords.x
    @cutIcon.scale.x = @cutIcon.scale.y = .5
    App.pondContainer.addChild @cutIcon

  showShadow: (mCoords) ->
    @shadow.position.y = mCoords.y+20
    @shadow.position.x = mCoords.x+25

  showTool: (isActive) ->
    return if not isActive
    if @isPressed()
      mCoords = App.stage.getMousePosition()
      @cutIcon.position.y = mCoords.y-40
      @cutIcon.position.x = mCoords.x
      # cutting
      damage = PIXI.Sprite.fromImage("../images/tools/damage/chainsawDamage.png")
      damage.scale.x = damage.scale.y = 2
      damage.position.x = mCoords.x
      damage.position.y = mCoords.y
      @damages.push damage
      App.pondContainer.addChild(damage)
    else
      mCoords = App.stage.getMousePosition()
      @icon.position.y = mCoords.y
      @icon.position.x = mCoords.x
      @showShadow(mCoords)

  sound_Cut: (start) ->
    App.sound.chainsaw_cut?.stop()
    if start
      App.sound.chainsaw_cut = new Howl({
        urls: ['../sounds/chainsaw_cut.ogg']
        loop: true
      }).play()

  sound_Rev: (start) ->
    App.sound.chainsaw_rev?.stop()
    if start
      App.sound.chainsaw_rev = new Howl({
        urls: ['../sounds/chainsaw_rev.ogg']
        loop: true
      }).play()

  switchOff: ->
    super()
    @cutIcon.visible = false
    @sound_Cut false
    @sound_Rev false

  switchOn: ->
    super()
    @sound_Cut false
    @sound_Rev true
