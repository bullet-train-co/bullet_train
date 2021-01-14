# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2021_01_14_200646) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "action_mailbox_inbound_emails", force: :cascade do |t|
    t.integer "status", default: 0, null: false
    t.string "message_id", null: false
    t.string "message_checksum", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["message_id", "message_checksum"], name: "index_action_mailbox_inbound_emails_uniqueness", unique: true
  end

  create_table "action_text_rich_texts", force: :cascade do |t|
    t.string "name", null: false
    t.text "body"
    t.string "record_type", null: false
    t.bigint "record_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["record_type", "record_id", "name"], name: "index_action_text_rich_texts_uniqueness", unique: true
  end

  create_table "active_storage_attachments", force: :cascade do |t|
    t.string "name", null: false
    t.string "record_type", null: false
    t.bigint "record_id", null: false
    t.bigint "blob_id", null: false
    t.datetime "created_at", null: false
    t.index ["blob_id"], name: "index_active_storage_attachments_on_blob_id"
    t.index ["record_type", "record_id", "name", "blob_id"], name: "index_active_storage_attachments_uniqueness", unique: true
  end

  create_table "active_storage_blobs", force: :cascade do |t|
    t.string "key", null: false
    t.string "filename", null: false
    t.string "content_type"
    t.text "metadata"
    t.bigint "byte_size", null: false
    t.string "checksum", null: false
    t.datetime "created_at", null: false
    t.string "service_name", null: false
    t.index ["key"], name: "index_active_storage_blobs_on_key", unique: true
  end

  create_table "active_storage_variant_records", force: :cascade do |t|
    t.bigint "blob_id", null: false
    t.string "variation_digest", null: false
    t.index ["blob_id", "variation_digest"], name: "index_active_storage_variant_records_uniqueness", unique: true
  end

  create_table "api_keys", force: :cascade do |t|
    t.bigint "user_id"
    t.string "token"
    t.string "secret"
    t.datetime "last_used_at"
    t.datetime "revoked_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_api_keys_on_user_id"
  end

  create_table "conversations", force: :cascade do |t|
    t.bigint "team_id"
    t.bigint "kanban_card_id"
    t.datetime "last_message_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "last_message_id"
    t.index ["kanban_card_id"], name: "index_conversations_on_kanban_card_id"
    t.index ["last_message_id"], name: "index_conversations_on_last_message_id"
    t.index ["team_id"], name: "index_conversations_on_team_id"
  end

  create_table "conversations_messages", force: :cascade do |t|
    t.bigint "conversation_id"
    t.bigint "message_id"
    t.bigint "membership_id"
    t.bigint "user_id"
    t.string "author_name"
    t.text "body"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["conversation_id"], name: "index_conversations_messages_on_conversation_id"
    t.index ["membership_id"], name: "index_conversations_messages_on_membership_id"
    t.index ["message_id"], name: "index_conversations_messages_on_message_id"
    t.index ["user_id"], name: "index_conversations_messages_on_user_id"
  end

  create_table "conversations_read_receipts", force: :cascade do |t|
    t.bigint "conversation_id"
    t.datetime "last_read_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "membership_id", null: false
    t.index ["conversation_id"], name: "index_conversations_read_receipts_on_conversation_id"
    t.index ["membership_id"], name: "index_conversations_read_receipts_on_membership_id"
  end

  create_table "conversations_subscriptions", force: :cascade do |t|
    t.bigint "conversation_id"
    t.datetime "unsubscribed_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "last_read_at"
    t.string "uuid"
    t.bigint "membership_id", null: false
    t.index ["conversation_id"], name: "index_conversations_subscriptions_on_conversation_id"
    t.index ["membership_id"], name: "index_conversations_subscriptions_on_membership_id"
  end

  create_table "coupons", id: :serial, force: :cascade do |t|
    t.string "code"
    t.string "free_trial_length"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "imports_csv_imports", force: :cascade do |t|
    t.string "type"
    t.bigint "team_id"
    t.integer "lines_count"
    t.integer "processed_count", default: 0
    t.integer "rejected_count", default: 0
    t.text "logging_output", default: ""
    t.text "error_message"
    t.text "rejected_lines", default: ""
    t.datetime "started_at"
    t.datetime "estimated_finish_at"
    t.datetime "completed_at"
    t.datetime "failed_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["team_id"], name: "index_imports_csv_imports_on_team_id"
  end

  create_table "invitations", id: :serial, force: :cascade do |t|
    t.string "email"
    t.string "uuid"
    t.integer "from_membership_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "team_id"
    t.index ["team_id"], name: "index_invitations_on_team_id"
  end

  create_table "kanban_assignments", force: :cascade do |t|
    t.bigint "card_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "membership_id"
    t.index ["card_id"], name: "index_kanban_assignments_on_card_id"
    t.index ["membership_id"], name: "index_kanban_assignments_on_membership_id"
  end

  create_table "kanban_boards", force: :cascade do |t|
    t.bigint "team_id"
    t.string "name"
    t.text "description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "card_columns_updated_timestamp"
    t.index ["team_id"], name: "index_kanban_boards_on_team_id"
  end

  create_table "kanban_card_tags", force: :cascade do |t|
    t.bigint "card_id"
    t.bigint "tag_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["card_id"], name: "index_kanban_card_tags_on_card_id"
    t.index ["tag_id"], name: "index_kanban_card_tags_on_tag_id"
  end

  create_table "kanban_cards", force: :cascade do |t|
    t.bigint "column_id"
    t.string "name"
    t.text "description"
    t.integer "sort_order"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["column_id"], name: "index_kanban_cards_on_column_id"
  end

  create_table "kanban_columns", force: :cascade do |t|
    t.bigint "board_id"
    t.string "name"
    t.integer "sort_order"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["board_id"], name: "index_kanban_columns_on_board_id"
  end

  create_table "kanban_tags", force: :cascade do |t|
    t.bigint "board_id"
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "color"
    t.index ["board_id"], name: "index_kanban_tags_on_board_id"
  end

  create_table "membership_roles", force: :cascade do |t|
    t.bigint "membership_id"
    t.bigint "role_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["membership_id"], name: "index_membership_roles_on_membership_id"
    t.index ["role_id"], name: "index_membership_roles_on_role_id"
  end

  create_table "memberships", id: :serial, force: :cascade do |t|
    t.integer "user_id"
    t.integer "team_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "invitation_id"
    t.string "user_first_name"
    t.string "user_last_name"
    t.string "user_profile_photo_id"
    t.string "user_email"
    t.bigint "added_by_id"
    t.index ["added_by_id"], name: "index_memberships_on_added_by_id"
    t.index ["invitation_id"], name: "index_memberships_on_invitation_id"
    t.index ["team_id"], name: "index_memberships_on_team_id"
    t.index ["user_id"], name: "index_memberships_on_user_id"
  end

  create_table "memberships_reassignments_assignments", force: :cascade do |t|
    t.bigint "membership_id", null: false
    t.bigint "scaffolding_completely_concrete_tangible_things_reassignments_i"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["membership_id"], name: "index_memberships_reassignments_assignments_on_membership_id"
    t.index ["scaffolding_completely_concrete_tangible_things_reassignments_i"], name: "index_assignments_on_tangible_things_reassignment_id"
  end

  create_table "memberships_reassignments_kanban_cards_reassignments", force: :cascade do |t|
    t.bigint "membership_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["membership_id"], name: "index_kanban_cards_reassignments_on_membership_id"
  end

  create_table "memberships_reassignments_scaffolding_completely_concrete_tangi", force: :cascade do |t|
    t.bigint "membership_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["membership_id"], name: "index_tangible_things_reassignments_on_membership_id"
  end

  create_table "oauth_facebook_accounts", force: :cascade do |t|
    t.string "uid"
    t.jsonb "data"
    t.bigint "team_id"
    t.bigint "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["team_id"], name: "index_oauth_facebook_accounts_on_team_id"
    t.index ["user_id"], name: "index_oauth_facebook_accounts_on_user_id"
  end

  create_table "oauth_stripe_accounts", force: :cascade do |t|
    t.string "uid"
    t.jsonb "data"
    t.bigint "team_id"
    t.bigint "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["team_id"], name: "index_oauth_stripe_accounts_on_team_id"
    t.index ["user_id"], name: "index_oauth_stripe_accounts_on_user_id"
  end

  create_table "oauth_twitter_accounts", force: :cascade do |t|
    t.string "uid"
    t.jsonb "data"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "team_id"
    t.integer "user_id"
    t.index ["team_id"], name: "index_oauth_twitter_accounts_on_team_id"
  end

  create_table "plan_categories", force: :cascade do |t|
    t.string "name"
    t.string "key"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "default"
    t.integer "display_order"
  end

  create_table "plans", id: :serial, force: :cascade do |t|
    t.string "name"
    t.string "stripe_id"
    t.float "price"
    t.string "interval"
    t.text "features"
    t.boolean "highlight"
    t.integer "display_order"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "currency"
    t.bigint "plan_category_id"
    t.string "image_name", default: "hobby.png"
    t.string "key"
    t.index ["plan_category_id"], name: "index_plans_on_plan_category_id"
  end

  create_table "roles", force: :cascade do |t|
    t.string "key"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "display_order", default: 0
  end

  create_table "scaffolding_absolutely_abstract_creative_concepts", force: :cascade do |t|
    t.bigint "team_id", null: false
    t.string "name"
    t.text "description"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["team_id"], name: "index_absolutely_abstract_creative_concepts_on_team_id"
  end

  create_table "scaffolding_absolutely_abstract_creative_concepts_collaborators", force: :cascade do |t|
    t.bigint "creative_concept_id", null: false
    t.bigint "membership_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.jsonb "roles", default: []
    t.index ["creative_concept_id"], name: "index_creative_concepts_collaborators_on_creative_concept_id"
    t.index ["membership_id"], name: "index_creative_concepts_collaborators_on_membership_id"
  end

  create_table "scaffolding_completely_concrete_tangible_things", force: :cascade do |t|
    t.bigint "absolutely_abstract_creative_concept_id", null: false
    t.string "text_field_value"
    t.string "button_value"
    t.string "cloudinary_image_value"
    t.date "date_field_value"
    t.string "email_field_value"
    t.string "password_field_value"
    t.string "phone_field_value"
    t.string "select_value"
    t.string "super_select_value"
    t.text "text_area_value"
    t.text "ckeditor_value"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.integer "sort_order"
    t.index ["absolutely_abstract_creative_concept_id"], name: "index_tangible_things_on_creative_concept_id"
  end

  create_table "scaffolding_completely_concrete_tangible_things_assignments", force: :cascade do |t|
    t.bigint "tangible_thing_id"
    t.bigint "membership_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["membership_id"], name: "index_tangible_things_assignments_on_membership_id"
    t.index ["tangible_thing_id"], name: "index_tangible_things_assignments_on_tangible_thing_id"
  end

  create_table "subscriptions", id: :serial, force: :cascade do |t|
    t.string "stripe_id"
    t.integer "plan_id"
    t.string "last_four"
    t.integer "coupon_id"
    t.string "card_type"
    t.float "current_price"
    t.integer "team_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "link_mink_id"
    t.string "rewardful_id"
    t.string "stripe_subscription_id"
    t.string "stripe_status"
    t.string "stripe_last_payment_status"
  end

  create_table "subscriptions_invoices", force: :cascade do |t|
    t.bigint "subscription_id", null: false
    t.string "stripe_id"
    t.jsonb "stripe_data"
    t.datetime "stripe_created_at"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["subscription_id"], name: "index_subscriptions_invoices_on_subscription_id"
  end

  create_table "teams", id: :serial, force: :cascade do |t|
    t.string "name"
    t.string "slug"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "being_destroyed"
  end

  create_table "users", id: :serial, force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer "sign_in_count", default: 0, null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.inet "current_sign_in_ip"
    t.inet "last_sign_in_ip"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "current_team_id"
    t.string "first_name"
    t.string "last_name"
    t.string "time_zone"
    t.datetime "last_seen_at"
    t.string "profile_photo_id"
    t.jsonb "ability_cache"
    t.datetime "last_notification_email_sent_at"
    t.boolean "former_user", default: false, null: false
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  create_table "versions", id: :serial, force: :cascade do |t|
    t.string "item_type", null: false
    t.integer "item_id", null: false
    t.string "event", null: false
    t.string "whodunnit"
    t.text "object"
    t.datetime "created_at"
    t.index ["item_type", "item_id"], name: "index_versions_on_item_type_and_item_id"
  end

  create_table "webhooks_incoming_bullet_train_webhooks", force: :cascade do |t|
    t.jsonb "data"
    t.datetime "processed_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "verified_at"
  end

  create_table "webhooks_incoming_oauth_stripe_account_webhooks", force: :cascade do |t|
    t.jsonb "data"
    t.datetime "processed_at"
    t.datetime "verified_at"
    t.bigint "oauth_stripe_account_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["oauth_stripe_account_id"], name: "index_stripe_webhooks_on_stripe_account_id"
  end

  create_table "webhooks_incoming_stripe_webhooks", force: :cascade do |t|
    t.jsonb "data"
    t.datetime "processed_at"
    t.datetime "verified_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "webhooks_outgoing_deliveries", force: :cascade do |t|
    t.integer "endpoint_id"
    t.integer "event_id"
    t.text "endpoint_url"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "delivered_at"
  end

  create_table "webhooks_outgoing_delivery_attempts", force: :cascade do |t|
    t.integer "delivery_id"
    t.integer "response_code"
    t.text "response_body"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.text "response_message"
    t.text "error_message"
    t.integer "attempt_number"
  end

  create_table "webhooks_outgoing_endpoint_event_types", force: :cascade do |t|
    t.integer "endpoint_id"
    t.integer "event_type_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "webhooks_outgoing_endpoints", force: :cascade do |t|
    t.bigint "team_id"
    t.text "url"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "name"
    t.index ["team_id"], name: "index_webhooks_outgoing_endpoints_on_team_id"
  end

  create_table "webhooks_outgoing_event_types", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "webhooks_outgoing_events", force: :cascade do |t|
    t.integer "event_type_id"
    t.integer "subject_id"
    t.string "subject_type"
    t.jsonb "body"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "team_id"
    t.string "uuid"
    t.jsonb "payload"
    t.index ["team_id"], name: "index_webhooks_outgoing_events_on_team_id"
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "active_storage_variant_records", "active_storage_blobs", column: "blob_id"
  add_foreign_key "api_keys", "users"
  add_foreign_key "conversations", "conversations_messages", column: "last_message_id"
  add_foreign_key "conversations", "kanban_cards"
  add_foreign_key "conversations", "teams"
  add_foreign_key "conversations_messages", "conversations"
  add_foreign_key "conversations_messages", "conversations_messages", column: "message_id"
  add_foreign_key "conversations_messages", "memberships"
  add_foreign_key "conversations_messages", "users"
  add_foreign_key "conversations_read_receipts", "conversations"
  add_foreign_key "conversations_read_receipts", "memberships"
  add_foreign_key "conversations_subscriptions", "conversations"
  add_foreign_key "conversations_subscriptions", "memberships"
  add_foreign_key "imports_csv_imports", "teams"
  add_foreign_key "invitations", "teams"
  add_foreign_key "kanban_assignments", "kanban_cards", column: "card_id"
  add_foreign_key "kanban_assignments", "memberships"
  add_foreign_key "kanban_boards", "teams"
  add_foreign_key "kanban_card_tags", "kanban_cards", column: "card_id"
  add_foreign_key "kanban_card_tags", "kanban_tags", column: "tag_id"
  add_foreign_key "kanban_cards", "kanban_columns", column: "column_id"
  add_foreign_key "kanban_columns", "kanban_boards", column: "board_id"
  add_foreign_key "kanban_tags", "kanban_boards", column: "board_id"
  add_foreign_key "membership_roles", "memberships"
  add_foreign_key "membership_roles", "roles"
  add_foreign_key "memberships", "invitations"
  add_foreign_key "memberships", "memberships", column: "added_by_id"
  add_foreign_key "memberships", "teams"
  add_foreign_key "memberships", "users"
  add_foreign_key "memberships_reassignments_assignments", "memberships"
  add_foreign_key "memberships_reassignments_assignments", "memberships_reassignments_scaffolding_completely_concrete_tangi", column: "scaffolding_completely_concrete_tangible_things_reassignments_i"
  add_foreign_key "memberships_reassignments_kanban_cards_reassignments", "memberships"
  add_foreign_key "memberships_reassignments_scaffolding_completely_concrete_tangi", "memberships"
  add_foreign_key "oauth_facebook_accounts", "teams"
  add_foreign_key "oauth_facebook_accounts", "users"
  add_foreign_key "oauth_stripe_accounts", "teams"
  add_foreign_key "oauth_stripe_accounts", "users"
  add_foreign_key "oauth_twitter_accounts", "teams"
  add_foreign_key "plans", "plan_categories"
  add_foreign_key "scaffolding_absolutely_abstract_creative_concepts", "teams"
  add_foreign_key "scaffolding_absolutely_abstract_creative_concepts_collaborators", "memberships"
  add_foreign_key "scaffolding_absolutely_abstract_creative_concepts_collaborators", "scaffolding_absolutely_abstract_creative_concepts", column: "creative_concept_id"
  add_foreign_key "scaffolding_completely_concrete_tangible_things", "scaffolding_absolutely_abstract_creative_concepts", column: "absolutely_abstract_creative_concept_id"
  add_foreign_key "scaffolding_completely_concrete_tangible_things_assignments", "memberships"
  add_foreign_key "scaffolding_completely_concrete_tangible_things_assignments", "scaffolding_completely_concrete_tangible_things", column: "tangible_thing_id"
  add_foreign_key "subscriptions_invoices", "subscriptions"
  add_foreign_key "webhooks_outgoing_endpoints", "teams"
  add_foreign_key "webhooks_outgoing_events", "teams"
end
