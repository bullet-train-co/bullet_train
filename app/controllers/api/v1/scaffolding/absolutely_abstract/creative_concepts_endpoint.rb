class Api::V1::Scaffolding::AbsolutelyAbstract::CreativeConceptsEndpoint < Api::V1::Root
  helpers do
    include Scaffolding::AbsolutelyAbstract::CreativeConcepts::ControllerSupport

    params :team_id do
      requires :team_id, type: Integer, allow_blank: false, desc: Api.heading(:team_id)
    end

    params :id do
      requires :id, type: Integer, allow_blank: false, desc: Api.heading(:id)
    end

    params :creative_concept do
      optional :name, type: String, allow_blank: false, desc: Api.heading(:name)
      optional :description, type: String, allow_blank: true, desc: Api.heading(:description)
      # 🚅 super scaffolding will insert new fields above this line.
      # 🚅 super scaffolding will insert new arrays above this line.

      # 🚅 super scaffolding will insert processing for new fields above this line.
    end
  end

  # uses shallow routing to support teams
  resource :teams, desc: Api.title(:collection_actions) do
    after_validation do
      load_and_authorize_api_resource Scaffolding::AbsolutelyAbstract::CreativeConcept
    end

    desc Api.title(:index), &Api.index_desc
    params do
      use :team_id
    end
    oauth2
    paginate per_page: 100
    get "/:team_id/scaffolding/absolutely_abstract/creative_concepts" do
      @paginated_creative_concepts = paginate @creative_concepts
      render @paginated_creative_concepts, serializer: Api.serializer, adapter: :attributes
    end

    desc Api.title(:create), &Api.create_desc
    params do
      use :team_id
      use :creative_concept
    end
    route_setting :api_resource_options, permission: :create
    oauth2 "write"
    post "/:team_id/scaffolding/absolutely_abstract/creative_concepts" do
      ensure_current_user_can_manage_creative_concept @creative_concept

      if @creative_concept.save
        render @creative_concept, serializer: Api.serializer
      else
        record_not_saved @creative_concept
      end
    end
  end

  resource "scaffolding/absolutely_abstract/creative_concepts", desc: Api.title(:member_actions) do
    after_validation do
      load_and_authorize_api_resource Scaffolding::AbsolutelyAbstract::CreativeConcept
    end

    desc Api.title(:show), &Api.show_desc
    params do
      use :id
    end
    oauth2
    route_param :id do
      get do
        render @creative_concept, serializer: Api.serializer
      end
    end

    desc Api.title(:update), &Api.update_desc
    params do
      use :id
      use :creative_concept
    end
    route_setting :api_resource_options, permission: :update
    oauth2 "write"
    route_param :id do
      put do
        if @creative_concept.update(declared(params, include_missing: false))
          render @creative_concept, serializer: Api.serializer
        else
          record_not_saved @creative_concept
        end
      end
    end

    desc Api.title(:destroy), &Api.destroy_desc
    params do
      use :id
    end
    route_setting :api_resource_options, permission: :destroy
    oauth2 "delete"
    route_param :id do
      delete do
        render @creative_concept.destroy, serializer: Api.serializer
      end
    end
  end
end
