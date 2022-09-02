class Api::Test < ActionDispatch::IntegrationTest
  # Since response.parsed_body only works with :json out of the box,
  # we register this encoder so rails knows how to parse a JSON:API response.
  ActionDispatch::IntegrationTest.register_encoder :jsonapi,
    response_parser: ->(body) { JSON.parse(body) }

  def access_token
    params = {
      client_id: @platform_application.uid,
      client_secret: @platform_application.secret,
      grant_type: "password",
      scope: "read write delete"
    }

    post "/oauth/token", params: params
    assert_response :success
    response.parsed_body["access_token"]
  end

  def another_access_token
    params = {
      client_id: @another_platform_application.uid,
      client_secret: @another_platform_application.secret,
      grant_type: "password",
      scope: "read write delete"
    }

    post "/oauth/token", params: params
    assert_response :success
    response.parsed_body["access_token"]
  end

  def setup
    super

    @user = create(:onboarded_user)
    @team = @user.current_team
    @platform_application = create(:platform_application, team: @team)

    @another_user = create(:onboarded_user)
    @another_platform_application = create(:platform_application, team: @another_user.current_team)
  end
end
