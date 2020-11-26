module Fields::CloudinaryImageHelper
  def cloudinary_image_tag(cloudinary_id, image_tag_options = {}, cloudinary_image_options = {})
    return nil unless cloudinary_id.present?

    if image_tag_options[:width]
      cloudinary_image_options[:width] ||= image_tag_options[:width] * 2
    end

    if image_tag_options[:height]
      cloudinary_image_options[:height] ||= image_tag_options[:height] * 2
    end

    cloudinary_image_options[:crop] ||= :fill

    image_tag cl_image_path(cloudinary_id, cloudinary_image_options), image_tag_options
  end
end
