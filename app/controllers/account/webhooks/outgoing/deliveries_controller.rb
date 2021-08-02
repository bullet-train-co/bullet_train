class Account::Webhooks::Outgoing::DeliveriesController < Account::ApplicationController
  account_load_and_authorize_resource :delivery, through: :endpoint, through_association: :deliveries

  # GET /account/webhooks/outgoing/endpoints/:endpoint_id/deliveries
  # GET /account/webhooks/outgoing/endpoints/:endpoint_id/deliveries.json
  def index
    # if you only want these objects shown on their parent's show page, uncomment this:
    redirect_to [:account, @endpoint]
  end

  # GET /account/webhooks/outgoing/deliveries/:id
  # GET /account/webhooks/outgoing/deliveries/:id.json
  def show
  end

  # GET /account/webhooks/outgoing/endpoints/:endpoint_id/deliveries/new
  def new
  end

  # GET /account/webhooks/outgoing/deliveries/:id/edit
  def edit
  end

  # POST /account/webhooks/outgoing/endpoints/:endpoint_id/deliveries
  # POST /account/webhooks/outgoing/endpoints/:endpoint_id/deliveries.json
  def create
    respond_to do |format|
      if @delivery.save
        format.html { redirect_to [:account, @endpoint, :deliveries], notice: I18n.t("webhooks/outgoing/deliveries.notifications.created") }
        format.json { render :show, status: :created, location: [:account, @delivery] }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @delivery.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /account/webhooks/outgoing/deliveries/:id
  # PATCH/PUT /account/webhooks/outgoing/deliveries/:id.json
  def update
    respond_to do |format|
      if @delivery.update(delivery_params)
        format.html { redirect_to [:account, @delivery], notice: I18n.t("webhooks/outgoing/deliveries.notifications.updated") }
        format.json { render :show, status: :ok, location: [:account, @delivery] }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @delivery.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /account/webhooks/outgoing/deliveries/:id
  # DELETE /account/webhooks/outgoing/deliveries/:id.json
  def destroy
    @delivery.destroy
    respond_to do |format|
      format.html { redirect_to [:account, @endpoint, :deliveries], notice: I18n.t("webhooks/outgoing/deliveries.notifications.destroyed") }
      format.json { head :no_content }
    end
  end

  private

  # Never trust parameters from the scary internet, only allow the white list through.
  def delivery_params
    strong_params = params.require(:webhooks_outgoing_delivery).permit(
      :event_id,
      :endpoint_url,
      :delivered_at,
      # 🚅 super scaffolding will insert new fields above this line.
      # 🚅 super scaffolding will insert new arrays above this line.
    )

    assign_date_and_time(strong_params, :delivered_at)
    # 🚅 super scaffolding will insert processing for new fields above this line.

    strong_params
  end
end
