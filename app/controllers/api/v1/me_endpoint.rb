class Api::V1::MeEndpoint < Api::V1::Root
  resource :me do
    oauth2
    get "/" do
      render Api::V1::UserSerializer.new(current_user, include: [:teams, :memberships]).to_json
    end
  end
end
