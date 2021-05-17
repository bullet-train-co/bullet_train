class Api::V1::TeamsEndpoint < Api::V1::Root
  helpers do
    params :id do
      requires :id, type: Integer, desc: "Team ID"
    end

    params :team do
      optional :name, type: String, desc: gth(:name)
      # optional :slug, type: String, desc: gth(:slug)
      # 🚅 super scaffolding will insert new fields above this line.
      # 🚅 super scaffolding will insert new arrays above this line.

      # 🚅 super scaffolding will insert processing for new fields above this line.
    end
  end

  resource :teams, desc: gt(:actions) do
    after_validation do
      load_and_authorize_api_resource Team
    end

    desc gt(:index)
    oauth2
    paginate per_page: 100
    get "/" do
      @paginated_teams = paginate @teams
      render @paginated_teams, serializer: Api::V1::TeamSerializer, adapter: :attributes
    end

    desc gt(:show)
    params do
      use :id
    end
    oauth2
    route_param :id do
      get do
        @team
      end
    end

    desc gt(:create) do
      consumes ["application/json", "multipart/form-data"]
    end
    params do
      use :team
    end
    route_setting :api_resource_options, permission: :create
    oauth2 "write"
    post "/" do
      if @team.save
        # sets the team creator as the default admin
        @team.memberships.create(user: current_user, roles: [Role.admin])

        current_user.current_team = @team
        current_user.former_user = false
        current_user.save

        @team
      else
        record_not_saved @team
      end
    end

    desc gt(:update) do
      consumes ["application/json", "multipart/form-data"]
    end
    params do
      use :id
      use :team
    end
    route_setting :api_resource_options, permission: :update
    oauth2 "write"
    route_param :id do
      put do
        if @team.update(declared(params, include_missing: false))
          @team
        else
          record_not_saved @team
        end
      end
    end
  end
end
