class CreateScaffoldingCompletelyConcreteTangibleThingsAssignments < ActiveRecord::Migration[5.2]
  def change
    create_table :scaffolding_completely_concrete_tangible_things_assignments do |t|
      t.references :tangible_thing, foreign_key: {to_table: "scaffolding_completely_concrete_tangible_things"}, index: {name: "index_tangible_things_assignments_on_tangible_thing_id"}
      t.references :membership, foreign_key: true, index: {name: "index_tangible_things_assignments_on_membership_id"}

      t.timestamps
    end
  end
end
