$(function() {

  $('a').children('img').unwrap();

  $('iframe').wrap('<div class="video-player-wrapper">');

  var domain = location.hostname.match(/^(.*?)([a-z0-9][a-z0-9\-]{1,63}\.[a-z\.]{2,6})[\:[0-9]*]?([\/].*?)?$/i)[2];
  $('a[href*="' + domain + '"]').removeAttr('target rel');

});
