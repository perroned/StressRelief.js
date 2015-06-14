express = require('express')
router = express.Router()
path = require('path')

### retrieve a file ###

router.get '/', (req, res, next) ->
	mypath = path.join(__dirname + '\\..\\uploads\\') + req.query.img
	res.sendFile mypath
	return

module.exports = router
