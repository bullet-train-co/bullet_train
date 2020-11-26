class CreateWebhooksOutgoingDeliveryAttempts < ActiveRecord::Migration[5.2]
  def change
    create_table :webhooks_outgoing_delivery_attempts do |t|
      t.integer :delivery_id
      t.integer :response_code
      t.text :response_body

      t.timestamps
    end
  end
end
