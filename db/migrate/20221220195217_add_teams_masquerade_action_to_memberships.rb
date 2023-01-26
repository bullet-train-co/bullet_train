class AddTeamsMasqueradeActionToMemberships < ActiveRecord::Migration[7.0]
  def change
    add_reference :memberships, :teams_masquerade_action, null: true, foreign_key: true
  end
end
