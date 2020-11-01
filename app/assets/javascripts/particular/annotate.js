'use strict';

function annotate() {
  const textareas = document.querySelectorAll('textarea#post-content, textarea.templated-post-body');
  let texts = '';

  for (var i = 0; i < textareas.length; i++) {
    texts += textareas[i].value;
  }

  const annotationNumber = getAnnotationNumber(texts);

  getActiveTextarea().focus();
  document.execCommand('insertText', false, '[^' + annotationNumber + ']');

  document.activeElement.selectionStart = document.activeElement.selectionEnd = getAnnotationPosition();
  if (document.activeElement.value[document.activeElement.selectionStart] === '\n' && document.activeElement.value[document.activeElement.selectionStart - 1] === '\n') {
    document.execCommand('insertText', false, '\n[^' + annotationNumber + ']: ');
  }
  else {
    document.execCommand('insertText', false, '\n\n[^' + annotationNumber + ']: ');
  }
  if (document.activeElement.selectionStart !== document.activeElement.value.length && document.activeElement.value[document.activeElement.selectionStart + 1] !== '\n') {
    document.execCommand('insertText', false, '\n');
    document.activeElement.selectionStart = document.activeElement.selectionEnd -= 1;
  }
}

function getAnnotationNumber(texts) {
  let i = 1;

  while (true) {
    if (texts.includes('[^' + i + ']')) {
      i++;
    }
    else {
      return i;
    }

    // stopper
    if (i > 1000) {
      alert('something went wrong!!!');
      break;
    }
  }
}

function getAnnotationPosition() {
  const element = document.activeElement;

  for (var i = element.selectionStart; i < element.value.length; i++) {
    if (element.value[i] === '\n') {
      return i;
    }
    else {
      i++;
    }
  }

  return element.value.length;
}
