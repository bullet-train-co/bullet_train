class Api::Test < ActionDispatch::IntegrationTest
  # TODO Why can't we do `response.parsed_body`? Is it because of the `application/vnd.api+json`?
  def parsed_body
    JSON.parse(response.body)
  end

  def access_token
    params = {
      token: @api_key.token,
      secret: "something we know",
      client_id: @doorkeeper_application.uid,
      client_secret: @doorkeeper_application.secret,
      grant_type: "password",
      scope: "read write delete"
    }

    post "/oauth/token", params: params
    assert_response :success
    response.parsed_body["access_token"]
  end

  def another_access_token
    params = {
      token: @another_api_key.token,
      secret: "something else we know",
      client_id: @another_doorkeeper_application.uid,
      client_secret: @another_doorkeeper_application.secret,
      grant_type: "password",
      scope: "read write delete"
    }

    post "/oauth/token", params: params
    assert_response :success
    response.parsed_body["access_token"]
  end

  def assert_response_specific_not_found
    assert_response :not_found
    # Some invalid token errors also return 404, so it's important that we assert for the actual error message,
    # otherwise we're not testing the right thing.
    assert parsed_body["error"].include?("could not be found")
  end

  def setup
    @user = create(:onboarded_user)
    @team = @user.current_team
    @api_key = build(:api_key, user: @user)
    @api_key.generate_encrypted_secret("something we know")
    @api_key.save
    @doorkeeper_application = create(:doorkeeper_application, team: @team)

    @another_user = create(:onboarded_user)
    @another_api_key = build(:api_key, user: @another_user)
    @another_api_key.generate_encrypted_secret("something else we know")
    @another_api_key.save
    @another_doorkeeper_application = create(:doorkeeper_application, team: @another_user.current_team)
  end
end
