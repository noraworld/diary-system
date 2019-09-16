$(function() {
  Sortable.create(document.querySelector('#template-contents'), {
    handle: '.draggable',
    animation: 150,
    onUpdate: function(event) {
      var xhr = new XMLHttpRequest();
      xhr.open('GET', '/templates/sort?from=' + event.oldDraggableIndex + '&to=' + event.newDraggableIndex);
      xhr.send();
    }
  });
});
