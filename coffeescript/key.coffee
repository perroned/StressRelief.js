App.keyboard = (keyCode) ->
  key = {}
  key.code = keyCode
  key.isDown = false
  key.isUp = true
  key.press = undefined
  key.release = undefined

  #The `downHandler`
  key.downHandler = (event) ->
    if event.keyCode == key.code
      if key.isUp and key.press
        key.press()
      key.isDown = true
      key.isUp = false
    event.preventDefault()
    return

  #The `upHandler`
  key.upHandler = (event) ->
    if event.keyCode == key.code
      if key.isDown and key.release
        key.release()
      key.isDown = false
      key.isUp = true
    event.preventDefault()
    return

  #Attach event listeners
  window.addEventListener 'keydown', key.downHandler.bind(key), false
  window.addEventListener 'keyup', key.upHandler.bind(key), false
  key

App.registerKeys = ->
  keyObject = App.keyboard(65);
  keyObject.press = ->
    # Create the `cat` sprite
    texture = PIXI.TextureCache["images/displacement_fish1.png"];
    cat = new PIXI.Sprite(texture);
    cat.y = 96;
    cat.vx = 0;
    cat.vy = 0;
    App.stage.addChild(cat);
