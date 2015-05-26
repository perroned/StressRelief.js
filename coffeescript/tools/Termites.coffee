class @Termites extends @Animator
  constructor: (@name) ->
    @cursor = null
    @spriteSheet = "Termites"
    @spriteName = "Termite_"
    @spriteCount = 2
    super(@name, @spriteSheet, @spriteName, @spriteCount)

  actionStart: ->

    # super()
    mCoords = App.stage.getMousePosition()
    # @cursor = @newAnimation(posX: mCoords.x, posY: mCoords.y, removeAfterDone: false, scale: 1, loop: true, animationSpeed: .1, getHandle: true)
    @newAnimation(posX: mCoords.x, posY: mCoords.y, removeAfterDone: false, scale: 1, loop: true, animationSpeed: .1, getHandle: false)

  actionFinish: ->
    # super()

  cleanUp: ->
    # @explosions = super([@explosions])

  loadTool: ->
    super()
    @icon.visible = @shadow.visible = false

  showShadow: (mCoords) ->
    # super()

  showTool: (isActive) ->
    # super()
    if isActive
      mCoords = App.stage.getMousePosition()
      @cursor?.position?.y = mCoords.y
      @cursor?.position?.x = mCoords.x

  switchOff: ->
    # super()
    @cursor?.visible = false

  switchOn: ->
    # super()
    mCoords = App.stage.getMousePosition()
    @cursor ?= @newAnimation(posX: mCoords.x, posY: mCoords.y, removeAfterDone: false, scale: 1, loop: true, animationSpeed: .1, getHandle: true)
    @cursor?.visible = true
