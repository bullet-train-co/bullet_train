class Account::Webhooks::Outgoing::EndpointsController < Account::ApplicationController
  account_load_and_authorize_resource :endpoint, through: :team, through_association: :webhooks_outgoing_endpoints

  # GET /account/teams/:team_id/webhooks/outgoing/endpoints
  # GET /account/teams/:team_id/webhooks/outgoing/endpoints.json
  def index
    # if you only want these objects shown on their parent's show page, uncomment this:
    # redirect_to [:account, @team]
  end

  # GET /account/webhooks/outgoing/endpoints/:id
  # GET /account/webhooks/outgoing/endpoints/:id.json
  def show
  end

  # GET /account/teams/:team_id/webhooks/outgoing/endpoints/new
  def new
  end

  # GET /account/webhooks/outgoing/endpoints/:id/edit
  def edit
  end

  # POST /account/teams/:team_id/webhooks/outgoing/endpoints
  # POST /account/teams/:team_id/webhooks/outgoing/endpoints.json
  def create
    respond_to do |format|
      if @endpoint.save
        format.html { redirect_to [:account, @team, :webhooks_outgoing_endpoints], notice: I18n.t("webhooks/outgoing/endpoints.notifications.created") }
        format.json { render :show, status: :created, location: [:account, @endpoint] }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @endpoint.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /account/webhooks/outgoing/endpoints/:id
  # PATCH/PUT /account/webhooks/outgoing/endpoints/:id.json
  def update
    respond_to do |format|
      if @endpoint.update(endpoint_params)
        format.html { redirect_to [:account, @endpoint], notice: I18n.t("webhooks/outgoing/endpoints.notifications.updated") }
        format.json { render :show, status: :ok, location: [:account, @endpoint] }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @endpoint.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /account/webhooks/outgoing/endpoints/:id
  # DELETE /account/webhooks/outgoing/endpoints/:id.json
  def destroy
    @endpoint.destroy
    respond_to do |format|
      format.html { redirect_to [:account, @team, :webhooks_outgoing_endpoints], notice: I18n.t("webhooks/outgoing/endpoints.notifications.destroyed") }
      format.json { head :no_content }
    end
  end

  private

  # Never trust parameters from the scary internet, only allow the white list through.
  def endpoint_params
    strong_params = params.require(:webhooks_outgoing_endpoint).permit(
      :name,
      :url,
      # 🚅 super scaffolding will insert new fields above this line.
      event_type_ids: [],
      # 🚅 super scaffolding will insert new arrays above this line.
    )

    assign_select_options(strong_params, :event_type_ids)
    # 🚅 super scaffolding will insert processing for new fields above this line.

    strong_params
  end
end
