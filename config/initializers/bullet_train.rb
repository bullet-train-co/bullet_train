BulletTrain.configure do |config|
  # Use strong passwords when registering a user in non-development environment.
  # Please note that the password validations for devise are still in place
  # in all environments.
  config.strong_passwords = !Rails.env.development?

  # Enable bulk invitations on the user onboarding step.
  # config.enable_bulk_invitations = true

  # Change the parent class you want incoming webhooks to inherit from.
  config.incoming_webhooks_parent_class_name = "ApplicationRecord"
end
