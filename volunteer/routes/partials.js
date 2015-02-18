var express = require('express');
var router = express.Router();

router.get = function(req, res, next){
  var filename = req.params.filename;
  if(!filename) return;  // might want to change this
  res.render("partials/" + filename );
};

// exports.index = function(req, res){
//   res.render('index', {message:"Hello!!!"});
// };


module.exports = router;
