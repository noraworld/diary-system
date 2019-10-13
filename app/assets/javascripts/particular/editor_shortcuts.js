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
  function deleteCharacterOrIndent(event) {
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
    let newlinePosition = 0;

    for (let i = selection.start - 1; i >= 0; i--) {
      if (sentence[i] === '\n' || sentence[i] === '\r') {
        newlinePosition = i + 1;
        break;
      }
    }

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

  document.addEventListener('keydown', (event) => {
    if (!isFormFocused() || isPressedModifierKey(event)) {
      return false;
    }

    switch (event.key) {
      case 'Tab'       : indent(event);                  break;
      case 'Backspace' : deleteCharacterOrIndent(event); break;
    }
  });

  // Use keypress instead of keydown to avoid triggering event when pressing the enter to confirm input on IME
  // HINT: keypress event is not triggered when pressing the enter to confirm input on IME
  document.addEventListener('keypress', (event) => {
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
