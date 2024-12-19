require "application_system_test_case"

class BulletTrain::SuperScaffolding::WebhookTest < ApplicationSystemTestCase
  # We don't test anythying direclty on this one one.
  # Instead we test that the controller and test that we generated run correctly.
  # In CI we explicitly call:
  # rails test test/controllers/webhooks/incoming/some_provider_webhooks_controller_test.rb
end
