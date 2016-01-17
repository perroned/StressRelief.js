@dateForImage = ->
	dat = new Date()
	time = dat.toString().substr(4, 20).replace(/[\ :]/g, '_') + '_' + dat.getMilliseconds()

@randNum = (min, max) ->
	Math.floor(Math.random() * (max - min) + min)

@saveImage = ->
	console.log "Here"
	image = App.renderer.view.getContext("2d").canvas.toDataURL("image/png").replace("image/png", "image/octet-stream");
	name = "StressRelief_js_#{dateForImage()}.png"
	link = null

	if window.chrome? # chrome
		link = document.createElement('a');
	else # firefox
		link = document.getElementById("saveImageButton");

	link.href = image
	link.download = name;
	link.click() if window.chrome?
