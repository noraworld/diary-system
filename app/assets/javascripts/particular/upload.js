$(function() {

  Dropzone.autoDiscover = false;
  $('#upload-dropzone').dropzone({
    url: '/upload',
    // uploadアクションで使用するパラメータと一致していないといけない
    paramName: 'data[file]',
    params: {
      'data[document_id]': 123
    },
    acceptedFiles: 'image/*',
    dictDefaultMessage: '<span class="icon-file-picture picture-icon"></span><br><span>Drag and drop or<br>click to upload image file</span>',
    dictResponseError: 'Failed to upload. Please try again.',
    // headers: {
      // 応急処置としてCSRFトークンを入れてみたけどなくてもアップロードできるみたい
      // 'X-CSRF-Token': $('#upload-dropzone input').eq(1).attr('value')
    // }
    init: function() {
      this.on('success', function(file) {
        var filename = file.upload.filename.match(/(.*)(?:\.([^.]+$))/)[1];
        var filepath = file.upload.filename;

        var date = new Date();
        // 5時間前(午前5時までは前の日の日付で保存される)
        date.setMinutes(date.getMinutes() - 60 * 5);
        var year = date.getFullYear() + '';
        var month = ('0' + (date.getMonth() + 1)).slice(-2);
        var image = '![' + filename + '](/images/' + year + '/' + month + '/' + filepath + ')';

        insertImageTag(image);
      });
    },
    renameFilename: function(filename) {
      const fileExtension = filename.match(/(.*)(?:\.([^.]+$))/)[2].toLowerCase();
      const length = 64;

      // example: '53426c97b1c3f65fb3ef9f669604a0b2fcce89f48c464dcb4ff68cc8d5ad322e.png'
      return getRandomizedHexadecimal(length) + '.' + fileExtension;
    },
  });

  // insert a image string to cursor position
  function insertImageTag(image) {
    var activeTextarea = [];

    if (activeElementBeforeClickingDropzone
    &&  activeElementBeforeClickingDropzone.getAttribute('class') === 'templated-post-body'
    ||  activeElementBeforeClickingDropzone.getAttribute('id')    === 'post-content') {
      activeTextarea = activeElementBeforeClickingDropzone;
    }
    else if (document.activeElement.getAttribute('class') === 'templated-post-body'
    ||       document.activeElement.getAttribute('id')    === 'post-content') {
      activeTextarea = document.activeElement;
    }
    else {
      activeTextarea = document.querySelector('#post-content');
    }

    // release selection if some letters in active textarea are selected
    if (activeTextarea.selectionStart !== activeTextarea.selectionEnd) {
      activeTextarea.selectionEnd = activeTextarea.selectionStart;
    }

    var sentence = activeTextarea.value;
    var len = sentence.length;
    var pos = activeTextarea.selectionStart;
    var before = sentence.substr(0, pos);
    var after = sentence.substr(pos, len);
    var newline = '\n';

    var sentence = before + image;
    if (pos == len) {
      sentence += newline;
    }
    sentence += after;

    activeTextarea.value = sentence;

    if (pos == len) {
      activeTextarea.selectionStart = activeTextarea.selectionEnd = (before + image + newline).length;
    }
    else {
      activeTextarea.selectionStart = activeTextarea.selectionEnd = (before + image).length;
    }

    return true;
  }

  function getRandomizedHexadecimal(randomizedHexadecimalLength) {
    hexSeed = '0123456789abcdef';
    hexSeedLength = hexSeed.length
    randomizedHexadecimal = '';

    for (var i = 0; i < randomizedHexadecimalLength; i++) {
      randomizedHexadecimal += hexSeed[Math.floor(Math.random() * hexSeedLength)];
    }

    return randomizedHexadecimal;
  }

  var activeElementBeforeClickingDropzone = null;
  document.querySelector('#upload-dropzone').addEventListener('mouseover', function() {
    activeElementBeforeClickingDropzone = document.activeElement;
  });

});
