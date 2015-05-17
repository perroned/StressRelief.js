@setupWeapon = ->
  App.weapon = PIXI.Sprite.fromImage("images/displacement_fish1.png")
  App.weapon.scale.x = App.weapon.scale.y = .2
  App.stage.addChild(App.weapon);

@showWeapon = ->
  mCoords = App.stage.getMousePosition()
  App.weapon.position.y = mCoords.y
  App.weapon.position.x = mCoords.x
