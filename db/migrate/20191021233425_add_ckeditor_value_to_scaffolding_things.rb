class AddCkeditorValueToScaffoldingThings < ActiveRecord::Migration[6.0]
  def change
    add_column :scaffolding_things, :ckeditor_value, :text
  end
end
