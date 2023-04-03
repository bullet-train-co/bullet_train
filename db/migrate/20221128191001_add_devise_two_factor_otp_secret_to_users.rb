class AddDeviseTwoFactorOtpSecretToUsers < ActiveRecord::Migration[7.0]
  def change
    add_column :users, :otp_secret, :string
  end
end
