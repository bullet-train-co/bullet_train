class VerifiedAtToWebhooksIncomingBulletTrainWebhooks < ActiveRecord::Migration[5.2]
  def change
    add_column :webhooks_incoming_bullet_train_webhooks, :verified_at, :datetime
  end
end
