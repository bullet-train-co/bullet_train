class CreateInvitations < ActiveRecord::Migration[5.0]
  def change
    create_table :invitations do |t|
      t.string :email
      t.string :uuid
      t.integer :from_user_id

      t.timestamps
    end
  end
end
