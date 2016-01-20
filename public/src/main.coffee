# set up global namespace
@App = @App or {}

@init = ->
	window.onload = ->
		$('#ToolsModal').foundation('reveal', 'open');
		App.sound = {}
		setupScene()
		setupTools()
		App.registerKeys()

		@animate = ->
			showTool()
			App.renderer.render App.stage
			requestAnimFrame animate
			return

		requestAnimFrame animate
