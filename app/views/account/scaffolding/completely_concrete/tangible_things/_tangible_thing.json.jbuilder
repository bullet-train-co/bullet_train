json.extract! tangible_thing,
  :id,
  :absolutely_abstract_creative_concept_id,
  # 🚅 skip this section when scaffolding.
  :text_field_value,
  :button_value,
  :color_picker_value,
  :cloudinary_image_value,
  :date_field_value,
  :email_field_value,
  :password_field_value,
  :phone_field_value,
  :option_value,
  :multiple_option_values,
  :super_select_value,
  :text_area_value,
  :action_text_value,
  :ckeditor_value,
  # 🚅 stop any skipping we're doing now.
  # 🚅 super scaffolding will insert new fields above this line.
  :created_at,
  :updated_at
json.url account_scaffolding_completely_concrete_tangible_thing_url(tangible_thing, format: :json)
