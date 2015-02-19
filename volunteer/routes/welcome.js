var express = require('express');
var fs = require('fs');
var router = express.Router();

var settingsFile = './settings.json';

/* GET home page. */
router.get('/', function(req, res, next) {
  res.render('index', { });
});

router.get('/settings.json', function(req, res, next) {
	res.json( JSON.parse(fs.readFileSync(settingsFile)));
});

router.get('/settings.html', function(req, res, next) {
	res.render('settings');
});


router.get('/status.json', function(req, res, next) {
	res.json({
		running: false,
		disk_used_bytes: 1000,
		affinity_offset: 2,
		target_replication_percent: 20
	});
});

router.post('/settings', function(req, res, next) {
	var settings = req.body;
	// console.log(settings);
	fs.writeFile(settingsFile, JSON.stringify(settings, null, 4), function(err) {
		if(err) {
			console.log("Couldn't save user settings.");
		} else {
			console.log("User settings saved.");
		}
	});
});

router.get('/(:page).html', function(req, res, next) {
  res.render(req.params.page, { });
});

module.exports = router;
