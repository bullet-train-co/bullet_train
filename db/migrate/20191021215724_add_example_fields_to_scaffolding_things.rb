class AddExampleFieldsToScaffoldingThings < ActiveRecord::Migration[6.0]
  def change
    add_column :scaffolding_things, :button_value, :string
    add_column :scaffolding_things, :cloudinary_image_value, :string
    add_column :scaffolding_things, :date_field_value, :date
    add_column :scaffolding_things, :email_field_value, :string
    add_column :scaffolding_things, :password_field_value, :string
    add_column :scaffolding_things, :phone_field_value, :string
    add_column :scaffolding_things, :select_value, :string
    add_column :scaffolding_things, :super_select_value, :string
    add_column :scaffolding_things, :text_area_value, :text
    add_column :scaffolding_things, :trix_editor_value, :text
  end
end
