class RemoveDefaultFromWebhooksOutgoingEndpoints < ActiveRecord::Migration[7.0]
  def change
    change_column_default :webhooks_outgoing_endpoints, :api_version, from: 1, to: nil
  end
end
