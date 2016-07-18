// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or any plugin's vendor/assets/javascripts directory can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file.
//
// Read Sprockets README (https://github.com/rails/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require jquery
//= require jquery_ujs
//= require_tree .

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

});
