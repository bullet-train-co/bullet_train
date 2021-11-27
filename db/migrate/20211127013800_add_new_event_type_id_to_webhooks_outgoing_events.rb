class AddNewEventTypeIdToWebhooksOutgoingEvents < ActiveRecord::Migration[6.1]
  def change
    add_column :webhooks_outgoing_events, :event_type_id, :string
  end
end
