express = require('express')
path = require('path')
favicon = require('serve-favicon')
logger = require('morgan')
cookieParser = require('cookie-parser')
bodyParser = require('body-parser')
multer = require('multer')
done = false
routes = require('./routes/index')
file_upload = require('./routes/file_upload')
app = express()

# view engine setup
app.set 'views', path.join(__dirname, 'views')
app.set 'view engine', 'jade'

#app.use(favicon(__dirname + '/public/favicon.ico'));
app.use logger('dev')
app.use bodyParser.json()
app.use bodyParser.urlencoded(extended: false)
app.use cookieParser()
app.use express.static(path.join(__dirname, 'public'))
app.use '/', routes
app.use '/file_upload', file_upload

app.use multer(
	dest: '/tmp'
	rename: (fieldname, filename) ->
		filename + Date.now()
	onFileUploadStart: (file) ->
		console.log file.originalname + ' is starting ...'
		return
	onFileUploadComplete: (file) ->
		console.log file.fieldname + ' uploaded to  ' + file.path
		done = true
		return
)

app.post '/api/photo', (req, res) ->
	if done == true
		console.log req.files
		res.send req.files.userPhoto.name
	return

# catch 404 and forward to error handler
app.use (req, res, next) ->
	err = new Error('Not Found')
	err.status = 404
	next err
	return

# error handlers

# development error handler
# will print stacktrace
if app.get('env') == 'development'
	app.use (err, req, res, next) ->
		res.status err.status or 500
		res.render 'error',
			message: err.message
			error: err
		return

# production error handler
# no stacktraces leaked to user
app.use (err, req, res, next) ->
	res.status err.status or 500
	res.render 'error',
		message: err.message
		error: {}
	return

module.exports = app
