# This is to render previews for video attachments in Action Text
# Source: https://mileswoodroffe.com/articles/action-text-video-support
Rails.application.config.after_initialize do
  default_allowed_attributes = Rails::HTML5::Sanitizer.safe_list_sanitizer.allowed_attributes + ActionText::Attachment::ATTRIBUTES.to_set
  custom_allowed_attributes = Set.new(%w[controls])
  ActionText::ContentHelper.allowed_attributes = (default_allowed_attributes + custom_allowed_attributes).freeze

  default_allowed_tags = Rails::HTML5::Sanitizer.safe_list_sanitizer.allowed_tags + Set.new([ ActionText::Attachment.tag_name, "figure", "figcaption" ])
  custom_allowed_tags = Set.new(%w[audio video source])
  ActionText::ContentHelper.allowed_tags = (default_allowed_tags + custom_allowed_tags).freeze
end