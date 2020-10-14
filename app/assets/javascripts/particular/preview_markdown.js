'use strict';

{
  const postContent         = document.querySelector('#textarea #post-content');
  const templatedPostBodies = document.querySelectorAll('#textarea .templated-post-body');

  preview(postContent);

  postContent.addEventListener('input', preview);
  for (var i = 0; i < templatedPostBodies.length; i++) {
    preview(templatedPostBodies[i]);
    templatedPostBodies[i].addEventListener('input', preview);
  }
}

function preview(node = null) {
  const markdownEndpoint = '/api/v1/markdown';
  const _this = this || node;

  var obj = {};
  obj['body'] = _this.value;
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
    _this.parentNode.children.namedItem('post-content-preview').innerHTML = data.markdown;
  });
}
