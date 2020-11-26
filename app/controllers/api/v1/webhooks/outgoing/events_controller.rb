class Api::V1::Webhooks::Outgoing::EventsController < Api::V1::AuthenticatedController
  account_load_and_authorize_resource :event, through: :team, through_association: :webhooks_outgoing_events, find_by: :uuid

  # GET /api/v1/events/67646f2b68c0c3e7b0aabd9e42b1b21d
  # GET /api/v1/events/67646f2b68c0c3e7b0aabd9e42b1b21d.json
  def show
    render json: @event.payload
  end
end
