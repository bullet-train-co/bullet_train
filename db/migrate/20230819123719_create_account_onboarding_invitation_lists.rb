class CreateAccountOnboardingInvitationLists < ActiveRecord::Migration[7.0]
  def change
    create_table :account_onboarding_invitation_lists do |t|
      t.references :team, null: false, foreign_key: true
      t.jsonb :invitations

      t.timestamps
    end
  end
end
