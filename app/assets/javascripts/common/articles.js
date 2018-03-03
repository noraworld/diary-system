$(function() {

  // 画像を囲む画像リンクを削除する
  $('a').children('img').unwrap();

  // YouTube などの埋め込みタグを div で囲む
  // videoDomains にドメインを追加することによって
  // YouTube の埋め込みと同様のスタイルを適用できる
  var videoDomains = [
    'www.youtube.com',
    'www.youtube-nocookie.com',
  ];
  for (var i = 0; i < videoDomains.length; i++) {
    $('iframe[src*="http://' + videoDomains[i] + '"]').wrap('<div class="video-player-wrapper">');
    $('iframe[src*="https://' + videoDomains[i] + '"]').wrap('<div class="video-player-wrapper">');
  }

});
