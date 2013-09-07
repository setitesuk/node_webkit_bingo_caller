var gui          = require('nw.gui');
var win          = gui.Window.get();
var EJS = require('ejs');
var fs = require('fs');

$(document).ready(function() {


  var main_content_ejs = EJS.compile(fs.readFileSync('bingocaller/views/main_content.ejs', 'utf8'));
  $('#content').html(main_content_ejs({localStorage: localStorage}));

  win.show();

});

