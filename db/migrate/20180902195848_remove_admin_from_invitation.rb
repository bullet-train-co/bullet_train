class RemoveAdminFromInvitation < ActiveRecord::Migration[5.2]
  def change
    remove_column :invitations, :admin, :boolean
  end
end
