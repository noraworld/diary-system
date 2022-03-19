'use strict';

{
  var contents = {};
  document.querySelectorAll('.templated-post-body').forEach(function(element, index) {
    contents['templated-post-body-' + index] = element.value;
  });
  contents['post-content'] = document.querySelector('#post-content').value;

  window.onbeforeunload = isEditing;

  $('#post-button').on('click', function() {
    if (document.querySelector('#markdown-edit-button #upload-image #progress #completed').textContent === document.querySelector('#markdown-edit-button #upload-image #progress #all').textContent) {
      window.onbeforeunload = false;
    }
    else {
      if (window.confirm('Image uploading has not been incompleted yet! Are you sure you want to submit anyway?')) {
        window.onbeforeunload = false;
        return true;
      }
      else {
        return false;
      }
    }
  });
}

function isEditing() {
  let editingFlag = false;

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
