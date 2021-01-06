function enableCloudinaryImages($scope) {
  function getCloudinarySignature(callback, paramsToSign) {
    $.ajax({
     url: "/account/cloudinary/upload_signatures/new",
     type: "GET",
     dataType: "text",
     data: {data: paramsToSign},
     complete: function() { console.log("complete") },
     success: function(signature, textStatus, xhr) { callback(signature); },
     error: function(xhr, status, error) { console.log(xhr, status, error); }
    });
  }

  function uploadImageForCloudinaryField(event) {

    // don't submit the form.
    event.preventDefault();

    // find a bunch of relevant elements.
    var $cloudinaryField = $(event.target).closest('.cloudinary-field');
    var $hiddenField = $cloudinaryField.find("input[type='hidden']");
    var $uploadButton = $cloudinaryField.find("button.upload");

    // prepare the list of default sources a user can upload an image from.
    var defaultSources = ['local', 'url', 'camera'];
    if ($cloudinaryField.attr('data-google-api-key')) {
      defaultSources.push('image_search')
    }

    // configure cloudinary's uploader's options.
    // many of these are configurable at the point where the `shared/fields/cloudinary_image` partial is included.
    var options = {
      cloud_name: $cloudinaryField.attr('data-cloud-name'),
      apiKey: $cloudinaryField.attr('data-api-key'),
      upload_preset: $cloudinaryField.attr('data-upload-preset'),
      upload_signature: getCloudinarySignature,
      multiple: false,
      sources: $cloudinaryField.attr('data-sources') ? $cloudinaryField.attr('data-sources').split(',') : defaultSources,
      search_by_rights: $cloudinaryField.attr('data-search-by-rights') == 'false' ? false : true, // default to true.
      google_api_key: $cloudinaryField.attr('data-google-api-key'),
    }

    // open cloudinary's upload widget.
    cloudinary.openUploadWidget(options, function(error, notifications) {

      // after the user has successfully uploaded a single file ..
      $(notifications).each(function(index, notification) {
        if (notification.event == 'success') {
          var data = notification.info;

          // update the cloudinary id field in the form.
          $hiddenField.val(data.public_id);

          // remove any existing image.
          $uploadButton.find('img').remove();

          // generate a new image preview url.
          var url = $cloudinaryField.attr('data-url-format').replace('CLOUDINARY_ID', data.public_id);
          var width = $cloudinaryField.attr('data-width');
          var height = $cloudinaryField.attr('data-height');
          var $imageElement = $("<img src=\"" + url + "\" width=\"" + width + "\" height=\"" + height + "\" />");
          $uploadButton.prepend($imageElement);

          // mark the image as present.
          $uploadButton.addClass('present');

        }

      });
    });

  }

  function clearImageFromCloudinaryField(event) {

    // don't submit the form.
    event.preventDefault();

    // find a bunch of relevant elements.
    var $cloudinaryField = $(event.target).closest('.cloudinary-field');
    var $hiddenField = $cloudinaryField.find("input[type='hidden']");
    var $uploadButton = $cloudinaryField.find("button.upload");

    // clear the cloudinary id.
    $hiddenField.val(null);

    // remove any existing image from the button.
    $uploadButton.find('img').remove();

    // mark the image as *not* present.
    $uploadButton.removeClass('present');

  }

  $scope.find(".cloudinary-field button.upload").click(uploadImageForCloudinaryField);
  $scope.find(".cloudinary-field button.clear").click(clearImageFromCloudinaryField);
}

$(document).on('turbo:load', function() {
  enableCloudinaryImages($('body'));
})

$(document).on('sprinkles:update', function(event) {
  enableCloudinaryImages($(event.target));
})
