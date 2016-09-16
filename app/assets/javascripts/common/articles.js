$(function() {

  // 画像を囲む画像リンクを削除する
  $('a').children('img').unwrap();

  // YouTubeの埋め込みタグをdivで囲む
  $('iframe').wrap('<div class="video-player-wrapper">');

  // *.noraworld.jpは現在のタブで開きリファラを有効にする
  var domain = location.hostname.match(/^(.*?)([a-z0-9][a-z0-9\-]{1,63}\.[a-z\.]{2,6})[\:[0-9]*]?([\/].*?)?$/i)[2];
  $('a[href*="' + domain + '"]').removeAttr('target rel');

});
