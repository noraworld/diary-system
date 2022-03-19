$(function() {

  Sortable.create(document.querySelector('#template-contents'), {
    handle: '.handle',
    draggable: '.draggable',
    animation: 150,
    onUpdate: function(event) {
      const xhr = new XMLHttpRequest();
      xhr.open('GET', '/templates/sort?from=' + event.oldDraggableIndex + '&to=' + event.newDraggableIndex);
      xhr.send();

      xhr.onreadystatechange = function(event) {
        switch (xhr.readyState) {
          case 0:
          case 1:
          case 2:
          case 3:
            sortStatusMarkElement = '<div class="sort-status-mark sort-status-mark-ok"><i class="fas fa-spinner fa-spin"></i></div>';
            showSortStatusMark(sortStatusMarkElement);
            break;
          case 4:
            $('.sort-status-mark').remove();

            if (xhr.status === 200) {
              sortStatusMarkElement = '<div class="sort-status-mark sort-status-mark-ok"><i class="fas fa-check"></i></div>';
            }
            else {
              console.log('HTTP status code: ' + xhr.status);
              console.log('XMLHttpRequest info:');
              console.log(xhr);
              console.log('Event info:');
              console.log(event);
              alert('Sorry, something went wrong.\nView your browser’s console to know what happened.');
              sortStatusMarkElement = '<div class="sort-status-mark sort-status-mark-ng"><i class="fas fa-times"></i></div>';
            }
            showSortStatusMark(sortStatusMarkElement);
            break;
        }
      }

      function showSortStatusMark(sortStatusMarkElement) {
        $(event.item).children('#template-title-edit-delete').prepend(sortStatusMarkElement);

        sortStatusMarkRemoveTimeoutID = window.setTimeout(function() {
          $('.sort-status-mark').fadeOut(400, function() {
            $(this).remove();
          });
          window.clearTimeout(sortStatusMarkRemoveTimeoutID);
        }, 500);
      }
    }
  });
});
