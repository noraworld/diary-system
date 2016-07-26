$(function() {

  $('#times').on('click', function() {
    $(this).parent().fadeOut(600, function() {
      $(this).remove();
    });
  });

});
