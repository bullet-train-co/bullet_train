class AddUuidToWebhooksOutgoingEvents < ActiveRecord::Migration[5.2]
  def change
    add_column :webhooks_outgoing_events, :uuid, :string
  end
end
