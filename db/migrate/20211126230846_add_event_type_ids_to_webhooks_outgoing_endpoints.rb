class AddEventTypeIdsToWebhooksOutgoingEndpoints < ActiveRecord::Migration[6.1]
  def change
    add_column :webhooks_outgoing_endpoints, :event_type_ids, :jsonb, default: []
  end
end
