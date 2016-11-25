$(function() {

  // 画像を囲む画像リンクを削除する
  $('a').children('img').unwrap();

  // YouTubeの埋め込みタグをdivで囲む
  $('iframe').wrap('<div class="video-player-wrapper">');

  // 自分が所有するドメインは現在のタブで開きリファラを有効にする
  var myDomain = [
    'noraworld.jp',
    'noraworld.blog',
    'diary.noraworld.jp'
  ];
  for (var i = 0; i < myDomain.length; i++) {
    $('a[href*="http://'  + myDomain[i] + '"]').removeAttr('target rel');
    $('a[href*="https://' + myDomain[i] + '"]').removeAttr('target rel');
  }

});
