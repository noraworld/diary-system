'use strict';

{
  const TAB_SIZE = 4;
  const SPACES = ' '.repeat(TAB_SIZE);

  // Tab key
  function indent(event) {
    event.preventDefault();
    document.execCommand('insertText', false, SPACES);
  }

  // Backspace key
  function deleteCharacterOrDeleteIndent(event) {
    let [sentence, selection] = getTextareaInformation();

    // check if string between cursor position and 4 characters ago from cursor position is all spaces
    for (let i = selection.start - 1; i > selection.start - (1 + TAB_SIZE); i--) {
      if (sentence[i] !== ' ') {
        return false;
      }
    }

    event.preventDefault();

    for (let i = 0; i < TAB_SIZE; i++) {
      document.execCommand('delete', false, null);
    }
  }

  // Enter key
  function startNewlineWithKeepingIndent(event) {
    let [sentence, selection] = getTextareaInformation();

    // get the position of beginning of line that exists a caret
    let newlinePosition = 0;
    for (let i = selection.start - 1; i >= 0; i--) {
      if (sentence[i] === '\n' || sentence[i] === '\r') {
        newlinePosition = i + 1;
        break;
      }
    }

    // get the position of end of line that exists a caret
    let selectionEndOfLinePosition = sentence.length;
    for (let i = selection.start; i < sentence.length; i++) {
      if (sentence[i] === '\n' || sentence[i] === '\r') {
        selectionEndOfLinePosition = i;
        break;
      }
    }

    // trim all spaces if a line that exists a caret is all spaces
    let selectionLine = sentence.substr(newlinePosition, selectionEndOfLinePosition - newlinePosition);
    if (selectionLine.length !== 0 && selectionLine.trim() === '') {
      event.preventDefault();
      document.activeElement.selectionStart = newlinePosition;
      document.activeElement.selectionEnd   = selectionEndOfLinePosition;
      document.execCommand('insertText', false, '');
      document.execCommand('insertText', false, '\n');
      return true;
    }

    // get the amount of indent of line that exists a caret
    let spaceLength = 0;
    for (let i = newlinePosition; i <= selection.start - 1; i++) {
      if (sentence[i] === ' ') {
        spaceLength++;
      }
      else {
        break;
      }
    }

    event.preventDefault();

    // start a newline with keeping indent
    document.execCommand('insertText', false, '\n' + ' '.repeat(spaceLength));

    // get the position of beginning of last line
    let lastlineFirstPosition = 0;
    for (let i = document.activeElement.value.length - 1; i >= 0; i--) {
      if (document.activeElement.value[i] === '\n' || document.activeElement.value[i] === '\r') {
        lastlineFirstPosition = i + 1;
        break;
      }
    }

    // scroll to bottom if the caret exists in last line
    if (document.activeElement.selectionStart >= lastlineFirstPosition && document.activeElement.selectionStart <= document.activeElement.value.length) {
      document.activeElement.scrollTop = document.activeElement.scrollHeight;
    }
  }

  document.addEventListener('keydown', (event) => {
    // Ignore tab completion when IME is enabled (event.keyCode === 229)
    // Info: event.keyCode is 229 when IME is enabled
    if (!isFormFocused() || isPressedModifierKey(event) || event.keyCode === 229) {
      return false;
    }

    switch (event.key) {
      case 'Tab'       : indent(event);                        break;
      case 'Backspace' : deleteCharacterOrDeleteIndent(event); break;
    }
  });

  // Use keypress instead of keydown to avoid triggering event when pressing the enter to confirm input on IME
  // HINT: keypress event is not triggered when pressing the enter to confirm input on IME
  document.addEventListener('keypress', (event) => {
    // great!! shift + enter is now ordinary enter!
    // so you can use either:
    //   you want to start a newline with keeping indent    -> use enter
    //   you want to start a newline without keeping indent -> use shift + enter
    if (!isFormFocused() || isPressedModifierKey(event)) {
      return false;
    }

    switch (event.key) {
      case 'Enter' : startNewlineWithKeepingIndent(event); break;
    }
  });

  function getTextareaInformation() {
    let sentence = document.activeElement.value;
    let selection = { start: document.activeElement.selectionStart, end: document.activeElement.selectionEnd }

    return [sentence, selection];
  }

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

  function isPressedModifierKey(event) {
    if (event.metaKey === true) {
      return true;
    }
    else if (event.ctrlKey === true) {
      return true;
    }
    else if (event.altKey === true) {
      return true;
    }
    else if (event.shiftKey === true) {
      return true;
    }
    else {
      return false;
    }
  }
}
