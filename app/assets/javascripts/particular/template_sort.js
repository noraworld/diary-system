$(function() {
  Sortable.create(document.querySelector('#template-contents'), {
    handle: '.draggable',
    animation: 150,
    onUpdate: function(event) {
      console.log('old was ' + event.oldDraggableIndex);
      console.log('new is ' + event.newDraggableIndex);
    }
  });
});
