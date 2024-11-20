class Api::Test < ActionDispatch::IntegrationTest
  def access_token
    access_token = Doorkeeper::AccessToken.create!(
      resource_owner_id: @user.id,
      token: SecureRandom.hex,
      application: @platform_application,
      scopes: "read write delete"
    )
    access_token.token
  end

  def another_access_token
    access_token = Doorkeeper::AccessToken.create!(
      resource_owner_id: @another_user.id,
      token: SecureRandom.hex,
      application: @another_platform_application,
      scopes: "read write delete"
    )
    access_token.token
  end

  setup do
    @user = create(:onboarded_user)
    @team = @user.current_team
    @platform_application = create(:platform_application, team: @team)

    @another_user = create(:onboarded_user)
    @another_platform_application = create(:platform_application, team: @another_user.current_team)
  end
end
