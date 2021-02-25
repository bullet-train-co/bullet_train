import { Controller } from "stimulus"

export default class extends Controller {
  static targets = [ "uploadButton", "hiddenField", "thumbnail" ]
  static values = { 
    signaturesUrl: String,
    height: Number,
    width: Number,
    cloudName: String,
    apiKey: String,
    googleApiKey: String,
    urlFormat: String,
    sources: String,
    searchByRights: Boolean
  }
  static classes = [ "thumbnailShown" ]

  pickImageAndUpload(event) {
    // don't submit the form.
    event.preventDefault()

    // prepare the list of default sources a user can upload an image from.
    var defaultSources = ['local', 'url', 'camera']
    if (this.hasGoogleApiKeyValue) {
      defaultSources.push('image_search')
    }

    // configure cloudinary's uploader's options.
    // many of these are configurable at the point where the `shared/fields/cloudinary_image` partial is included.
    var options = {
      cloud_name: this.cloudNameValue,
      apiKey: this.apiKeyValue,
      upload_preset: this.uploadPresetValue,
      upload_signature: this.getCloudinarySignature.bind(this),
      multiple: false,
      sources: this.hasSourcesValue ? this.sourcesValue.split(',') : defaultSources,
      search_by_rights: this.hasSearchByRightsValue && this.searchByRightsValue === false ? false : true // default to true.
    }
    
    if (this.hasGoogleApiKeyValue) {
      options['google_api_key'] = this.googleApiKeyValue
    }
    
    // open cloudinary's upload widget.
    cloudinary.openUploadWidget(options, this.handleWidgetResponse.bind(this))
  }
  
  clearImage(event) {
    // don't submit the form.
    event.preventDefault()

    // clear the cloudinary id.
    this.hiddenFieldTarget.value = null
    
    // remove any existing image from the button.
    this.removeThumbnail()
  }
  
  getCloudinarySignature(callback, paramsToSign) {
    $.ajax({
      url: this.signaturesUrlValue,
      type: "GET",
      dataType: "text",
      data: {data: paramsToSign},
      complete: function() { console.log("complete") },
      success: function(signature, textStatus, xhr) { callback(signature) },
      error: function(xhr, status, error) { console.log(xhr, status, error) }
    })
  }
  
  handleWidgetResponse(error, response) {
    // after the user has successfully uploaded a single file ..
    if (!error && response && response.event === "success") { 
      const data = response.info
      
      // update the cloudinary id field in the form.
      this.hiddenFieldTarget.value = data.public_id

      // remove any existing image.
      this.removeThumbnail()

      // generate a new image preview url.
      this.addThumbnail(this.urlFormatValue.replace('CLOUDINARY_ID', data.public_id))
    }
  }
  
  addThumbnail(url) {
    var $imageElement = $(`<img src="${url}" width="${this.widthValue}" height="${this.heightValue}" data-${this.identifier}-target="thumbnail" />`)
    $(this.uploadButtonTarget).prepend($imageElement)

    // mark the image as present.
    this.uploadButtonTarget.classList.add(this.thumbnailShownClass)
  }
  
  removeThumbnail() {
    if (!this.hasThumbnailTarget) { return }
    this.uploadButtonTarget.removeChild(this.thumbnailTarget)
    this.uploadButtonTarget.classList.remove(this.thumbnailShownClass)
  }
}
