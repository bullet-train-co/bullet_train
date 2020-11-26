require("bootstrap-daterangepicker/daterangepicker.css");

import 'bootstrap-daterangepicker';

function enableDateFields($scope) {
  function clearDate(event) {

    // don't submit the form.
    event.preventDefault();

    // find a bunch of relevant elements.
    var $dateField = $(event.target).closest('.date-input').find('input');

    // clear the cloudinary id.
    $dateField.val(null);

  }

  $scope.find('input.single-daterange').daterangepicker({
    singleDatePicker: true,
    autoUpdateInput: false,
    locale: {
      cancelLabel: 'Clear'
    }
  });

  $scope.find('input.single-daterange').on('apply.daterangepicker', function(ev, picker) {
    $(this).val(picker.startDate.format('MM/DD/YYYY'));
  });

  $scope.find('input.single-daterange').on('cancel.daterangepicker', function(ev, picker) {
    $(this).val('');
  });

  $scope.find(".date-input button.clear").click(clearDate);
}

$(document).on('turbolinks:load', function() {
  enableDateFields($('body'));
})

$(document).on('sprinkles:update', function(event) {
  enableDateFields($(event.target));
})
