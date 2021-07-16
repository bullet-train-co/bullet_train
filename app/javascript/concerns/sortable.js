require("dragula/dist/dragula.min.css")

import dragula from 'dragula';

function saveSortOrder($container) {
  var idsInOrder = $container.find('> *').map(function(index,element) { return parseInt($(element).attr('data-id')); }).toArray();
  $.post($container.attr('data-reorder'), {ids_in_order: idsInOrder}, function() {
    if ($container.closest('.opened-modally').length) {
      refreshModalBase();
    }
  });
}

function enableSortable($scope) {
  setTimeout(function() {
    var selector = '[data-reorder]';
    var $reorderable = $scope.find(selector).addBack(selector);
    console.log("enabling sort on array of " + $reorderable.length);

    $reorderable.each(function (index, container) {

      var $container = $(container);

      // enable drag-and-drop reordering.
      var dragulaObj = dragula([container], {
        moves: function(el, container, handle) {
          var $handles = $(el).find('.reorder-handle')
          if ($handles.length) {
            return !!$(handle).closest('.reorder-handle').length
          } else {
            if (!$(handle).closest('.undraggable').length) {
              return $(handle).closest('[data-reorder]')[0] == container;
            } else {
              return false;
            }
          }
        },
        accepts: function (el, target, source, sibling) {
          if ($(sibling).hasClass('undraggable') && $(sibling).prev().hasClass('undraggable')) {
            return false;
          } else {
            return true;
          }
        },
      }).on('drop', function (el) {

        // save order here.
        saveSortOrder($container);

      }).on('over', function (el, container) {

        // deselect any text fields, or else things go slow!
        $(document.activeElement).blur();

      });

    });
  }, 500);
}

$(document).on('turbo:load', function() {
  console.log("🍩 Sortable: Enabling on <body> after a Turbo load.")
  enableSortable($('body'));
})

$(document).on('sprinkles:update', function(event) {
  console.log("🍩 Sortable: Enabling on the following element after a Sprinkles content update:")
  console.log(event.target);
  enableSortable($(event.target));
})
