class Account::Onboarding::UserDetailsController < Account::ApplicationController
  layout "devise"
  load_and_authorize_resource class: "User"

  # this is because cancancan doesn't let us set the instance variable name above.
  before_action do
    @user = @user_detail
  end

  # GET /users/1/edit
  def edit
    flash[:notice] = nil
  end

  # PATCH/PUT /users/1
  # PATCH/PUT /users/1.json
  def update
    respond_to do |format|
      if @user.update(user_params)
        # if you update your own user account, devise will normally kick you out, so we do this instead.
        bypass_sign_in current_user.reload

        if @user.details_provided?
          format.html { redirect_to account_team_path(@user.teams.first), notice: "" }
        else
          format.html {
            flash[:error] = I18n.t("global.notifications.all_fields_required")
            redirect_to edit_account_onboarding_user_detail_path(@user)
          }
        end

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
    permitted_attributes = [
      :first_name,
      :last_name,
      :time_zone,
      # 🚅 super scaffolding will insert new fields above this line.
    ]

    permitted_hash = {
      # 🚅 super scaffolding will insert new arrays above this line.
    }

    if can? :edit, @user.current_team
      permitted_hash[:current_team_attributes] = [:id, :name]
    end

    params.require(:user).permit(permitted_attributes, permitted_hash)

    # 🚅 super scaffolding will insert processing for new fields above this line.
  end
end
