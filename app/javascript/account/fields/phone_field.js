require("intl-tel-input/build/css/intlTelInput.css")

import 'intl-tel-input';

function enablePhoneFields($scope) {
  $scope.find('input[type="tel"]').each(function (index, field) {
    var $field = $(field);
    $field.intlTelInput({
      hiddenInput: $field.attr('data-method'),
      utilsScript: "https://intl-tel-input.com/node_modules/intl-tel-input/build/js/utils.js"
    });
  });
};

$(document).on('turbolinks:load', function() {
  enablePhoneFields($('body'));
})

$(document).on('sprinkles:update', function(event) {
  enablePhoneFields($(event.target));
})
