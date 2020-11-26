class AddDeliveredAtToWebhooksOutgoingDeliveries < ActiveRecord::Migration[5.2]
  def change
    add_column :webhooks_outgoing_deliveries, :delivered_at, :datetime
  end
end
