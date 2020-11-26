class AddSortOrderToScaffoldingCompletelyConcreteTangibleThings < ActiveRecord::Migration[6.0]
  def change
    add_column :scaffolding_completely_concrete_tangible_things, :sort_order, :integer
  end
end
