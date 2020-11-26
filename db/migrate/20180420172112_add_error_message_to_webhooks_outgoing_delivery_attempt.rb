class AddErrorMessageToWebhooksOutgoingDeliveryAttempt < ActiveRecord::Migration[5.2]
  def change
    add_column :webhooks_outgoing_delivery_attempts, :response_message, :text
    add_column :webhooks_outgoing_delivery_attempts, :error_message, :text
  end
end
