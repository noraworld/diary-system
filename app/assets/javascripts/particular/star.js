// Operate stars in form.
// NOTE: This script works properly only when the number of stars is 10.

$(function() {
  // class name of star of Font Awesome
  const filledStarClassName    = 'fas';
  const notFilledStarClassName = 'far';

  // restore filled stars and unfilled stars information
  // when the controller action is "create", "edit", or "update"
  starValues = document.querySelectorAll('#post-form .templated-post-body .star-value');
  for (var i = 0; i < starValues.length; i++) {
    // star value becomes a empty string when the data is not set
    if (starValues[i].value === '') { continue; }

    for (var j = 0; j <= parseInt(starValues[i].value); j++) {
      if (starValues[i].parentNode.children[j].classList.contains('star')) {
        fillStar(starValues[i].parentNode.children[j]);
      }

      if (j === parseInt(starValues[i].value)) {
        starValues[i].parentNode.children[j].classList.add('focused');
      }
    }
  }

  stars = document.querySelectorAll('#post-form .templated-post-body .star');
  for (var i = 0; i < stars.length; i++) {
    stars[i].addEventListener('mouseover',  fillStars);
    stars[i].addEventListener('mouseleave', unfillStars);
    stars[i].addEventListener('click',      fixFilledStars);
  }

  // fill a focused star and stars on left side of it
  function fillStars() {
    thisPosition  = [].slice.call(stars).indexOf(this);
    startPosition = thisPosition - (thisPosition % 10);
    endPosition   = startPosition + 9;

    for (var i = startPosition; i <= thisPosition; i++) {
      fillStar(stars[i]);
    }
    for (var i = thisPosition + 1; i <= endPosition; i++) {
      unfillStar(stars[i]);
    }
  }

  // unfill all stars except when a star is focused on
  function unfillStars() {
    thisPosition  = [].slice.call(stars).indexOf(this);
    startPosition = thisPosition - (thisPosition % 10);
    endPosition   = startPosition + 9;

    // remember the position of a focused star if it exists
    focusedPosition = null;
    for (var i = startPosition; i <= endPosition; i++) {
      if (stars[i].classList.contains('focused')) {
        focusedPosition = i;
      }
    }

    if (focusedPosition !== null) {
      for (var i = startPosition; i <= focusedPosition; i++) {
        fillStar(stars[i]);
      }
      for (var i = focusedPosition + 1; i <= endPosition; i++) {
        unfillStar(stars[i]);
      }
    }
    else {
      for (var i = startPosition; i <= endPosition; i++) {
        unfillStar(stars[i]);
      }
    }
  }

  // focus a clicked star, and set the value to input element
  function fixFilledStars() {
    thisPosition  = [].slice.call(stars).indexOf(this);
    startPosition = thisPosition - (thisPosition % 10);
    endPosition   = startPosition + 9;
    starNodes     = this.parentNode.childNodes;

    if (this.classList.contains('focused')) {
      // unfocus a clicked star if it is already focused
      this.classList.remove('focused');

      // remove the value from input element
      for (var i = 0; i < starNodes.length; i++) {
        if (starNodes[i].className === 'star-value') {
          starNodes[i].value = null;
        }
      }
    }
    else {
      // focus a clicked star if it is not focused yet
      this.classList.add('focused');

      // set the value to input element
      for (var i = 0; i < starNodes.length; i++) {
        if (starNodes[i].className === 'star-value') {
          starNodes[i].value = (thisPosition % 10) + 1;
        }
      }
    }

    // if a star which is not clicked this time is focused on, unfocus it
    // in other words, if a star is focused the last time, unfocus it
    // herewith, the number of a focused star is always one
    for (var i = startPosition; i <= endPosition; i++) {
      if (this === stars[i]) { continue; }
      stars[i].classList.remove('focused');
    }
  }

  // fill a star
  function fillStar(star) {
    star.classList.remove(notFilledStarClassName);
    star.classList.add(filledStarClassName);
  }
  // unfill a star
  function unfillStar(star) {
    star.classList.remove(filledStarClassName);
    star.classList.add(notFilledStarClassName);
  }

});
