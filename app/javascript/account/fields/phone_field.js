import 'intl-tel-input/build/css/intlTelInput.css';
import '../../stylesheets/account/fields/phone_field.scss';
import intlTelInput from 'intl-tel-input';

function enablePhoneFields($scope) {
  $scope.find('input[type="tel"]').each(function (index, field) {
    intlTelInput(field, {
      hiddenInput: $(field).attr('data-method'),
      // See `config/webpack/environment.js` for where we copy this into place.
      // TODO Wish we could somehow incorporate webpacker's cache-breaking hash into this. Anyone know how?
      utilsScript: "/assets/intl-tel-input/utils.js",
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
