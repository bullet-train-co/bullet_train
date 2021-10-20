class DropApiKeys < ActiveRecord::Migration[6.1]
  def change
    drop_table "api_keys", force: :cascade do |t|
      t.bigint "user_id"
      t.string "token"
      t.datetime "last_used_at"
      t.datetime "revoked_at"
      t.datetime "created_at", null: false
      t.datetime "updated_at", null: false
      t.string "encrypted_secret"
      t.index ["user_id"], name: "index_api_keys_on_user_id"
    end
  end
end
