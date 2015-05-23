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
  App.keyboard(49).press = -> changeTool(0)
  App.keyboard(50).press = -> changeTool(1)
  App.keyboard(51).press = -> changeTool(2)
  App.keyboard(52).press = -> changeTool(3)
  App.keyboard(53).press = -> changeTool(4)
  App.keyboard(54).press = -> changeTool(5)
