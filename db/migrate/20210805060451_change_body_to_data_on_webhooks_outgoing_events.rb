class ChangeBodyToDataOnWebhooksOutgoingEvents < ActiveRecord::Migration[6.1]
  def change
    rename_column :webhooks_outgoing_events, :body, :data
  end
end
