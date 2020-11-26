var timeout;

var checkServerForProgressUpdates = function() {

  // see https://gist.github.com/niyazpk/f8ac616f181f6042d1e0
  function updateUrlParameter(uri, key, value) {
      var i = uri.indexOf('#');
      var hash = i === -1 ? ''  : uri.substr(i);
           uri = i === -1 ? uri : uri.substr(0, i);
      var re = new RegExp("([?&])" + key + "=.*?(&|$)", "i");
      var separator = uri.indexOf('?') !== -1 ? "&" : "?";
      if (uri.match(re)) {
          uri = uri.replace(re, '$1' + key + "=" + value + '$2');
      } else {
          uri = uri + separator + key + "=" + value;
      }
      return uri + hash;  // finally append the hash as well
  }

  // add a flag to skip the layout on refresh.
  var url = updateUrlParameter(window.location.href, 'layoutless', true);

  // re-fetch the page.
  $.get(url, function(data) {

    // for each item on the current page that is still marked as progressing.
    $("[data-progressing='true']").each(function (index, existing) {
      var $existing = $(existing);

      // e.g. 'Scaffolding::Thing'
      var type = $(existing).attr('data-class');

      // e.g. '10'
      var id = $(existing).attr('data-id');

      // find the corresponding element on the re-fetched page.
      var $updated = $($(data).find("[data-class='" + type + "'][data-id='" + id + "']").first());

      // if the existing row was still marked as processing ..
      if (parseInt($updated.attr('data-updated')) > parseInt($existing.attr('data-updated'))) {
        $existing.replaceWith($updated);
      }

    })

  });

  // if there are still progressing elements, this will trigger another update.
  scheduleCheckForProgressUpdatesIfNeeded();

}

var scheduleCheckForProgressUpdatesIfNeeded = function() {
  // if there are items on the page whose progress is still updating, dispatch a timer.
  if ($("[data-progressing='true']").length > 0) {
    console.log("🏚 progress polling: we'll check the server for updates in 5 seconds.")
    timeout = setTimeout(checkServerForProgressUpdates, 5000);
  }

}

$(document).on('turbolinks:load', function() {
  if (timeout) {
    console.log("🏚 progress polling: canceling an existing timer.")
    clearTimeout(timeout);
    timeout = null;
  }
  scheduleCheckForProgressUpdatesIfNeeded();
});
