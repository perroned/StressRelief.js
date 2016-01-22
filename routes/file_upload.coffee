express = require('express')
router = express.Router()
path = require('path')

### retrieve a file ###

router.get '/', (req, res, next) ->
	console.log "retrieving image"
	mypath = '/tmp/' + req.query.img
	res.sendFile mypath
	return

module.exports = router
