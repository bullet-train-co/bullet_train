class MigrateApiKeys < ActiveRecord::Migration[6.1]
  def up
    ApiKey.find_each do |api_key|
      supplied_secret = api_key.secret
      api_key.generate_encrypted_secret(supplied_secret)

      unless ApiKey.find_by_credentials(api_key.token, api_key.secret).id == api_key.id
        raise "we generated an encrypted hash that doesn't continue to authenticate with the same token and secret keys."
      end
    end
  end

  def down
    raise ActiveRecord::IrreversibleMigration
  end
end
