$(function() {

  // Click a cross button to close.
  $('#times').on('click', function() {
    $(this).parent().fadeOut(600, function() {
      $(this).remove();
    });
  });
  // Press esc key to close.
  $(window).on('keydown', function(event) {
    if ( !($('#times').length) ) {
      return false;
    }
    if (event.key === 'Escape') {
      $('#times').parent().fadeOut(600, function() {
        $(this).remove();
      });
    }
  });

});
