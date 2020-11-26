class AddFormerUserToUser < ActiveRecord::Migration[6.0]
  def change
    add_column :users, :former_user, :boolean, default: false
    User.update_all(former_user: false)
    change_column_null :users, :former_user, false, false
  end
end
