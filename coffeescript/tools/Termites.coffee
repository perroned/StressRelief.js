class @Termites extends @Animator
  constructor: (@name) ->
    @termiteAnimator = null
    @spriteSheet = "Termite_Hands"
    @spriteName = "Termite_Hand_"
    @spriteCount = 2
    super(@name, @spriteSheet, @spriteName, @spriteCount)

  actionStart: ->
    super()
    mCoords = App.stage.getMousePosition()
    termiteScale = if randNum(0,10) > 5 then -1 else 1
    @termiteAnimator.newAnimation(posX: mCoords.x, posY: mCoords.y, removeAfterDone: false, scaleX: termiteScale, scaleY: 1, loop: true, animationSpeed: .1, getHandle: false)

  actionFinish: ->
    super()

  cleanUp: ->
    @termiteAnimator.cleanUp()
    super()

  loadTool: ->
    super()
    App.stage.removeChild(@shadow)
    App.stage.removeChild(@icon)
    @termiteAnimator = new Animator("Termite Animator", "Termites", "Termite_", 2)
    @termiteAnimator.loadTool()
    App.stage.removeChild(@termiteAnimator.shadow)
    App.stage.removeChild(@termiteAnimator.icon)

  showShadow: (mCoords) ->
    super()

  showTool: (isActive) ->
    if isActive
      mCoords = App.stage.getMousePosition()
      @icon?.position?.y = mCoords.y
      @icon?.position?.x = mCoords.x

    i = 0
    while i < @termiteAnimator?.animations.length
      termite = @termiteAnimator.animations[i]
      if termite.scale.x is -1
        termite.position.x -= .1
      else
        termite.position.x += .1
      i++


  switchOff: ->
    super()

  switchOn: ->
    mCoords = App.stage.getMousePosition()
    @icon = @newAnimation(posX: mCoords.x, posY: mCoords.y, removeAfterDone: false, scaleX: 1, scaleY: 1, loop: true, animationSpeed: .1, getHandle: true)
    super()
