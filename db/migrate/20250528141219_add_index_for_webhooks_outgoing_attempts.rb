class AddIndexForWebhooksOutgoingAttempts < ActiveRecord::Migration[8.0]
  disable_ddl_transaction!

  def change
    add_index :webhooks_outgoing_delivery_attempts, :delivery_id, algorithm: :concurrently
  end
end
