class AddInvitationListToInvitations < ActiveRecord::Migration[7.0]
  def change
    add_reference :invitations, :invitation_list, null: true, foreign_key: {to_table: :account_onboarding_invitation_lists}
  end
end
