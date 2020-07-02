$(function() {
  let elements = document.querySelectorAll('.submit-onchange');
  for (var i = 0; i < elements.length; i++) {
    elements[i].addEventListener('change', function() {
      console.log(this.form.submit());
    });
  }
});
