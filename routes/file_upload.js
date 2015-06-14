var express = require('express');
var router = express.Router();
var path = require('path');

/* retrieve a file */
router.get('/', function(req, res, next) {
  var mypath = path.join(__dirname+'\\..\\uploads\\')+req.query.img;
  res.sendFile(mypath);
});

module.exports = router;
