require "controllers/api/v1/test"

class Api::V1::Platform::ApplicationsControllerTest < Api::Test
  include Devise::Test::IntegrationHelpers

  def setup
    # See `test/controllers/api/test.rb` for common set up for API tests.
    super
    sign_in @user
  end

  test "provision" do
    if ENV["TESTING_PROVISION_KEY"].present?
      get "/testing/provision", params: {key: nil}
      assert_equal(response.parsed_body, {"message" => "You must provide the proper testing provision key to create a test application."})

      get "/testing/provision", params: {key: "not_the_correct_key"}
      assert_equal(response.parsed_body, {"message" => "You must provide the proper testing provision key to create a test application."})

      # Providing the proper key creates a new Team and Platform::Application
      assert_difference("Team.count", 1) do
        assert_difference("Platform::Application.count", 1) do
          get "/testing/provision", params: {key: ENV["TESTING_PROVISION_KEY"]}
        end
      end
    else
      # A test application shouldn't be created when the key is empty nor the environment variable provided.
      get "/testing/provision"
      assert_equal(response.parsed_body, {"message" => "You must provide the proper testing provision key to create a test application."})
    end
  end
end
