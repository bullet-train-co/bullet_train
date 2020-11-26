module ImagesHelper
  def image_width_for_height(filename, target_height)
    source_width, source_height = FastImage.size("#{Rails.root}/app/assets/images/#{filename}")
    ratio = source_width.to_f / source_height.to_f
    (target_height * ratio).to_i
  end
end
