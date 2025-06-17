class AddIndexForWebhooksOutgoingDeliveries < ActiveRecord::Migration[8.0]
  disable_ddl_transaction!

  def change
    add_index :webhooks_outgoing_deliveries, [:endpoint_id, :event_id], algorithm: :concurrently
  end
end
