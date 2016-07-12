$(function() {

  $('.post-box').on('mouseover', function() {
    $(this).css('z-index', 2).css('border', '2px solid white');
    $(this).stop().animate({
      scale: [1.15, 1.15]
    }, 50);
  }).on('mouseout', function() {
    $(this).css('z-index', 1);
    $(this).stop().animate({
      scale: [1.0, 1.0]
    }, {duration: 50, complete: function() {$(this).css('border', '2px solid rgba(255, 255, 255, 0)'); }});
  });

});
