'use strict';

{
  const postContent         = document.querySelector('#textarea #post-content');
  const templatedPostBodies = document.querySelectorAll('#textarea .templated-post-body');

  preview(postContent);
  postContent.addEventListener('input', preview);
  postContent.addEventListener('input', scrollSync);
  postContent.addEventListener('scroll', scrollSync);

  for (var i = 0; i < templatedPostBodies.length; i++) {
    preview(templatedPostBodies[i]);
    templatedPostBodies[i].addEventListener('input', preview);
    templatedPostBodies[i].addEventListener('input', scrollSync);
    templatedPostBodies[i].addEventListener('scroll', scrollSync);
  }
}

function scrollSync() {
  const editorScrollRatio = this.scrollTop / (this.scrollHeight - this.clientHeight);
  const previewAutoScrollPosition = Math.round((this.parentNode.children.namedItem('post-content-preview').scrollHeight - this.parentNode.children.namedItem('post-content-preview').clientHeight) * editorScrollRatio);

  this.parentNode.children.namedItem('post-content-preview').scrollTop = previewAutoScrollPosition;
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
