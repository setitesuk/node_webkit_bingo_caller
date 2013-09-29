var gui   = require('nw.gui');
var win   = gui.Window.get();
var util  = require('util');
var EJS   = require('ejs');
var fs    = require('fs');
var calls = require('./calls.json');

var game_data;

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

$(document).ready(function() {

  resetGameData();

  populateContent({}, 'main_content' )

  win.show();
  $('#debugger').click(function() {
	  win.showDevTools();
  });

});

function clearMain () {
  $('#main_content').remove();
}

function populateContent (data, file) {
  if ( ! file ) {
    file = data;
    data = game_data;
  }
  var content_ejs = EJS.compile(fs.readFileSync('bingocaller/views/'+file+'.ejs', 'utf8'));
  $('#content').html(content_ejs(data));
  initGameButtons();
}

function initGameButtons() {
  
  $('#max_draw').change( function () {
    var val = $('#max_draw').val();
    val = parseInt(val);
    game_data.max_ball = val;
    val++;
    game_data.remaining_balls = [];
    for ( var i = 1; i < val; i++ ) {
      game_data.remaining_balls.push(i);
    }
  } );

  $('#calls_on').change( function() {
     game_data.calls_on = game_data.calls_on ? false : true;
  } );

  $('#default_ball_count').change( function() {
     game_data.default_ball_count = game_data.default_ball_count ? false : true;
     if ( ! game_data.default_ball_count ) {
       $('#max_draw_select').removeClass('hidden');
     } else {
       $('#max_draw_select').addClass('hidden');
     }
  } );

  $('#draw').click( function () { drawBall(); } );

  $('#call').click( function () {
    clearMain();
    populateContent('check_numbers');
  } );

  $('#line_call_bad').click( function () {
    clearMain();
    populateContent(game_data, 'draw_number');
  } );

  $('#line_ok').click( function () {
    clearMain();
    game_data.calling_for_house = true;
    populateContent('draw_number');
  } );

  $('#house_call_bad').click( function () {
    clearMain();
    game_data.calling_for_house = true;
    populateContent('draw_number');
  } );

  $('#house_ok').click( function () {
    clearMain();
    populateContent('winner');
  } );

  $('#new_game').click( function () {
    clearMain();
    resetGameData();
    populateContent({}, 'main_content' )
  } );

  $('#begin_line').click( function () {
    clearMain();
    populateContent(game_data, 'draw_number');
  } );

  $('#begin_fh').click( function () {
    clearMain();
    game_data.calling_for_house = true;
    populateContent(game_data, 'draw_number');
  } );

  $('#quit').click( function () { win.close(); } );

}

function resetGameData() {
  game_data = {
    ball: null,
    default_ball_count: true,
    max_ball: 90,
    calling_for_house: null,
    last_call: null,
    drawn_balls: {},
    remaining_balls: [],
    last_five_calls: [],
    calls_on: true
  };
  
  for ( var i = 1; i < 91; i++ ) {
    game_data.remaining_balls.push(i);
  }
}

function drawBall () {
  game_data.remaining_balls.shuffle();
  var ball = game_data.remaining_balls.shift();
  if ( ! ball ) {
    $("#ball").html('<h2>No More Balls To Draw</h2>');
    $("#draw").attr('disabled','disabled');
  }
  game_data.last_call = ball;
  game_data.last_five_calls.push(ball);

  if ( game_data.last_five_calls.length > 5 ) {
    game_data.last_five_calls.shift();
  }

  game_data.drawn_balls[ball] = true;

  var html = '<img class="drawn_ball" id="ball_'+ball+'" src="gfx/balls/ball_'+ball+'.png" alt="'+ball+'" title="'+ball+'" />';

  if ( game_data.calls_on ) {
    html += '<div class="calls center">'+calls[ball]+'</div>';
  }

  html += '<table class="center"><thead></thead><tbody><tr>'
  for (var i = 0; i < game_data.last_five_calls.length; i++ ) {
    html += '<td style="text-align:center;">' + game_data.last_five_calls[i] + '</td>';
  }
  html += '</tr></tbody></table>';
  
  $("#ball").html(html);
}

