class AddNameToWebhooksOutgoingEndpoints < ActiveRecord::Migration[5.2]
  def change
    add_column :webhooks_outgoing_endpoints, :name, :string
  end
end
