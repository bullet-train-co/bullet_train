// submit modal forms via ajax and populate the results in the modal.
$(document).on('submit', 'form.action-cable-result', function(event) {
  event.preventDefault();

  var $form = $(event.currentTarget);

  // don't mess with submissions in a modal.
  if ($form.closest('.modal').length == 0) {
    var path = $form.attr('action');
    var type = $form.attr('method') || 'PUT';
    var payload = $form.serializeArray();

    payload.push({name: 'layoutless', value: 'true'});

    $.ajax({url: path, type: 'POST', data: payload, success: function(data) {
      console.log("Message was successfully posted. Result will come in via ActionCable.");
    }, error: function(data) {
      alert("Sorry, we encountered an error. It will be logged in the server console or exception tracker.")
      console.log(data.responseText);
    }});

    $form.trigger("reset");
    $form.find('[type="submit"]').removeAttr('disabled');
    $form.find('[autofocus]').focus();
    // TODO some buttons weren't being re-enabled without this.
    // it's got to be a race condition with jquery-ujs.
    setTimeout(function() {
      $form.find('[type="submit"]').removeAttr('disabled');
    }, 500);
  }
});

// open links into another section of the page.
$(document).on('click', '.open-inline', function(event) {
  var $link = $(event.currentTarget);
  event.preventDefault();

  var url = $link.attr('href');

  $inlineBase = $($link.attr('data-target'));
  if ($inlineBase.attr('data-url') !== $inlineBase) {
    $inlineBase.addClass('loading');
    $.get(url, {layoutless: true}, function(data) {
      $inlineBase.empty();
      $inlineBase.append($(data));
      $inlineBase.attr('data-url', url);
      $inlineBase.removeClass('loading');
      $inlineBase.trigger('sprinkles:update');
    });
  }
});
