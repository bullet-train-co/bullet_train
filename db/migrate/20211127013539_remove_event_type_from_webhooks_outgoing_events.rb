class RemoveEventTypeFromWebhooksOutgoingEvents < ActiveRecord::Migration[6.1]
  def change
    remove_reference :webhooks_outgoing_events, :event_type, null: false, foreign_key: false
  end
end
