$(function() {

  timesRemoveTimeoutID = window.setTimeout(function() {
    $('#times').parent().fadeOut(600, function() {
      $(this).remove();
    });
    window.clearTimeout(timesRemoveTimeoutID);
  }, 2000);

});
