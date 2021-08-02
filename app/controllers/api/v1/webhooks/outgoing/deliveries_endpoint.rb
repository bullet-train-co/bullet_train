class Api::V1::Webhooks::Outgoing::DeliveriesEndpoint < Api::V1::Root
  helpers do
    params :endpoint_id do
      requires :endpoint_id, type: Integer, allow_blank: false, desc: "Endpoint ID"
    end

    params :id do
      requires :id, type: Integer, allow_blank: false, desc: "Delivery ID"
    end

    params :delivery do
      optional :event_id, type: String, desc: Api.heading(:event_id)
      optional :endpoint_url, type: String, desc: Api.heading(:endpoint_url)
      optional :delivered_at, type: DateTime, desc: Api.heading(:delivered_at)
      # 🚅 super scaffolding will insert new fields above this line.
      # 🚅 super scaffolding will insert new arrays above this line.

      # 🚅 super scaffolding will insert processing for new fields above this line.
    end
  end

  resource "webhooks/outgoing/endpoints", desc: Api.title(:collection_actions) do
    after_validation do
      load_and_authorize_api_resource Webhooks::Outgoing::Delivery
    end

    #
    # INDEX
    #

    desc Api.title(:index), &Api.index_desc
    params do
      use :endpoint_id
    end
    oauth2
    paginate per_page: 100
    get "/:endpoint_id/deliveries" do
      @paginated_deliveries = paginate @deliveries
      render @paginated_deliveries, serializer: Api.serializer
    end
  end

  resource "webhooks/outgoing/deliveries", desc: Api.title(:member_actions) do
    after_validation do
      load_and_authorize_api_resource Webhooks::Outgoing::Delivery
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
        render @delivery, serializer: Api.serializer
      end
    end
  end
end
