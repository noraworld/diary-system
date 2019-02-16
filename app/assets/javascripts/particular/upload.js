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
        var textarea = $('#post-content');
        var filename = file.upload.filename.match(/(.*)(?:\.([^.]+$))/)[1];
        var filepath = file.upload.filename;

        var date = new Date();
        // 5時間前(午前5時までは前の日の日付で保存される)
        date.setMinutes(date.getMinutes() - 60 * 5);
        var year = date.getFullYear() + '';
        var month = ('0' + (date.getMonth() + 1)).slice(-2);
        var image = '![' + filename + '](/images/' + year + '/' + month + '/' + filepath + ')';
        var sentence = getInsertionSentence(image);

        textarea.val(sentence);
      });
    },
    renameFilename: function(filename) {
      var fileExtension = filename.match(/(.*)(?:\.([^.]+$))/)[2].toLowerCase();
      var length = 16;

      // example: '34c1da733b52350e.png'
      return getRandomizedHexadecimal(length) + '.' + fileExtension;
    },
  });

  // insert a image string to cursor position
  function getInsertionSentence(image) {
    var textarea = document.querySelector('#post-content');

    // release selection if some letters in textarea are selected
    if (textarea.selectionStart !== textarea.selectionEnd) {
      textarea.selectionEnd = textarea.selectionStart;
    }

    var sentence = textarea.value;
    var len = sentence.length;
    var pos = textarea.selectionStart;
    var before = sentence.substr(0, pos);
    var after = sentence.substr(pos, len);

    var sentence = before + image + after;

    // append a new line if the cursor position locates at the last line
    if (pos === len) {
      sentence += '\n\n';
    }

    return sentence;
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

});
