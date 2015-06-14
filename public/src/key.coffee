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
	# escape key
	App.keyboard(27).release = ->
		if not $("#optionsModal").is(":visible")
			$('#ToolsModal').foundation('reveal', ("close" if $("#ToolsModal").is(":visible")) or "open")

	# 1
	App.keyboard(49).press = -> changeTool(App.ToolEnum.HAMMER)
	# 2
	App.keyboard(50).press = -> changeTool(App.ToolEnum.CHAINSAW)
	# 3
	App.keyboard(51).press = -> changeTool(App.ToolEnum.MACHINEGUN)
	# 4
	App.keyboard(52).press = -> changeTool(App.ToolEnum.FLAMETHROWER)
	# 5
	App.keyboard(53).press = -> changeTool(App.ToolEnum.COLORTHROWER)
	# 6
	App.keyboard(54).press = -> changeTool(App.ToolEnum.PHASER)
	# 7
	App.keyboard(55).press = -> changeTool(App.ToolEnum.STAMPER)
	# 8
	App.keyboard(56).press = -> changeTool(App.ToolEnum.EXPLODER)
	# 9
	App.keyboard(57).press = -> changeTool(App.ToolEnum.TERMITES)
