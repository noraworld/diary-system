'use strict';

{
  document.addEventListener('keydown', (event) => {
    if (isFormFocused()) {
      if (event.key === 'Tab') {
        event.preventDefault();

        const TAB_SIZE = 4;
        const SPACES = ' '.repeat(TAB_SIZE);

        let sentence = document.activeElement.value;
        let len = sentence.length;
        let selectionStartPosition = document.activeElement.selectionStart;
        let selectionEndPosition = document.activeElement.selectionEnd;
        let before = sentence.substr(0, selectionStartPosition);
        let after = sentence.substr(selectionEndPosition, len);

        document.activeElement.value = before + SPACES + after;
        document.activeElement.selectionStart = selectionStartPosition + TAB_SIZE;
        document.activeElement.selectionEnd = selectionStartPosition + TAB_SIZE;
      }
    }
  });

  function isFormFocused() {
    if (document.activeElement.nodeName === 'INPUT' && document.activeElement.getAttribute('type') !== 'range') {
      return true;
    }
    else if (document.activeElement.nodeName === 'TEXTAREA') {
      return true;
    }
    else if (document.activeElement.getAttribute('type') === 'text') {
      return true;
    }
    else if (document.activeElement.isContentEditable === true) {
      return true;
    }
    else {
      return false;
    }
  }
}
