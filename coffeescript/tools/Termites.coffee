class @Termites extends @Animator
  constructor: (@name) ->
    @spriteSheet = "Termite_Hands"
    @spriteName = "Termite_Hand_"
    @spriteCount = 2
    @termites = []
    super(@name, @spriteSheet, @spriteName, @spriteCount)

  actionStart: ->
    super()
    mCoords = App.stage.getMousePosition()
    @newAnimation(posX: mCoords.x, posY: mCoords.y, removeAfterDone: false, scale: 1, loop: true, animationSpeed: .1, getHandle: false)

  actionFinish: ->
    super()

  cleanUp: ->
    super()

  loadTool: ->
    super()
    App.stage.removeChild(@shadow)
    App.stage.removeChild(@icon)

  showShadow: (mCoords) ->
    super()

  showTool: (isActive) ->
    if isActive
      mCoords = App.stage.getMousePosition()
      @icon?.position?.y = mCoords.y
      @icon?.position?.x = mCoords.x

  switchOff: ->
    super()

  switchOn: ->
    mCoords = App.stage.getMousePosition()
    @icon = @newAnimation(posX: mCoords.x, posY: mCoords.y, removeAfterDone: false, scale: 1, loop: true, animationSpeed: .1, getHandle: true)
    super()
