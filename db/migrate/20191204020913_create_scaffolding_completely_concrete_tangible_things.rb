class CreateScaffoldingCompletelyConcreteTangibleThings < ActiveRecord::Migration[6.0]
  def change
    create_table :scaffolding_completely_concrete_tangible_things do |t|
      t.references :absolutely_abstract_creative_concept, null: false, foreign_key: {to_table: "scaffolding_absolutely_abstract_creative_concepts"}, index: {name: "index_tangible_things_on_creative_concept_id"}
      t.string :text_field_value
      t.string :button_value
      t.string :cloudinary_image_value
      t.date :date_field_value
      t.string :email_field_value
      t.string :password_field_value
      t.string :phone_field_value
      t.string :select_value
      t.string :super_select_value
      t.text :text_area_value
      t.text :trix_editor_value
      t.text :ckeditor_value

      t.timestamps
    end
  end
end
