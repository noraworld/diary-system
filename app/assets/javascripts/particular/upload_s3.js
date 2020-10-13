'use strict';

function uploadS3() {
  const uploadedFiles = document.getElementById('files');
  var s3Urls          = [];
  var filenames       = [];
  var fileCounter     = 0;

  if (uploadedFiles.value === '') {
    console.log('Nothing to upload.');
    return false;
  }

  for (var i = 0; i < uploadedFiles.files.length; i++) {
    var url = '/s3?filename=' + uploadedFiles.files[i].name + "&mimetype=" + uploadedFiles.files[i].type;

    fetch(
      url,
      {
        method: 'GET'
      }
    ).then(response => {
      if (response.ok) {
        return response.json();
      }
    }).then((data) => {
      var formdata = [];
      formdata[fileCounter] = new FormData();

      for (var key in data.fields) {
        formdata[fileCounter].append(key, data.fields[key]);
      }

      s3Urls.push(data.s3_url);
      filenames.push(uploadedFiles.files[fileCounter].name);

      formdata[fileCounter].append("file", uploadedFiles.files[fileCounter]);
      const headers = {
        'accept': 'multipart/form-data'
      }

      fetch(
        data.url,
        {
          method: 'POST',
          headers,
          body: formdata[fileCounter]
        }
      ).then((response) => {
        if (response.ok) {
          getActiveTextarea().focus();
          document.execCommand('insertText', false, '![' + filenames[0] + '](' + s3Urls[0] + ')\n');
          s3Urls.shift();
          filenames.shift();

          return response.text();
        }
      })

      fileCounter = fileCounter + 1;
    });
  }
}
