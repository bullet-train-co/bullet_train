class CreateMembershipsReassignmentsScaffoldingCompletelyConcreteTangibleThingsReassignments < ActiveRecord::Migration[6.0]
  def change
    create_table :memberships_reassignments_scaffolding_completely_concrete_tangible_things_reassignments do |t|
      t.references :membership, null: false, foreign_key: true, index: {name: "index_tangible_things_reassignments_on_membership_id"}

      t.timestamps
    end
  end
end
