class AddBooleanToTangibleThings < ActiveRecord::Migration[6.1]
  def change
    add_column :scaffolding_completely_concrete_tangible_things, :boolean_button_value, :boolean
  end
end
