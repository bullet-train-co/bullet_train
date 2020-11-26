class Account::Webhooks::Outgoing::DeliveriesController < Account::ApplicationController
  account_load_and_authorize_resource :delivery, through: :endpoint, through_association: :deliveries

  # GET /account/webhooks/outgoing/endpoints/:endpoint_id/webhooks/outgoing/deliveries
  # GET /account/webhooks/outgoing/endpoints/:endpoint_id/webhooks/outgoing/deliveries.json
  def index
    # since we're showing deliveries on the endpoint show page by default,
    # we might as well just go there.
    redirect_to [:account, @endpoint]
  end

  # GET /account/webhooks/outgoing/deliveries/:id
  # GET /account/webhooks/outgoing/deliveries/:id.json
  def show
  end

  private
    # Never trust parameters from the scary internet, only allow the white list through.
    def delivery_params
      params.require(:webhooks_outgoing_delivery).permit()
    end
end
