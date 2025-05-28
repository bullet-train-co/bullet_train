class AddIndexForWebhooksOutgoingDeliveries < ActiveRecord::Migration[8.0]
  def change
    add_index :webhooks_outgoing_deliveries, [:endpoint_id, :event_id]
    add_index :webhooks_outgoing_deliveries, [:delivered_at]
  end
end
