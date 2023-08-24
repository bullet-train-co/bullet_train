BulletTrain.configure do |config|
  # Uncomment this line if you want to bypass strong passwords.
  # config.strong_passwords = false

  # Enable bulk invitations on the user onboarding step.
  # config.enable_bulk_invitations = true

  # Change the parent class you want incoming webhooks to inherit from.
  config.incoming_webhooks_parent_class_name = "ApplicationRecord"
end
