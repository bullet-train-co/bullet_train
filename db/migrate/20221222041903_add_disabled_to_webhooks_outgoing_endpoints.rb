class AddDisabledToWebhooksOutgoingEndpoints < ActiveRecord::Migration[7.0]
  def change
    add_column :webhooks_outgoing_endpoints, :disabled_from_failure, :boolean, null: false, default: false
  end
end
