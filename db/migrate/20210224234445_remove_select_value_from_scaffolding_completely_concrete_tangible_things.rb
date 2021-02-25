class RemoveSelectValueFromScaffoldingCompletelyConcreteTangibleThings < ActiveRecord::Migration[6.1]
  def change
    remove_column :scaffolding_completely_concrete_tangible_things, :select_value, :string
  end
end
