class AddOptionFieldsToScaffoldingCompletelyConcreteTangibleThings < ActiveRecord::Migration[6.1]
  def change
    add_column :scaffolding_completely_concrete_tangible_things, :option_value, :string
    add_column :scaffolding_completely_concrete_tangible_things, :multiple_option_values, :jsonb, default: []
  end
end
