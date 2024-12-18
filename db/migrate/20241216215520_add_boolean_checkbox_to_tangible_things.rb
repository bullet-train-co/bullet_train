class AddBooleanCheckboxToTangibleThings < ActiveRecord::Migration[7.2]
  def change
    add_column :scaffolding_completely_concrete_tangible_things, :boolean_checkbox_value, :boolean
  end
end
