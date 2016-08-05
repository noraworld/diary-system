$(function() {

  Dropzone.autoDiscover = false;
  $('#upload-dropzone').dropzone({
    url: '/upload',
    // uploadアクションで使用するパラメータと一致していないといけない
    paramName: 'data[file]',
    params: {
      'data[document_id]': 123
    },
    dictDefaultMessage: '<span class="icon-file-picture picture-icon"></span><br><span>Drag and drop or<br>click to upload image file</span>',
    dictResponseError: 'Failed to upload. Please try again.',
    // headers: {
      // 応急処置としてCSRFトークンを入れてみたけどなくてもアップロードできるみたい
      // 'X-CSRF-Token': $('#upload-dropzone input').eq(1).attr('value')
    // }
    init: function() {
      this.on('addedfile', function(file) {
        var textarea = $('#post-content');
        var filename = file.name.match(/(.*)(?:\.([^.]+$))/)[1].toLowerCase();
        var filepath = file.name.toLowerCase();

        var date = new Date();
        // 5時間前(午前5時までは前の日の日付で保存される)
        date.setMinutes(date.getMinutes() - 60 * 5);
        var year = date.getFullYear() + ''
        var month = ('0' + (date.getMonth() + 1)).slice(-2);

        textarea.val(textarea.val() + '![' + filename + '](/images/' + year + '/' + month + '/' + filepath + ')\n\n');
      });
    },
    renameFilename: function(filename) {
      return filename.toLowerCase();
    },
  });

});
