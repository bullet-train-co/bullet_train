class Account::ClientsController < Account::ApplicationController
  account_load_and_authorize_resource :client, through: :team, through_association: :clients

  # GET /account/teams/:team_id/clients
  # GET /account/teams/:team_id/clients.json
  def index
    delegate_json_to_api
  end

  # GET /account/clients/:id
  # GET /account/clients/:id.json
  def show
    delegate_json_to_api
  end

  # GET /account/teams/:team_id/clients/new
  def new
  end

  # GET /account/clients/:id/edit
  def edit
  end

  # POST /account/teams/:team_id/clients
  # POST /account/teams/:team_id/clients.json
  def create
    respond_to do |format|
      if @client.save
        format.html { redirect_to [:account, @client], notice: I18n.t("clients.notifications.created") }
        format.json { render :show, status: :created, location: [:account, @client] }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @client.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /account/clients/:id
  # PATCH/PUT /account/clients/:id.json
  def update
    respond_to do |format|
      if @client.update(client_params)
        format.html { redirect_to [:account, @client], notice: I18n.t("clients.notifications.updated") }
        format.json { render :show, status: :ok, location: [:account, @client] }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @client.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /account/clients/:id
  # DELETE /account/clients/:id.json
  def destroy
    @client.destroy
    respond_to do |format|
      format.html { redirect_to [:account, @team, :clients], notice: I18n.t("clients.notifications.destroyed") }
      format.json { head :no_content }
    end
  end

  private

  if defined?(Api::V1::ApplicationController)
    include strong_parameters_from_api
  end

  def process_params(strong_params)
    # 🚅 super scaffolding will insert processing for new fields above this line.
  end
end
