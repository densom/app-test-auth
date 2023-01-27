var express = require('express');
var router = express.Router();
var password = "da#AS12.bkIa@2"

/* GET home page. */
router.get('/', function(req, res, next) {
  console.error('fake error');
  console.log(password);
  res.render('index', { title: 'Express' });
});

router.get('/fakevulnerability/:myParam', function(req, res, next){
  res.send(req.params['myParam']);
});

module.exports = router;
