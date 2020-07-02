$(function() {
  bools = document.querySelectorAll('#post-form .templated-post-body .bool');
  for (var i = 0; i < bools.length; i++) {
    bools[i].addEventListener('click', select);
  }

  function select() {
    boolNodes = this.parentNode.childNodes;

    if (this.classList.contains('selected')) {
      this.classList.remove('selected');

      for (var i = 0; i < boolNodes.length; i++) {
        if (boolNodes[i].className === 'bool-value') {
          boolNodes[i].value = null;
        }
      }
    }
    else {
      this.classList.add('selected');

      var yesOrNo = null;
      if (this.classList.contains('yes')) {
        yesOrNo = 'yes';
      }
      else if (this.classList.contains('no')) {
        yesOrNo = 'no';
      }
      else {
        alert('Something went wrong!');
      }

      for (var i = 0; i < boolNodes.length; i++) {
        if (boolNodes[i].className === 'bool-value') {
          boolNodes[i].value = yesOrNo;
        }
      }
    }
  }

});
