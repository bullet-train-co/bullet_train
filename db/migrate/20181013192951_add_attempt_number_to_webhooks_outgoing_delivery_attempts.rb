class AddAttemptNumberToWebhooksOutgoingDeliveryAttempts < ActiveRecord::Migration[5.2]
  def change
    add_column :webhooks_outgoing_delivery_attempts, :attempt_number, :integer
  end
end
