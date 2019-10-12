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
    // TODO: add listify button to editor and move this feature
    else if (event.key === 'Control') {
      for (let i = selectionStartPosition - 1; i >= 0; i--) {
        if (sentence[i] === '\r' || sentence[i] === '\n') {
          document.activeElement.selectionStart = i + 1;
          break;
        }
      }

      let lines = sentence.substr(document.activeElement.selectionStart, document.activeElement.selectionEnd - document.activeElement.selectionStart).replace(/\r\n|\r/g, "\n").split('\n');
      for (let i = 0; i < lines.length; i++) {
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

      // let selectionEndPosition = document.activeElement.selectionEnd;
      // let hyphenInsertionPositions = [];

      // for (let i = selectionStartPosition - 1; i >= 0; i--) {
      //   if (sentence[i] === ' ') {
      //     hyphenInsertionPositions.push(i + 1);
      //     break;
      //   }
      // }
      // if (hyphenInsertionPositions.length === 0) {
      //   hyphenInsertionPositions.push(0);
      // }

      // for (let i = selectionStartPosition - 1; i < selectionEndPosition; i++) {
      //   if (sentence[i] === '\n' || sentence[i] === '\r') {
      //     do {
      //       i++;
      //     } while (sentence[i] === ' ' || i > document.activeElement.value.length);

      //     hyphenInsertionPositions.push(i);
      //   }
      // }

      // hyphenInsertionPositions = hyphenInsertionPositions.map((_element, index, _array) => {
      //   return hyphenInsertionPositions[index] + index * 2;
      // });

      // for (let i = 0; i < hyphenInsertionPositions.length; i++) {
      //   document.activeElement.selectionStart = hyphenInsertionPositions[i];
      //   document.activeElement.selectionEnd   = hyphenInsertionPositions[i];
      //   document.execCommand('insertText', false, '- ');
      // }
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
