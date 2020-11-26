class CreateWebhooksOutgoingDeliveries < ActiveRecord::Migration[5.2]
  def change
    create_table :webhooks_outgoing_deliveries do |t|
      t.integer :endpoint_id
      t.integer :event_id
      t.text :endpoint_url

      t.timestamps
    end
  end
end
