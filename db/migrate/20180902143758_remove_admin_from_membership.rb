class RemoveAdminFromMembership < ActiveRecord::Migration[5.2]
  def change
    remove_column :memberships, :admin, :boolean
  end
end
