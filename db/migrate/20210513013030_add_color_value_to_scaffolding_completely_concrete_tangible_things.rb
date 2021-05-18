class AddColorValueToScaffoldingCompletelyConcreteTangibleThings < ActiveRecord::Migration[6.1]
  def change
    add_column :scaffolding_completely_concrete_tangible_things, :color_picker_value, :string
  end
end
