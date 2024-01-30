BulletTrain.configure do |config|
  # Ensures that only strong passwords are used when registering a user.
  # Please note that the password validations for devise are still in place.
  config.strong_passwords = !Rails.env.development?

  # Enable bulk invitations on the user onboarding step.
  # config.enable_bulk_invitations = true

  # Change the parent class you want incoming webhooks to inherit from.
  config.incoming_webhooks_parent_class_name = "ApplicationRecord"
end
