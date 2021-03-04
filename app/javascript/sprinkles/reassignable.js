require("dragula/dist/dragula.min.css")

import dragula from 'dragula';

function saveAssignments($container) {
  var parents = $container.find('[data-reassignment-parent]').map(function(index,element) { return parseInt($(element).attr('data-id')); }).toArray();
  var assignmentsById = {}
  $.each(parents, function(_, parentId) {
    assignmentsById[parentId] = $container.find("[data-reassignment-parent]").filter("[data-id='" + parentId + "']").find("[data-reassignable]").map(function(index,element) { return parseInt($(element).attr('data-id')); }).toArray();
  });
  $.post($container.attr('data-reassign'), {assignments_by_id: assignmentsById, dispatched_at: new Date().getTime()});
}

function enableReassignable($scope) {
  setTimeout(function() {
    var selector = '[data-reassign]';
    var $reassignable = $scope.find(selector).addBack(selector);

    $reassignable.each(function (_, container) {

      console.log("🍩 Reassignable 💬 Found the following container:")
      console.log(container);

      var $container = $(container);
      var dragulaObj = dragula($container.find('[data-reassignment-parent]').toArray(), {
        moves: function(el, container, handle) {
          if ($(handle).hasClass('undraggable') || ($(handle).closest('.undraggable').length > 0)) {
            return false;
          }
          return !!$(handle).closest('[data-reassignable]').length;
        },
        accepts: function (el, target, source, sibling) {
          if ($(sibling).hasClass('undraggable') && $(sibling).prev().hasClass('undraggable')) {
            return false;
          } else {
            return true;
          }
        },
      }).on('drag', function (el) {
        $reassignable.addClass('show-reassignable-targets')
      }).on('drop', function (el) {
        $reassignable.removeClass('show-reassignable-targets')
        saveAssignments($container);
      }).on('cancel', function (el) {
        $reassignable.removeClass('show-reassignable-targets')
        saveAssignments($container);
      }).on('over', function (el, container) {
        $(document.activeElement).blur();
      });
    });
  }, 500);
}

$(document).on('turbo:load', function() {
  console.log("🍩 Reassignable: Enabling on <body> after a Turbo load.")
  enableReassignable($('body'));
})

$(document).on('sprinkles:update', function(event) {
  console.log("🍩 Reassignable: Enabling on the following element after a Sprinkles content update:")
  console.log(event.target);
  enableReassignable($(event.target));
})
