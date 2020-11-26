class RemoveApiKeyFromUser < ActiveRecord::Migration[5.1]
  def change
    remove_column :users, :api_key, :string
    remove_column :users, :api_key_generated_at, :datetime
  end
end
