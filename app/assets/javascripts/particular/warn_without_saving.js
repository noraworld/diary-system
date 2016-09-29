$(function() {

  var contents = $('#post-content').val();
  window.onbeforeunload = function() {
    if (contents !== $('#post-content').val()) {
      return false;
    }
  }

  $('#post-button').on('click', function() {
    window.onbeforeunload = false;
  });

});
