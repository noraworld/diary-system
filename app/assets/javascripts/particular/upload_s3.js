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
    document.querySelector('#markdown-edit-button #upload-image #progress #all').textContent = parseInt(document.querySelector('#markdown-edit-button #upload-image #progress #all').textContent) + 1;
    var url = '/s3?filename=' + uploadedFiles.files[i].name + "&mimetype=" + uploadedFiles.files[i].type;

    console.log('Fetching AWS presigned URL...');
    fetch(
      url,
      {
        method: 'GET'
      }
    ).then(response => {
      if (response.ok) {
        console.log('Fetched AWS presigned URL sucessfully.');
        return response.json();
      }
    }).then((data) => {
      var formdata = [];
      formdata[fileCounter] = new FormData();

      for (var key in data.fields) {
        formdata[fileCounter].append(key, data.fields[key]);
      }

      getActiveTextarea().focus();
      document.execCommand('insertText', false, '![' + uploadedFiles.files[fileCounter].name + '](' + data.s3_url + ')\n');

      formdata[fileCounter].append("file", uploadedFiles.files[fileCounter]);
      const headers = {
        'accept': 'multipart/form-data'
      }

      console.log('Posting images to AWS S3...');
      fetch(
        data.url,
        {
          method: 'POST',
          headers,
          body: formdata[fileCounter]
        }
      ).then((response) => {
        if (response.ok) {
          console.log('Posted images sucessfully!');
          document.querySelector('#markdown-edit-button #upload-image #progress #completed').textContent = parseInt(document.querySelector('#markdown-edit-button #upload-image #progress #completed').textContent) + 1;

          return response.text();
        }
      })

      fileCounter = fileCounter + 1;
    });
  }
}
