class AddTeamToInvitation < ActiveRecord::Migration[5.0]
  def change
    add_reference :invitations, :team, foreign_key: true
  end
end
