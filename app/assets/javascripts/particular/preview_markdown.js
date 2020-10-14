'use strict';

{
  const markdownEndpoint = '/api/v1/markdown';

  document.querySelector('#post-content').addEventListener('input', function() {
    var obj = {};
    obj['body'] = this.value;
    obj['authenticity_token'] = $('meta[name="csrf-token"]').attr('content');

    const method = 'POST';
    const headers = {
      'Accept': 'application/json',
      'Content-Type': 'application/x-www-form-urlencoded; charset=utf-8'
    };
    const body = Object.keys(obj).map((key) => key + '=' + encodeURIComponent(obj[key])).join('&');

    fetch(
      markdownEndpoint,
      {
        method,
        headers,
        body
      }
    ).then((response) => {
      if (response.ok) {
        return response.json();
      }
    }).then((data) => {
      document.querySelector('#post-content-preview').innerHTML = data.markdown;
    });
  });
}
