class Api::V1::Webhooks::Outgoing::DeliveryAttemptsEndpoint < Api::V1::Root
  helpers do
    params :delivery_id do
      requires :delivery_id, type: Integer, allow_blank: false, desc: "Delivery ID"
    end

    params :id do
      requires :id, type: Integer, allow_blank: false, desc: "Delivery Attempt ID"
    end

    params :delivery_attempt do
      optional :response_code, type: String, desc: Api.heading(:response_code)
      optional :response_body, type: String, desc: Api.heading(:response_body)
      optional :response_message, type: String, desc: Api.heading(:response_message)
      optional :error_message, type: String, desc: Api.heading(:error_message)
      optional :attempt_number, type: String, desc: Api.heading(:attempt_number)
      # 🚅 super scaffolding will insert new fields above this line.
      # 🚅 super scaffolding will insert new arrays above this line.

      # 🚅 super scaffolding will insert processing for new fields above this line.
    end
  end

  resource "webhooks/outgoing/deliveries", desc: Api.title(:collection_actions) do
    after_validation do
      load_and_authorize_api_resource Webhooks::Outgoing::DeliveryAttempt
    end

    #
    # INDEX
    #

    desc Api.title(:index), &Api.index_desc
    params do
      use :delivery_id
    end
    oauth2
    paginate per_page: 100
    get "/:delivery_id/delivery_attempts" do
      @paginated_delivery_attempts = paginate @delivery_attempts
      render @paginated_delivery_attempts, serializer: Api.serializer
    end
  end

  resource "webhooks/outgoing/delivery_attempts", desc: Api.title(:member_actions) do
    after_validation do
      load_and_authorize_api_resource Webhooks::Outgoing::DeliveryAttempt
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
        render @delivery_attempt, serializer: Api.serializer
      end
    end
  end
end
