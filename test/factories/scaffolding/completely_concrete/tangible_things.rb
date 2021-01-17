FactoryBot.define do
  factory :scaffolding_completely_concrete_tangible_thing, class: 'Scaffolding::CompletelyConcrete::TangibleThing' do
    association :absolutely_abstract_creative_concept, factory: :scaffolding_absolutely_abstract_creative_concept
    text_field_value { "MyString" }
    button_value { "one" }
    cloudinary_image_value { "MyString" }
    date_field_value { "2019-12-03" }
    email_field_value { "MyString" }
    password_field_value { "MyString" }
    phone_field_value { "MyString" }
    select_value { "two" }
    super_select_value { "three" }
    text_area_value { "MyText" }
    ckeditor_value { "MyText" }
    sort_order { 1 }
  end
end
