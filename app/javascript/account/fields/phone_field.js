import 'intl-tel-input/build/css/intlTelInput.css';
import intlTelInput from 'intl-tel-input';

function enablePhoneFields($scope) {
  $scope.find('input[type="tel"]').each(function (index, field) {
    intlTelInput(field, {
      hiddenInput: $(field).attr('data-method'),
      utilsScript: "/assets/intl-tel-input_utils.js",
      customContainer: "w-full"
    });
  });
};

$(document).on('turbolinks:load', function() {
  enablePhoneFields($('body'));
})

$(document).on('sprinkles:update', function(event) {
  enablePhoneFields($(event.target));
})
