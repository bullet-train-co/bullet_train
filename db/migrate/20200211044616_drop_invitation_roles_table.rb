class DropInvitationRolesTable < ActiveRecord::Migration[6.0]
  def change
    drop_table :invitation_roles do |t|
      t.references :invitation, foreign_key: true
      t.references :role, foreign_key: true

      t.timestamps
    end
  end
end
