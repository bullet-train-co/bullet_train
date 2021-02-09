require("select2/dist/css/select2.min.css");

import $ from 'jquery';
import 'select2';

function enableSelects($scope) {
  $scope.find('.select2').each(function(index, select) {
    var $select = $(select);
    var options = {};

    if ($select.hasClass('disable-search')) {
      options.minimumResultsForSearch = -1;
    }

    options.tags = $select.hasClass('accepts-new');

    // https://stackoverflow.com/questions/29290389/select2-add-image-icon-to-option-dynamically
    function formatState (opt) {
      var imageUrl = $(opt.element).attr('data-image');
      var imageHtml = "";
      if (imageUrl) {
        imageHtml = '<img src="' + imageUrl + '" /> ';
      }
      return $('<span>' + imageHtml + opt.text + '</span>');
    };

    options.templateResult = formatState;
    options.templateSelection = formatState;
    options.width = 'style';

    $select.select2(options);
  });
}

$(document).on('turbo:load', function() {
  enableSelects($('body'));
})

$(document).on('sprinkles:update', function(event) {
  enableSelects($(event.target));
})
