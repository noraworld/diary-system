$(function() {

  $('#config').on('click', function(event) {
    if ($('#listbox').css('visibility') === 'hidden') {
      event.stopPropagation();
      $('#listbox').css('visibility', 'inherit');
      $('#config').css('opacity', 0.4);
    }
    else if ($('#listbox').css('visibility') === 'inherit') {
      $('#listbox').css('visibility', 'hidden');
      $('#config').css('opacity', 1);
    }
  }).on('mouseover', function() {
    $('#config').css('opacity', 0.4);
  }).on('mouseout', function() {
    if ($('#listbox').css('visibility') === 'hidden') {
      $('#config').css('opacity', 1);
    }
  });
  $(document).on('click', function() {
    $('#listbox').css('visibility', 'hidden');
    $('#config').css('opacity', 1);
  });

  $('body').on('keydown', function(event) {
    if (event.key === 'Escape') {
      if ($('#listbox').css('visibility') !== 'hidden') {
        $('#listbox').css('visibility', 'hidden');
        $('#config').css('opacity', 1);
      }
    }
  });

});
