class CreateMembershipsReassignmentsAssignments < ActiveRecord::Migration[6.0]
  def change
    create_table :memberships_reassignments_assignments do |t|
      t.references :membership, null: false, foreign_key: true
      t.references :scaffolding_completely_concrete_tangible_things_reassignments, null: true, foreign_key: {to_table: "memberships_reassignments_scaffolding_completely_concrete_tangible_things_reassignments"}, index: {name: "index_assignments_on_tangible_things_reassignment_id"}

      t.timestamps
    end
  end
end
