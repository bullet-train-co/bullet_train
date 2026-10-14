require "test_helper"

# Only development and production use the Redis adapter (see config/cable.yml), and Action Cable
# requires the adapter lazily on first use, so nothing else in the suite notices when the redis gem
# in the lockfile falls outside the version range the adapter declares. That combination broke the
# first sign-up on every fresh app once the redis gem moved to 6.0 while Rails 8.1.3.1 still
# required `< 6`. This resolves the adapter the same way Action Cable does in production.
class RedisSubscriptionAdapterTest < ActiveSupport::TestCase
  test "Action Cable's Redis adapter loads with the bundled redis gem" do
    config = ActionCable::Server::Configuration.new
    config.cable = {"adapter" => "redis"}

    assert_equal ActionCable::SubscriptionAdapter::Redis, config.pubsub_adapter
  end
end
