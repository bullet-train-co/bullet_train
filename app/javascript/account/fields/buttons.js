function enableButtons($scope) {
  // safari does what we expected by default, but chrome wasn't checking the radio or checkbox.
  $scope.find('.btn-toggle button').on('click', function(event){

    // we have to stop safari from doing what we originally expected.
    event.preventDefault();

    // then we need to manually click the hidden checkbox ourselves.
    const inputEl = $(event.target).closest('.btn-toggle').find('input[type=radio], input[type=checkbox]');

    inputEl.trigger('click');
  });
}

$(document).on('turbolinks:load', function() {
  enableButtons($('body'));
})

$(document).on('sprinkles:update', function(event) {
  enableButtons($(event.target));
})
