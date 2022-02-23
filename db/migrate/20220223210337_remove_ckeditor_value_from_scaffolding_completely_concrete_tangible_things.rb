class RemoveCkeditorValueFromScaffoldingCompletelyConcreteTangibleThings < ActiveRecord::Migration[7.0]
  def change
    remove_column :scaffolding_completely_concrete_tangible_things, :ckeditor_value, :text
  end
end
