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

  // MEMO: jQuery 版フラグメントスクロールだとなぜか日本語のフラグメント識別子 (日本語の headline) に対しては
  // Syntax error, unrecognized expression になってしまうので
  // jQuery なしのバージョンでも同じ動作を行う
  fragments = document.querySelectorAll('#post-content a[href^="#"], #templated-post-body a[href^="#"]');
  for (var i = 0; i < fragments.length; i++) {
    fragments[i].addEventListener('click', function(event) {

      // h1 〜 h6 のフラグメント識別子をクリックしたときは URL を書き換えるが
      // 注釈リンクをクリックしたときは URL を書き換えない
      if (!this.hash.match(/^#fn(ref)?[0-9]+/g)) {
        history.pushState(null, null, this.hash);
      }

      const rect      = this.getBoundingClientRect();
      const scrollTop = window.pageYOffset || document.documentElement.scrollTop;
      const position  = rect.top + scrollTop + getOffset();

      scrollWithAnimation(event, position);
    });
  }

  // jQuery 版フラグメントスクロール
  $('#post-content a[href^="#"]').on('click', function(event) {
    const position = $(this.hash).offset().top + getOffset();

    scrollWithAnimation(event, position);
  });

  function getOffset() {
    return -10;
  }

  function scrollWithAnimation(event, position) {
    event.preventDefault();

    const properties = { scrollTop: position };
    const duration   = 350;
    const easing     = 'swing';

    $('html, body').stop().animate(properties, duration, easing);
  }

});
