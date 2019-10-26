$(function() {

  // Click a cross button to close.
  $('#times').on('click', function() {
    $(this).parent().fadeOut(600, function() {
      $(this).remove();
    });
  });
  // Press esc key to close.
  window.addEventListener('keydown', function(event) {
    if ((document.activeElement.nodeName === 'INPUT'
    || document.activeElement.nodeName === 'TEXTAREA'
    || document.activeElement.getAttribute('type') === 'text')
    || document.activeElement.isContentEditable === true
    || !($('#times').length) ) {
      return false;
    }
    else if (event.key === 'Escape') {
      $('#times').parent().fadeOut(600, function() {
        $(this).remove();
      });
    }
  });

});
