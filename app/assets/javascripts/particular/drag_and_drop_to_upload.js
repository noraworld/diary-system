'use strict';

{
  const dragAndDropFields = document.querySelectorAll('textarea#post-content, textarea.templated-post-body');

  for (var i = 0; i < dragAndDropFields.length; i++) {
    dragAndDropFields[i].addEventListener('dragover', function(event) {
      event.preventDefault();
      event.target.classList.add('dragover');
    });
    dragAndDropFields[i].addEventListener('dragleave', function(event) {
      event.target.classList.remove('dragover');
    });
    dragAndDropFields[i].addEventListener('drop', function(event) {
      event.preventDefault();
      event.target.classList.remove('dragover');
      document.querySelector('#files').files = event.dataTransfer.files;
      // this.focus(); // somehow it sometimes does not take effect even if 'this' is a drag-and-drop element
      uploadS3(this);
    });
  }
}
