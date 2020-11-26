class RenameFromUserToFromMembership < ActiveRecord::Migration[6.0]
  def change
    rename_column :invitations, :from_user_id, :from_membership_id
  end
end
