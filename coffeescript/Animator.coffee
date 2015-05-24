class @Animator extends @Tool
  constructor: (@name, @spriteSheet, @spriteName, @spriteCount) ->
    super(@name)
    @animationTextures = []
    @animations = []

  actionStart: ->
    super()

  actionFinish: ->
    super()

  cleanUp: ->
    @animations = super([@animations])

  loadTool: ->
    assetsToLoader = [ "resources/images/tools/damage/#{@spriteSheet}.json"];
    # create a new loader
    loader = new PIXI.AssetLoader(assetsToLoader);
    # use callback
    loader.onComplete = =>
      i = 0
      while i < @spriteCount
        # texture = PIXI.Texture.fromFrame("Explosion_Sequence_A " + (i+1) + ".png");
        texture = PIXI.Texture.fromFrame("#{@spriteName} " + (i+1) + ".png");
        @animationTextures.push(texture);
        i++

    #begin load
    loader.load();
    @icon = PIXI.Sprite.fromImage("resources/images/tools/tools/hammer.png")
    @icon.anchor.x = @icon.anchor.y = .5
    @icon.scale.x = @icon.scale.y = .5
    @shadow = PIXI.Sprite.fromImage("resources/images/tools/tools/hammer.png")
    @shadow.scale.x = @shadow.scale.y = .5
    # darken the color. Set 50% transparency
    @shadow.tint = 0x151515
    @shadow.alpha = 0.5
    super()

  newAnimation: (config)->
    animation = new PIXI.MovieClip(@animationTextures);
    animation.position.x = config.posX
    animation.position.y = config.posY
    animation.anchor.x = 0.5;
    animation.anchor.y = 0.5;
    animation.rotation = Math.random() * Math.PI;
    animation.scale.x = animation.scale.y = config.scale
    animation.gotoAndPlay(0);
    App.pondContainer.addChild(animation);
    animation.loop = false
    animation.removeAfterDone = config.removeAfterDone
    @animations.push animation


  showShadow: (mCoords) ->
    super()

  showTool: (isActive) ->
    super()
    i = 0
    while i < @animations.length
      if not @animations[i].playing
        if @animations[i].removeAfterDone
          App.pondContainer.removeChild(@animations[i]);
          @animations.splice(i,1)
      i++

  switchOff: ->
    super()

  switchOn: ->
    super()
