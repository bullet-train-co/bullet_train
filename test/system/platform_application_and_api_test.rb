require "application_system_test_case"

class PlatformApplicationAndApiTest < ApplicationSystemTestCase
  def setup
    super
    @user = create(:onboarded_user, email: "api-user@example.com")
    @team = @user.current_team
    @team.update(name: "API Test Team")
  end

  device_test "user can register api application and use credentials to fetch team details" do
    # Sign in as the user
    login_as(@user, scope: :user)
    visit account_dashboard_path

    # Navigate to API section from the application dashboard
    if disable_developer_menu?
      visit account_team_platform_applications_path(@team)
    else
      within_developers_menu_for(display_details) do
        click_on "API"
      end
    end

    # Register a new API application
    click_on "Provision New Platform Application"
    fill_in "Name", with: "Test API Application"
    click_on "Provision Platform Application"
    assert_text("Platform Application was successfully created.")

    # Extract the credentials from the show page
    uid = nil
    secret = nil

    # Find the application we just created
    application = Platform::Application.find_by(name: "Test API Application")
    assert_not_nil application, "Platform Application should exist"

    # Get the uid and secret from the application record
    uid = application.uid
    secret = application.secret

    assert_not_nil uid, "Application UID should be present"
    assert_not_nil secret, "Application secret should be present"

    # Verify the credentials are displayed on the page
    assert_text(uid)

    # Get the access token that was automatically created with the application
    # Platform::Application automatically creates an access token on creation
    access_token = application.access_tokens.first
    assert_not_nil access_token, "Access token should have been created automatically"

    # Get the token value
    token_value = access_token.token
    assert_not_nil token_value, "Token value should be present"

    # Use the access token to fetch team details
    require "net/http"
    require "json"
    require "uri"

    api_uri = URI("http://localhost:#{Capybara.server_port}/api/v1/teams/#{@team.id}")
    api_request = Net::HTTP::Get.new(api_uri)
    api_request["Authorization"] = "Bearer #{token_value}"

    api_response = Net::HTTP.start(api_uri.hostname, api_uri.port) do |http|
      http.request(api_request)
    end

    assert_equal "200", api_response.code, "API request should succeed. Response: #{api_response.body}"
    team_data = JSON.parse(api_response.body)

    # Verify the team data returned is correct
    assert_equal @team.id, team_data["id"], "Team ID should match"
    assert_equal "API Test Team", team_data["name"], "Team name should match"
  end
end
