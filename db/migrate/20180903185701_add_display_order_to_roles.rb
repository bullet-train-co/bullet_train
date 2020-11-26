class AddDisplayOrderToRoles < ActiveRecord::Migration[5.2]
  def change
    add_column :roles, :display_order, :integer, default: 0
  end
end
