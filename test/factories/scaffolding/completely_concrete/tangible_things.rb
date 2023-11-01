FactoryBot.define do
  factory :scaffolding_completely_concrete_tangible_thing, class: "Scaffolding::CompletelyConcrete::TangibleThing" do
    association :absolutely_abstract_creative_concept, factory: :scaffolding_absolutely_abstract_creative_concept
    text_field_value { "MyString" }
    button_value { "one" }
    cloudinary_image_value { "MyString" }
    date_field_value { "2019-12-03" }
    date_and_time_field_value { "2021-11-05" }
    email_field_value { "MyString" }
    password_field_value { "MyString" }
    phone_field_value { "MyString" }
    super_select_value { "three" }
    text_area_value { "MyText" }
    action_text_value { "MyText" }
    sort_order { 1 }

    factory :scaffolding_completely_concrete_tangible_thing_example do
      id { 42 }
      absolutely_abstract_creative_concept_id { 42 }
      text_field_value { "Example" }
      created_at { DateTime.new(2023, 1, 1) }
      updated_at { DateTime.new(2023, 1, 2) }
    end
  end
end
