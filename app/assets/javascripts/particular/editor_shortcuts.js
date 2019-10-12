'use strict';

{
  document.addEventListener('keydown', (event) => {
    if (!isFormFocused()) {
      return false;
    }

    const TAB_SIZE = 4;
    const SPACES = ' '.repeat(TAB_SIZE);

    let sentence = document.activeElement.value;
    let selectionStartPosition = document.activeElement.selectionStart;

    if (event.key === 'Tab') {
      event.preventDefault();
      document.execCommand('insertText', false, SPACES);
    }
    else if (event.key === 'Backspace') {
      // check if string between cursor position and 4 characters ago from cursor position is all spaces
      for (let i = selectionStartPosition - 1; i > selectionStartPosition - (1 + TAB_SIZE); i--) {
        if (sentence[i] !== ' ') {
          return false;
        }
      }

      event.preventDefault();

      for (let i = 0; i < TAB_SIZE; i++) {
        document.execCommand('delete', false, null);
      }
    }
    else if (event.key === 'Enter') {
      let newlinePosition = 0;

      for (let i = selectionStartPosition - 1; i >= 0; i--) {
        if (sentence[i] === '\n' || sentence[i] === '\r') {
          newlinePosition = i + 1;
          break;
        }
      }

      let spaceLength = 0;
      for (let i = newlinePosition; i <= selectionStartPosition - 1; i++) {
        if (sentence[i] === ' ') {
          spaceLength++;
        }
        else {
          break;
        }
      }

      event.preventDefault();
      document.execCommand('insertText', false, '\n' + ' '.repeat(spaceLength));

      let lastlineFirstPosition = 0;
      for (let i = document.activeElement.value.length - 1; i >= 0; i--) {
        if (document.activeElement.value[i] === '\n' || document.activeElement.value[i] === '\r') {
          lastlineFirstPosition = i + 1;
          break;
        }
      }

      if (document.activeElement.selectionStart >= lastlineFirstPosition && document.activeElement.selectionStart <= document.activeElement.value.length) {
        document.activeElement.scrollTop = document.activeElement.scrollHeight;
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
