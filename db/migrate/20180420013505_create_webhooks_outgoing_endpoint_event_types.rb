class CreateWebhooksOutgoingEndpointEventTypes < ActiveRecord::Migration[5.2]
  def change
    create_table :webhooks_outgoing_endpoint_event_types do |t|
      t.integer :endpoint_id
      t.integer :event_type_id

      t.timestamps
    end
  end
end
