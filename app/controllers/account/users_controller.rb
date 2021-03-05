class Account::UsersController < Account::ApplicationController
  load_and_authorize_resource

  before_action do
    # for magic locales.
    @child_object = @user
  end

  # GET /account/users/1/edit
  def edit
  end

  # GET /account/users/1
  def show
  end

  def updating_password?
    params[:user].key?(:password)
  end

  # PATCH/PUT /account/users/1
  # PATCH/PUT /account/users/1.json
  def update
    respond_to do |format|
      if updating_password? ? @user.update_with_password(user_params) : @user.update_without_password(user_params)
        # if you update your own user account, devise will normally kick you out, so we do this instead.
        bypass_sign_in current_user.reload
        format.html { redirect_to [:edit, :account, @user], notice: t("users.notifications.updated") }
        format.json { render :show, status: :ok, location: [:account, @user] }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  private

  # Never trust parameters from the scary internet, only allow the white list through.
  def user_params
    # TODO enforce permissions on updating the user's team name.
    params.require(:user).permit(
      :email,
      :first_name,
      :last_name,
      :time_zone,
      :current_password,
      :password,
      :password_confirmation,
      :profile_photo_id,
      # 🚅 super scaffolding will insert new fields above this line.
      current_team_attributes: [:name],
      # 🚅 super scaffolding will insert new arrays above this line.
    )

    # 🚅 super scaffolding will insert processing for new fields above this line.
  end
end
