class AddApiVersionToWebhooksOutgoingEvents < ActiveRecord::Migration[7.0]
  def change
    add_column :webhooks_outgoing_events, :api_version, :integer, null: false, default: 1
  end
end
