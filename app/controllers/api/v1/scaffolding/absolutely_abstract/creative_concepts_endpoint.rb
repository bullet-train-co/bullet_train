class Api::V1::Scaffolding::AbsolutelyAbstract::CreativeConceptsEndpoint < Api::V1::Root
  helpers do
    include Scaffolding::AbsolutelyAbstract::CreativeConcepts::ControllerSupport

    params :team_id do
      requires :team_id, type: Integer, desc: gt(:team_id)
    end

    params :id do
      requires :id, type: Integer, desc: gt(:id)
    end

    params :creative_concept do
      optional :name, type: String, desc: gth(:name)
      optional :description, type: String, desc: gth(:description)
      # 🚅 super scaffolding will insert new fields above this line.
      # 🚅 super scaffolding will insert new arrays above this line.

      # 🚅 super scaffolding will insert processing for new fields above this line.
    end
  end

  # uses shallow routing to support teams
  resource :teams, desc: gt(:collection_actions) do
    after_validation do
      load_and_authorize_api_resource Scaffolding::AbsolutelyAbstract::CreativeConcept
    end

    desc gt(:index)
    params do
      use :team_id
    end
    oauth2
    paginate per_page: 100
    get "/:team_id/scaffolding/absolutely_abstract/creative_concepts" do
      @paginated_creative_concepts = paginate @creative_concepts
      render @paginated_creative_concepts, serializer: Api::V1::Scaffolding::AbsolutelyAbstract::CreativeConceptSerializer, adapter: :attributes
    end

    desc gt(:create) do
      consumes ["application/json", "multipart/form-data"]
    end
    params do
      use :team_id
      use :creative_concept
    end
    route_setting :api_resource_options, permission: :create
    oauth2 "write"
    post "/:team_id/scaffolding/absolutely_abstract/creative_concepts" do
      ensure_current_user_can_manage_creative_concept @creative_concept

      if @creative_concept.save
        @creative_concept
      else
        record_not_saved @creative_concept
      end
    end
  end

  resource "scaffolding/absolutely_abstract/creative_concepts", desc: gt(:member_actions) do
    after_validation do
      load_and_authorize_api_resource Scaffolding::AbsolutelyAbstract::CreativeConcept
    end

    desc gt(:show)
    params do
      use :id
    end
    oauth2
    route_param :id do
      get do
        @creative_concept
      end
    end

    desc gt(:update) do
      consumes ["application/json", "multipart/form-data"]
    end
    params do
      use :id
      use :creative_concept
    end
    route_setting :api_resource_options, permission: :update
    oauth2 "write"
    route_param :id do
      put do
        if @creative_concept.update(declared(params, include_missing: false))
          @creative_concept
        else
          record_not_saved @creative_concept
        end
      end
    end

    desc gt(:destroy)
    params do
      use :id
    end
    route_setting :api_resource_options, permission: :destroy
    oauth2 "delete"
    route_param :id do
      delete do
        @creative_concept.destroy
      end
    end
  end
end
