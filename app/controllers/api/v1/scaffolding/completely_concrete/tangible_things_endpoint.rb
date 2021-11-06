class Api::V1::Scaffolding::CompletelyConcrete::TangibleThingsEndpoint < Api::V1::Root
  helpers do
    params :absolutely_abstract_creative_concept_id do
      requires :absolutely_abstract_creative_concept_id, type: Integer, allow_blank: false, desc: "Creative Concept ID"
    end

    params :id do
      requires :id, type: Integer, allow_blank: false, desc: "Tangible Thing ID"
    end

    params :tangible_thing do
      # 🚅 skip this section when scaffolding.
      optional :text_field_value, type: String, allow_blank: true, desc: Api.heading(:text_field_value)
      optional :button_value, type: String, allow_blank: true, desc: Api.heading(:button_value)
      optional :cloudinary_image_value, type: String, allow_blank: true, desc: Api.heading(:cloudinary_image_value)
      optional :date_field_value, type: Date, allow_blank: true, desc: Api.heading(:date_field_value)
      optional :date_and_time_field_value, type: DateTime, allow_blank: true, desc: Api.heading(:date_and_time_field_value)
      optional :email_field_value, type: String, allow_blank: true, desc: Api.heading(:email_field_value)
      optional :password_field_value, type: String, allow_blank: true, desc: Api.heading(:password_field_value)
      optional :phone_field_value, type: String, allow_blank: true, desc: Api.heading(:phone_field_value)
      optional :option_value, type: String, allow_blank: true, desc: Api.heading(:option_value)
      optional :super_select_value, type: String, allow_blank: true, desc: Api.heading(:super_select_value)
      optional :text_area_value, type: String, allow_blank: true, desc: Api.heading(:text_area_value)
      optional :action_text_value, type: String, allow_blank: true, desc: Api.heading(:action_text_value)
      optional :ckeditor_value, type: String, allow_blank: true, desc: Api.heading(:ckeditor_value)
      # 🚅 stop any skipping we're doing now.
      # 🚅 super scaffolding will insert new fields above this line.
      # 🚅 skip this section when scaffolding.
      optional :multiple_button_values, type: Array, default: [], desc: Api.heading(:multiple_button_values)
      optional :multiple_option_values, type: Array, default: [], desc: Api.heading(:multiple_option_values)
      optional :multiple_super_select_values, type: Array, default: [], desc: Api.heading(:multiple_super_select_values)
      # 🚅 stop any skipping we're doing now.
      # 🚅 super scaffolding will insert new arrays above this line.

      # 🚅 super scaffolding will insert processing for new fields above this line.
    end
  end

  resource "scaffolding/absolutely_abstract/creative_concepts", desc: Api.title(:collection_actions) do
    after_validation do
      load_and_authorize_api_resource Scaffolding::CompletelyConcrete::TangibleThing
    end

    #
    # INDEX
    #

    desc Api.title(:index), &Api.index_desc
    params do
      use :absolutely_abstract_creative_concept_id
    end
    oauth2
    paginate per_page: 100
    get "/:absolutely_abstract_creative_concept_id/completely_concrete/tangible_things" do
      @paginated_tangible_things = paginate @tangible_things
      render @paginated_tangible_things, serializer: Api.serializer
    end

    #
    # CREATE
    #

    desc Api.title(:create), &Api.create_desc
    params do
      use :absolutely_abstract_creative_concept_id
      use :tangible_thing
    end
    route_setting :api_resource_options, permission: :create
    oauth2 "write"
    post "/:absolutely_abstract_creative_concept_id/completely_concrete/tangible_things" do
      if @tangible_thing.save
        render @tangible_thing, serializer: Api.serializer
      else
        record_not_saved @tangible_thing
      end
    end
  end

  resource "scaffolding/completely_concrete/tangible_things", desc: Api.title(:member_actions) do
    after_validation do
      load_and_authorize_api_resource Scaffolding::CompletelyConcrete::TangibleThing
    end

    #
    # SHOW
    #

    desc Api.title(:show), &Api.show_desc
    params do
      use :id
    end
    oauth2
    route_param :id do
      get do
        render @tangible_thing, serializer: Api.serializer
      end
    end

    #
    # UPDATE
    #

    desc Api.title(:update), &Api.update_desc
    params do
      use :id
      use :tangible_thing
    end
    route_setting :api_resource_options, permission: :update
    oauth2 "write"
    route_param :id do
      put do
        if @tangible_thing.update(declared(params, include_missing: false))
          render @tangible_thing, serializer: Api.serializer
        else
          record_not_saved @tangible_thing
        end
      end
    end

    #
    # DESTROY
    #

    desc Api.title(:destroy), &Api.destroy_desc
    params do
      use :id
    end
    route_setting :api_resource_options, permission: :destroy
    oauth2 "delete"
    route_param :id do
      delete do
        render @tangible_thing.destroy, serializer: Api.serializer
      end
    end
  end
end
