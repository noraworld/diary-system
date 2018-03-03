$(function() {

  // 画像を囲む画像リンクを削除する
  $('a').children('img').unwrap();

  // YouTubeの埋め込みタグをdivで囲む
  $('iframe').wrap('<div class="video-player-wrapper">');

});
