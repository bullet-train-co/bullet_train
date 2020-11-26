class Account::Onboarding::UserEmailController < Account::ApplicationController
  layout 'devise'
  load_and_authorize_resource :class => "User"

  # this is because cancancan doesn't let us set the instance variable name above.
  before_action do
    @user = @user_email
  end

  # GET /users/1/edit
  def edit
    flash[:notice] = nil
    if @user.email_is_oauth_placeholder?
      @user.email = nil
    end
  end

  # PATCH/PUT /users/1
  # PATCH/PUT /users/1.json
  def update
    respond_to do |format|
      if @user.update(user_params)
        # if you update your own user account, devise will normally kick you out, so we do this instead.
        bypass_sign_in current_user.reload

        if !@user.email_is_oauth_placeholder?
          @user.send_welcome_email
          format.html { redirect_to account_team_path(@user.teams.first), notice: '' }
        else
          format.html {
            flash[:error] = I18n.t('global.notifications.all_fields_required')
            redirect_to edit_account_onboarding_user_detail_path (@user)
          }
        end

        format.json { render :show, status: :ok, location: [:account, @user] }
      else

        # this is just checking whether the error on the email field is taking the email
        # address is already taken.
        @email_taken = @user.errors.details[:email].select { |error| error[:error] == :taken }.any? rescue false

        format.html { render :edit }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  private

    # Never trust parameters from the scary internet, only allow the white list through.
    def user_params
      strong_params = params.require(:user).permit(
        :email,
        # 🚅 super scaffolding will insert new fields above this line.
        # 🚅 super scaffolding will insert new arrays above this line.
      )

      # 🚅 super scaffolding will insert processing for new fields above this line.

      strong_params
    end
end
