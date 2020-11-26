class AddFormerUserFieldsToMembership < ActiveRecord::Migration[6.0]
  def change
    add_column :memberships, :user_first_name, :string
    add_column :memberships, :user_last_name, :string
    add_column :memberships, :user_profile_photo_id, :string
    add_column :memberships, :user_email, :string
  end
end
