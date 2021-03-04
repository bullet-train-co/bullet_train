class RemoveSecretFromApiKeys < ActiveRecord::Migration[6.1]
  def change
    remove_column :api_keys, :secret, :string
  end
end
