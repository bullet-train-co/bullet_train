class DropMembershipsReassignmentsAssignments < ActiveRecord::Migration[7.0]
  def change
    drop_table :memberships_reassignments_assignments
    drop_table :memberships_reassignments_scaffolding_completely_concrete_tangi
  end
end
