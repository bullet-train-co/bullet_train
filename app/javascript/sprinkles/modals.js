function collectScrollPositions($element) {
  var scrollPositions = {};
  scrollPositions['body'] = {left: $('body').scrollLeft(), top: $('body').closest('body').scrollTop()}
  $element.find("*").each(function () {
    var $scrollElement = $(this);
    if ($scrollElement.scrollLeft() || $scrollElement.scrollTop()) {
      var scrollId = $scrollElement.attr('data-scroll-id');
      if (scrollId) {
        scrollPositions[scrollId] = {left: $scrollElement.scrollLeft(), top: $scrollElement.scrollTop()}
      }
    }
  })
  return scrollPositions;
}

function applyScrollPositions(scrollPositions, $element) {
  $.each(scrollPositions, function(scrollId, scroll) {
    var $scrollElement;
    if (scrollId == 'body') {
      $scrollElement = $('body');
    } else {
      $scrollElement = $element.find("[data-scroll-id='" + scrollId + "']");
    }
    $scrollElement.scrollLeft(scroll.left).scrollTop(scroll.top);
  });
}

function refreshModalBase() {
  var $existingModalBase = $('.modal-base')
  if (!$existingModalBase.hasClass('skip-modal-base-refreshes')) {
    $.get(document.location.href, {layoutless: true}, function(data) {
      $modalBase = $(data).find('.modal-base');
      if ($modalBase.length) {
        var scrollPositions = collectScrollPositions($('.modal-base'));
        $existingModalBase.empty();
        $existingModalBase.replaceWith($modalBase);
        applyScrollPositions(scrollPositions, $modalBase);
        $modalBase.trigger('sprinkles:update');
      }
    });
  }
}

function handleModalResponse(data, textStatus, request, $modal) {
  var $termination = $(data).find('.modal-terminate');
  if ($termination.length) {
    refreshModalBase();
    if ($modal) {
      closeModal($modal);
    }
  } else {
    var $elementBox = $(data).find('.element-box');
    // var $elementBox = $(data).find('.element-box, .alert');
    if (!$modal.length) {
      $modal = $('#modal-template').clone().removeAttr('id').addClass('opened-modally');
      $modal.find('.modal-body').append($elementBox);
      $modal.modal();
      $modal.find('input[autofocus]').trigger('focus')
      $modal.on('hidden.bs.modal', function() {
        $modal.remove();
      });
    } else {
      $modal.find('.modal-body').empty().append($elementBox);
    }

    // keep track of where the current content came from, incase we need to reload it.
    // TODO I don't think we actually do anything with the method. Should we?
    var url = request.getResponseHeader('X-Sprinkles-Request-URL');
    var method = request.getResponseHeader('X-Sprinkles-Request-Method');
    $modal.attr('data-url', url);
    $modal.attr('data-method', method);

    $elementBox.trigger('sprinkles:update');
    refreshModalBase();
  }
}

function closeModal($modal) {
  $modal.addClass('modal--remove');
  $modal.parent().find('.modal-backdrop').addClass('modal-backdrop--remove');
  setTimeout(function() {
    $modal.modal('hide');
  }, 1000);
}

// submit modal forms via ajax and populate the results in the modal.
$(document).on('submit', 'form.submit-modally, .opened-modally form', function(event) {
  event.preventDefault();

  var $form = $(event.currentTarget);
  var $modal = $form.closest('.modal')

  if ($form.hasClass('filter-form')) {
    return false;
    // closeModal($modal);
  }

  var path = $form.attr('action');
  var type = $form.attr('method') || 'PUT';
  var payload = $form.serializeArray();

  // TODO this doesn't really do enough right now, because of redirects, which won't remember this.
  payload.push({name: 'layoutless', value: 'true'});

  if ($form.hasClass('action-cable-result')) {
    // TODO this is solving a race condition where rails is disabling the submit button _after_ we were trying to re-enable it.
    setTimeout(function() {
      $form.trigger('reset');
      $form.find('input[type=submit]').removeAttr('disabled');
    }, 100);
  }

  $.ajax({url: path, type: 'POST', data: payload, success: function(data, textStatus, request) {
    if (!$form.hasClass('action-cable-result')) {
      $form.find('input[type=submit]').removeAttr('disabled');
      $form.trigger('reset');
      handleModalResponse(data, textStatus, request, $modal);
    }
  }, error: function(data) {
    alert("Sorry, we encountered an error. It will be logged in the server console or exception tracker.")
    console.log(data.responseText);
  }});

});

// TODO this doesn't play nicely with rails ujs stuff, e.g. data-method = destroy.
$(document).on('click', 'a.open-modally, .opened-modally a', function(event) {
  var $link = $(event.currentTarget);
  if (!$link.hasClass('follow-unmodally') && !$link.attr('target')) {
    event.preventDefault();
    var path = $link.attr('href');
    var type = $link.attr('data-method') || 'GET';
    var $modal = $link.closest('.modal').first(); // this might not exist.
    // we're going to disable this for everything but get requests and let ujs handle all the other types of requests.
    if (type.toUpperCase() == 'GET') {
      if ((path == window.location.pathname && type.toUpperCase() == 'GET') || $link.hasClass('close-modal')) {
        closeModal($modal);
      } else {
        $.ajax({url: path, type: type, data: {layoutless: true}, success: function(data, textStatus, request) {
          handleModalResponse(data, textStatus, request, $modal);
        }});
      }
    }
  }
});
