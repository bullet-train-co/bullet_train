class CreateInvitationRoles < ActiveRecord::Migration[5.2]
  def change
    create_table :invitation_roles do |t|
      t.references :invitation, foreign_key: true
      t.references :role, foreign_key: true

      t.timestamps
    end
  end
end
