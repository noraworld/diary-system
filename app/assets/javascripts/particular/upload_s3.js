'use strict';

function uploadS3() {
  const uploadedFiles = document.getElementById('files');
  var fileCounter     = 0;

  if (uploadedFiles.value === '') {
    console.log('Nothing to upload.');
    return false;
  }

  for (var i = 0; i < uploadedFiles.files.length; i++) {
    document.querySelector('#markdown-edit-button #upload-image #progress #all').textContent = parseInt(document.querySelector('#markdown-edit-button #upload-image #progress #all').textContent) + 1;
    if (parseInt(document.querySelector('#markdown-edit-button #upload-image #progress #completed').textContent) !== parseInt(document.querySelector('#markdown-edit-button #upload-image #progress #all').textContent)) {
      document.querySelector('#markdown-edit-button #upload-image #progress #status').classList.remove('fa-check');
      document.querySelector('#markdown-edit-button #upload-image #progress #status').classList.add('fa-spinner');
      document.querySelector('#markdown-edit-button #upload-image #progress #status').classList.add('fa-spin');
    }

    var url = getMediaApiEndpoint(uploadedFiles.files[i].name, uploadedFiles.files[i].type);

    console.log('Fetching media information...');
    fetch(
      url,
      {
        method: 'GET'
      }
    ).then(response => {
      if (response.ok) {
        console.log('Fetched media information sucessfully.');
        return response.json();
      }
    }).then((data) => {
      var formdata = [];
      formdata[fileCounter] = new FormData();

      for (var key in data.fields) {
        formdata[fileCounter].append(key, data.fields[key]);
      }

      getActiveTextarea().focus();
      document.execCommand('insertText', false, '![' + uploadedFiles.files[fileCounter].name + '](' + data.media_url + ')\n');

      formdata[fileCounter].append('file', uploadedFiles.files[fileCounter]);
      console.log(data.file_storage);
      if (data.file_storage === 'local') {
        formdata[fileCounter].append('authenticity_token', $('meta[name="csrf-token"]').attr('content'));
      }
      const headers = {
        'accept': 'multipart/form-data'
      }

      console.log('Posting images...');
      fetch(
        data.dest_domain,
        {
          method: 'POST',
          headers,
          body: formdata[fileCounter]
        }
      ).then((response) => {
        if (response.ok) {
          console.log('Posted images sucessfully!');

          document.querySelector('#markdown-edit-button #upload-image #progress #completed').textContent = parseInt(document.querySelector('#markdown-edit-button #upload-image #progress #completed').textContent) + 1;
          if (parseInt(document.querySelector('#markdown-edit-button #upload-image #progress #completed').textContent) === parseInt(document.querySelector('#markdown-edit-button #upload-image #progress #all').textContent)) {
            document.querySelector('#markdown-edit-button #upload-image #progress #status').classList.remove('fa-spinner');
            document.querySelector('#markdown-edit-button #upload-image #progress #status').classList.remove('fa-spin');
            document.querySelector('#markdown-edit-button #upload-image #progress #status').classList.add('fa-check');
          }

          return response.text();
        }
      })

      fileCounter = fileCounter + 1;
    });
  }
}

function getMediaApiEndpoint(filename, mimetype) {
  return '/api/v1/media?filename=' + filename + '&mimetype=' + mimetype;
}
