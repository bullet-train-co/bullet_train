class AddInvitationToMembership < ActiveRecord::Migration[6.0]
  def change
    add_reference :memberships, :invitation, null: true, foreign_key: true
  end
end
