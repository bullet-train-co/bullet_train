class CreateApiKeys < ActiveRecord::Migration[5.1]
  def change
    create_table :api_keys do |t|
      t.references :user, foreign_key: true
      t.string :token
      t.string :secret
      t.datetime :last_used_at
      t.datetime :revoked_at

      t.timestamps
    end
  end
end
