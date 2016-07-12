$(function() {

  $('.post-link').parent().hover(function() {
    $(this).css('z-index', 10000).css('border', '2px solid white');
    $(this).animate({
      scale: [1.2, 1.2]
    }, 100);
  }, function() {
    $(this).animate({
      scale: [1.0, 1.0],
    }, {duration: 100, complete: function() { $(this).css('z-index', 1).css('border', 'none'); }});
  });

});
