class Admin::UsersController < Admin::ApplicationController
  account_load_and_authorize_resource :user, through: :application, through_association: :users

  # GET /admin/applications/:application_id/users
  # GET /admin/applications/:application_id/users.json
  def index
    delegate_json_to_api
  end

  # GET /admin/users/:id
  # GET /admin/users/:id.json
  def show
    delegate_json_to_api
  end

  # GET /admin/applications/:application_id/users/new
  def new
  end

  # GET /admin/users/:id/edit
  def edit
  end

  # POST /admin/applications/:application_id/users
  # POST /admin/applications/:application_id/users.json
  def create
    respond_to do |format|
      if @user.save
        format.html { redirect_to [:admin, @application, :users], notice: I18n.t("users.notifications.created") }
        format.json { render :show, status: :created, location: [:admin, @user] }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /admin/users/:id
  # PATCH/PUT /admin/users/:id.json
  def update
    respond_to do |format|
      if @user.update(user_params)
        format.html { redirect_to [:admin, @user], notice: I18n.t("users.notifications.updated") }
        format.json { render :show, status: :ok, location: [:admin, @user] }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /admin/users/:id
  # DELETE /admin/users/:id.json
  def destroy
    @user.destroy
    respond_to do |format|
      format.html { redirect_to [:admin, @application, :users], notice: I18n.t("users.notifications.destroyed") }
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
