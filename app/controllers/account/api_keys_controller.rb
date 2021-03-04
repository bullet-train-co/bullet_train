class Account::ApiKeysController < Account::ApplicationController
  load_and_authorize_resource :api_key

  before_action do
    @user = current_user
  end

  # GET /account/users/:user_id/api_keys
  # GET /account/users/:user_id/api_keys.json
  def index
    @generated_api_key_secrets = @api_keys.where(encrypted_secret: nil).map do |api_key|
      [api_key.id, api_key.generate_encrypted_secret]
    end.to_h
  end

  # POST /account/users/:user_id/api_keys
  # POST /account/users/:user_id/api_keys.json
  def create
    respond_to do |format|
      if @api_key.save
        format.html { redirect_to account_user_api_keys_path(@user), notice: I18n.t('api_keys.notifications.created') }
        format.json { render :show, status: :created, location: [:account, @user, @api_key] }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @api_key.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /account/api_keys/:id
  # PATCH/PUT /account/api_keys/:id.json
  def update
    respond_to do |format|
      if @api_key.update(api_key_params)
        format.html { redirect_to [:account, @api_key], notice: I18n.t('api_keys.notifications.updated') }
        format.json { render :show, status: :ok, location: [:account, @api_key] }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @api_key.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /account/api_keys/:id
  # DELETE /account/api_keys/:id.json
  def destroy
    @api_key.revoke
    respond_to do |format|
      format.html { redirect_to [:account, @user, :api_keys], notice: I18n.t('api_keys.notifications.destroyed') }
      format.json { head :no_content }
    end
  end

  private
    # Never trust parameters from the scary internet, only allow the white list through.
    def api_key_params
      {}
    end
end
