class AddLastNotificationEmailSentAtToUser < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :last_notification_email_sent_at, :datetime
  end
end
