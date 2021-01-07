class Account::Oauth::StripeAccountsController < Account::ApplicationController
  account_load_and_authorize_resource :stripe_account, through: :team, through_association: :oauth_stripe_accounts

  # GET /account/teams/:team_id/oauth/stripe_accounts
  # GET /account/teams/:team_id/oauth/stripe_accounts.json
  def index
  end

  # GET /account/oauth/stripe_accounts/:id
  # GET /account/oauth/stripe_accounts/:id.json
  def show
  end

  # GET /account/teams/:team_id/oauth/stripe_accounts/new
  def new
    redirect_to user_stripe_connect_omniauth_authorize_path(team_id: @team.id)
  end

  # GET /account/oauth/stripe_accounts/:id/edit
  def edit
  end

  # PATCH/PUT /account/oauth/stripe_accounts/:id
  # PATCH/PUT /account/oauth/stripe_accounts/:id.json
  def update
    respond_to do |format|
      if @stripe_account.update(stripe_account_params)
        format.html { redirect_to [:account, @stripe_account], notice: I18n.t('oauth/stripe_accounts.notifications.updated') }
        format.json { render :show, status: :ok, location: [:account, @stripe_account] }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @stripe_account.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /account/oauth/stripe_accounts/:id
  # DELETE /account/oauth/stripe_accounts/:id.json
  def destroy
    if @stripe_account.user_id.present?
      @stripe_account.update_column(:team_id, nil)
    else
      @stripe_account.destroy
    end
    respond_to do |format|
      format.html { redirect_to [:account, @team, :oauth, :stripe_accounts], notice: I18n.t('oauth/stripe_accounts.notifications.destroyed') }
      format.json { head :no_content }
    end
  end

  private
    # Never trust parameters from the scary internet, only allow the white list through.
    def stripe_account_params
      strong_params = params.require(:oauth_stripe_account).permit(
        # 🚅 super scaffolding will insert new fields above this line.
        # 🚅 super scaffolding will insert new arrays above this line.
      )

      # 🚅 super scaffolding will insert processing for new fields above this line.

      strong_params
    end
end
