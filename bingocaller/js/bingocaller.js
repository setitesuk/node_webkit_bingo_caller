var gui          = require('nw.gui');
var win          = gui.Window.get();
var util = require('util');
var EJS = require('ejs');
var fs = require('fs');

var game_data = {
  ball: null,
  calling_for_house: null,
  drawn_balls: {},
  remaining_balls: []
};

$(document).ready(function() {

  for ( var i = 1; i < 91; i++ ) {
    game_data.remaining_balls.push(i);
  }

  populate_content({}, 'main_content' )

  win.show();
  $('#debugger').click(function() {
	  win.showDevTools();
  });


  Array.prototype.shuffle = function() {
    var i = this.length, j, temp;
    if ( i == 0 ) return this;
    while ( --i ) {
       j = Math.floor( Math.random() * ( i + 1 ) );
       temp = this[i];
       this[i] = this[j];
       this[j] = temp;
    }
    return this;
  }

  $('#max_draw').change( function () {
    var val = $('#max_draw').val();
    val++;
    game_data.remaining_balls = [];
    for ( var i = 1; i < val; i++ ) {
      game_data.remaining_balls.push(i);
    }
  } );

  $('#begin_line').click( function () {
    clear_main();
    util.error('begin_line');
    populate_content(game_data, 'draw_number');
  } );

  $('#begin_fh').click( function () {
    clear_main();
    game_data.calling_for_house = true;
    populate_content(game_data, 'draw_number');
  } );

});

function clear_main () {
  console.log('remove_content');
  $('#main_content').remove();
  util.error($('#content').html())
}

function populate_content (data, file) {
  var content_ejs = EJS.compile(fs.readFileSync('bingocaller/views/'+file+'.ejs', 'utf8'));
  $('#content').html(content_ejs(data));
}
