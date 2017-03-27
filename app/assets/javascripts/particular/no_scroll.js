// this script is for iOS devices
// prevent to scroll on body
// instead of: `overflow: hidden;`

var textarea = document.querySelector('#post-content');
textarea.scrollTop = 1;

window.addEventListener('touchmove', function(event) {
  // textarea is scrollable, but body is not
  if (event.target === textarea && textarea.scrollTop !== 0 && textarea.scrollTop + textarea.clientHeight !== textarea.scrollHeight) {
    event.stopPropagation();
  }
  else {
    event.preventDefault();
  }
});

textarea.addEventListener('scroll', function(event) {
  // avoid to scroll on body through textarea scrolling
  // when exists in top or bottom in textarea
  if (textarea.scrollTop === 0) {
    textarea.scrollTop = 1;
  }
  else if (textarea.scrollTop + textarea.clientHeight === textarea.scrollHeight) {
    textarea.scrollTop = textarea.scrollTop - 1;
  }
});
