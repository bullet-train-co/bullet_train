class Account::Integrations::StripeInstallationsController < Account::ApplicationController
  account_load_and_authorize_resource :stripe_installation, through: :team, through_association: :integrations_stripe_installations

  # GET /account/teams/:team_id/integrations/stripe_installations
  # GET /account/teams/:team_id/integrations/stripe_installations.json
  def index
    # if you only want these objects shown on their parent's show page, uncomment this:
    # redirect_to [:account, @team]
  end

  # GET /account/integrations/stripe_installations/:id
  # GET /account/integrations/stripe_installations/:id.json
  def show
  end

  # GET /account/teams/:team_id/integrations/stripe_installations/new
  def new
  end

  # GET /account/integrations/stripe_installations/:id/edit
  def edit
  end

  # POST /account/teams/:team_id/integrations/stripe_installations
  # POST /account/teams/:team_id/integrations/stripe_installations.json
  def create
    respond_to do |format|
      if @stripe_installation.save
        format.html { redirect_to [:account, @team, :integrations_stripe_installations], notice: I18n.t("integrations/stripe_installations.notifications.created") }
        format.json { render :show, status: :created, location: [:account, @stripe_installation] }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @stripe_installation.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /account/integrations/stripe_installations/:id
  # PATCH/PUT /account/integrations/stripe_installations/:id.json
  def update
    respond_to do |format|
      if @stripe_installation.update(stripe_installation_params)
        format.html { redirect_to [:account, @stripe_installation], notice: I18n.t("integrations/stripe_installations.notifications.updated") }
        format.json { render :show, status: :ok, location: [:account, @stripe_installation] }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @stripe_installation.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /account/integrations/stripe_installations/:id
  # DELETE /account/integrations/stripe_installations/:id.json
  def destroy
    @stripe_installation.destroy
    respond_to do |format|
      format.html { redirect_to params[:return_to] || [:account, @team, :integrations_stripe_installations], notice: I18n.t("integrations/stripe_installations.notifications.destroyed") }
      format.json { head :no_content }
    end
  end

  private

  # Never trust parameters from the scary internet, only allow the white list through.
  def stripe_installation_params
    strong_params = params.require(:integrations_stripe_installation).permit(
      :name,
      # 🚅 super scaffolding will insert new fields above this line.
      multiple_button_values: [],
      multiple_super_select_values: [],
      # 🚅 super scaffolding will insert new arrays above this line.
    )

    assign_checkboxes(strong_params, :multiple_button_values)
    assign_select_options(strong_params, :multiple_super_select_values)
    # 🚅 super scaffolding will insert processing for new fields above this line.

    strong_params
  end
end
