class AddApiKeyToUser < ActiveRecord::Migration[5.0]
  def change
    add_column :users, :api_key, :string
    add_column :users, :api_key_generated_at, :datetime
  end
end
