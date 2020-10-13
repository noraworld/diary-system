'use strict';

{
  const BUTTON_SELECTORS = '#listify, #privatify, #upload-image';
  let buttonElements = document.querySelectorAll(BUTTON_SELECTORS);

  let previousSentence = null;

  // event listener
  document.querySelector('#listify').addEventListener('click', () => {
    if (getActiveTextarea() === null) { return false; }
    listify();
  });
  document.querySelector('#privatify').addEventListener('click', () => {
    if (getActiveTextarea() === null) { return false; }
    privatify();
  });
  document.querySelector('#upload-image').addEventListener('click', () => {
    if (getActiveTextarea() === null) { return false; }
    let activeTextarea = getActiveTextarea();
    activeTextarea.focus();
    document.querySelector('#upload-image input').click();
  });
  document.querySelector('#upload-image input').addEventListener('change', () => {
    uploadS3();
  });

  // Remember active element before clicking editor markdown buttons
  var activeElementBeforeClickingListify = null;
  for (var i = 0; i < buttonElements.length; i++) {
    buttonElements[i].addEventListener('mouseover', () => {
      activeElementBeforeClickingListify = document.activeElement;
    });
  }

  // Prevent scrollTop from moving out of position when undoing or redoing listifying
  // I don't know why such behavior occurs
  let scrollTop = null;
  document.activeElement.oninput = (event) => {
    if (event.inputType === 'historyUndo' || event.inputType === 'historyRedo') {
      document.activeElement.scrollTop = scrollTop;
    }
    else {
      scrollTop = document.activeElement.scrollTop;
    }
  }
}

function listify() {
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

  let scrollTopBeforeListifying = activeTextarea.scrollTop;
  document.execCommand('insertText', false, lines.join('\n'));

  // prevent scrollTop from moving out of position when inserting text by 'document.execCommand'
  // I don't know why such behavior occurs
  activeTextarea.scrollTop = scrollTopBeforeListifying;
  scrollTop = scrollTopBeforeListifying;

  previousSentence = document.activeElement.value;
}

function privatify() {
  const PRIVATE_START_STRING = '{private}'
  const PRIVATE_END_STRING   = '{/private}'

  let activeTextarea = getActiveTextarea();
  activeTextarea.focus();

  document.execCommand('insertText', false, PRIVATE_START_STRING + activeTextarea.value.slice(activeTextarea.selectionStart, activeTextarea.selectionEnd) + PRIVATE_END_STRING);

  // Move a caret between PRIVATE_START_STRING and PRIVATE_END_STRING
  if (activeTextarea.selectionStart === activeTextarea.selectionEnd) {
    activeTextarea.selectionStart = activeTextarea.selectionEnd = activeTextarea.selectionStart - PRIVATE_END_STRING.length;
  }
}

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
