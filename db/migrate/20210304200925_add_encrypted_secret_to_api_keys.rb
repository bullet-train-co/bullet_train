class AddEncryptedSecretToApiKeys < ActiveRecord::Migration[6.1]
  def change
    add_column :api_keys, :encrypted_secret, :string
  end
end
