'use strict';

{
  document.querySelector('#listify').addEventListener('click', (event) => {
    if (getActiveTextarea() === null) {
      return false;
    }

    let activeTextarea = getActiveTextarea();
    let sentence = activeTextarea.value;
    let selection = { start: activeTextarea.selectionStart, end: activeTextarea.selectionEnd };

    activeTextarea.focus();

    let isSelectionStartFirstLine = true;
    for (let i = selection.start - 1; i >= 0; i--) {
      if (sentence[i] === '\r' || sentence[i] === '\n') {
        activeTextarea.selectionStart = i + 1;
        isSelectionStartFirstLine = false;
        break;
      }
    }
    if (isSelectionStartFirstLine === true) {
      activeTextarea.selectionStart = 0;
    }

    let isSelectionEndLastLine = true;
    for (let i = selection.end; i < sentence.length; i++) {
      if (sentence[i] === '\r' || sentence[i] === '\n') {
        activeTextarea.selectionEnd = i;
        isSelectionEndLastLine = false;
        break;
      }
    }
    if (isSelectionEndLastLine === true) {
      activeTextarea.selectionEnd = sentence.length;
    }

    let lines = sentence
                  .substr(activeTextarea.selectionStart, activeTextarea.selectionEnd - activeTextarea.selectionStart)
                  .replace(/\r\n|\r/g, "\n")
                  .split('\n');

    for (let i = 0; i < lines.length; i++) {
      // trim empty line
      // this contains only spaces line
      if (lines[i].replace(/ /g, '') === '') {
        continue;
      }

      for (let j = 0; j < lines[i].length; j++) {
        if (lines[i][j] !== ' ') {
          if (j === 0) {
            lines[i] = '- ' + lines[i];
          }
          else {
            lines[i] = lines[i].slice(0, j) + '- ' + lines[i].slice(j);
          }
          break;
        }
      }
    }

    document.execCommand('insertText', false, lines.join('\n'));
  });

  let activeElementBeforeClickingListify = null;
  document.querySelector('#listify').addEventListener('mouseover', (event) => {
    activeElementBeforeClickingListify = document.activeElement;
  });

  function getActiveTextarea() {
    if (activeElementBeforeClickingListify !== null && activeElementBeforeClickingListify.getAttribute('id') === 'post-content') {
      return activeElementBeforeClickingListify;
    }
    else if (activeElementBeforeClickingListify !== null && activeElementBeforeClickingListify.getAttribute('class') === 'templated-post-body') {
      return activeElementBeforeClickingListify;
    }
    else if (document.activeElement.getAttribute('class') === 'templated-post-body') {
      return document.activeElement;
    }
    else if (document.activeElement.getAttribute('id') === 'post-content') {
      return document.activeElement;
    }
    else {
      return null;
    }
  }
}
