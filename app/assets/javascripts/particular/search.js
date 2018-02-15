$(function() {

  $('#search-form').on('submit', function(event) {
    if ($('#search').val() === '') {
      event.preventDefault();
    }
  });

});
