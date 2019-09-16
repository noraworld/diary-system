$(function() {

  var contents = {};
  document.querySelectorAll('.templated-post-body').forEach(function(element, index) {
    contents['templated-post-body-' + index] = element.value;
  });
  contents['post-content'] = document.querySelector('#post-content').value;

  window.onbeforeunload = function() {
    editingFlag = false;

    document.querySelectorAll('.templated-post-body').forEach(function(element, index) {
      if (element.value !== contents['templated-post-body-' + index]) {
        editingFlag = true;
      }
    });

    if (document.querySelector('#post-content').value !== contents['post-content']) {
      editingFlag = true;
    }

    if (editingFlag) {
      return false;
    }
  }

  $('#post-button').on('click', function() {
    window.onbeforeunload = false;
  });

});
