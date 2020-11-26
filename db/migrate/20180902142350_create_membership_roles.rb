class CreateMembershipRoles < ActiveRecord::Migration[5.2]
  def change
    create_table :membership_roles do |t|
      t.belongs_to :membership, foreign_key: true
      t.belongs_to :role, foreign_key: true

      t.timestamps
    end
  end
end
