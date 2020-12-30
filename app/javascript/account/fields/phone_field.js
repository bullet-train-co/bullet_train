import 'intl-tel-input/build/css/intlTelInput.css';
import intlTelInput from 'intl-tel-input';

function enablePhoneFields($scope) {
  $scope.find('input[type="tel"]').each(function (index, field) {
    intlTelInput(field, {
      hiddenInput: $(field).attr('data-method'),
      utilsScript: "https://cdnjs.cloudflare.com/ajax/libs/intl-tel-input/17.0.8/js/utils.js",
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
