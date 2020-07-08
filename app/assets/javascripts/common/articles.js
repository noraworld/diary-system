$(function() {

  // CSS 4 の :has() が登場したら CSS で書きたい！
  // https://qiita.com/yassh/items/bf3c341e53c0f86a384a
  $('#post-content p, .templated-post-body p').has('img:not(.emoji)').css('text-align', 'center').css('line-height', '1.15');
  $('#post-content a, .templated-post-body a').has('img:not(.emoji)').css('border-bottom', '0').css('margin', '0');
  $('#post-content p a img, .templated-post-body p a img').css('margin-top', '31px');
  $('#post-content p a:first-of-type img, .templated-post-body p a:first-of-type img').css('margin-top', '0');

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

  headlines = '#post-content h1, '        +
              '#post-content h2, '        +
              '#post-content h3, '        +
              '#post-content h4, '        +
              '#post-content h5, '        +
              '#post-content h6, '        +
              '.templated-post-body h1, ' +
              '.templated-post-body h2, ' +
              '.templated-post-body h3, ' +
              '.templated-post-body h4, ' +
              '.templated-post-body h5, ' +
              '.templated-post-body h6'

  headlinesAndFragmentAnchors = headlines                     +
                                ', '                          +
                                '#post-content h1 a, '        +
                                '#post-content h2 a, '        +
                                '#post-content h3 a, '        +
                                '#post-content h4 a, '        +
                                '#post-content h5 a, '        +
                                '#post-content h6 a, '        +
                                '.templated-post-body h1 a, ' +
                                '.templated-post-body h2 a, ' +
                                '.templated-post-body h3 a, ' +
                                '.templated-post-body h4 a, ' +
                                '.templated-post-body h5 a, ' +
                                '.templated-post-body h6 a'

  $(headlines).find('a').css('display', 'none');

  $(headlinesAndFragmentAnchors).hover(function() {
    $(this).find('a').css('display', '');
  },
  function() {
    $(this).find('a').css('display', 'none');
  });

  // MEMO: jQuery 版フラグメントスクロールだとなぜか日本語のフラグメント識別子 (日本語の headline) に対しては
  // Syntax error, unrecognized expression になってしまうので
  // jQuery なしのバージョンでも同じ動作を行う
  fragments = document.querySelectorAll('#post-content a[href^="#"], .templated-post-body a[href^="#"]');
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
  $('#post-content a[href^="#"], .templated-post-body a[href^="#"]').on('click', function(event) {
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
