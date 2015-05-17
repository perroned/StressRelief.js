class @Chainsaw extends @Tool
  constructor: (@name) ->
    super @name

  doAction: ->
    console.log "using chainsaw"

  loadTool: ->
    @icon = PIXI.Sprite.fromImage("images/displacement_fish1.png")
    @icon.scale.x = @icon.scale.y = .2
    App.stage.addChild(@icon);

  showShadow: ->

  showTool: ->
    mCoords = App.stage.getMousePosition()
    @icon.position.y = mCoords.y
    @icon.position.x = mCoords.x
    @showShadow()
