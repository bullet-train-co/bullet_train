module EmailHelper
  def email_image_tag(image, **options)
    image_underscore = image.tr("-", "_")
    attachments.inline[image_underscore] = File.read(Rails.root.join("app/javascript/images/#{image}"))
    image_tag attachments.inline[image_underscore].url, **options
  end
end
