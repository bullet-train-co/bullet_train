class Account::TeamsController < Account::ApplicationController
  load_and_authorize_resource :team, class: "Team", prepend: true

  prepend_before_action do
    if params["action"] == "new"
      current_user.current_team = nil
    end
  end

  before_action :enforce_invitation_only, only: [:create]

  before_action do
    # for magic locales.
    @child_object = @team
  end

  # GET /teams
  # GET /teams.json
  def index
    # if a user doesn't have multiple teams, we try to simplify the team ui/ux
    # as much as possible. links to this page should go to the current team
    # dashboard. however, some other links to this page are actually in branch
    # logic and will not display at all. instead, users will be linked to the
    # "new team" page. (see the main account sidebar menu for an example of
    # this.)
    unless current_user.multiple_teams?
      redirect_to account_team_path(current_team)
    end
  end

  # POST /teams/1/switch
  def switch_to
    current_user.current_team = @team
    current_user.save
    redirect_to account_dashboard_path
  end

  # GET /teams/1
  # GET /teams/1.json
  def show
    # I don't think this is the best place to close the loop on the onboarding process, but practically speaking it's
    # the easiest place to implement this at the moment, because all the onboarding steps redirect here on success.
    if session[:after_onboarding_url].present?
      redirect_to session.delete(:after_onboarding_url)
    end

    current_user.current_team = @team
    current_user.save
  end

  # GET /teams/new
  def new
    render :new, layout: "devise"
  end

  # GET /teams/1/edit
  def edit
  end

  # POST /teams
  # POST /teams.json
  def create
    @team = Team.new(team_params)

    respond_to do |format|
      if @team.save

        # also make the creator of the team the default admin.
        @team.memberships.create(user: current_user, roles: [Role.admin])

        current_user.current_team = @team
        current_user.former_user = false
        current_user.save

        format.html { redirect_to [:account, @team], notice: I18n.t("teams.notifications.created") }
        format.json { render :show, status: :created, location: [:account, @team] }
      else
        format.html { render :new, layout: "devise" }
        format.json { render json: @team.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /teams/1
  # PATCH/PUT /teams/1.json
  def update
    respond_to do |format|
      if @team.update(team_params)
        format.html { redirect_to [:account, @team], notice: I18n.t("teams.notifications.updated") }
        format.json { render :show, status: :ok, location: [:account, @team] }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @team.errors, status: :unprocessable_entity }
      end
    end
  end

  # # DELETE /teams/1
  # # DELETE /teams/1.json
  # def destroy
  #   @team.destroy
  #   respond_to do |format|
  #     format.html { redirect_to account_teams_url, notice: 'Team was successfully destroyed.' }
  #     format.json { head :no_content }
  #   end
  # end

  private

  # Never trust parameters from the scary internet, only allow the white list through.
  def team_params
    params.require(:team).permit(
      :name,
      :time_zone,
      :locale,
      # 🚅 super scaffolding will insert new fields above this line.
      # 🚅 super scaffolding will insert new arrays above this line.
    )

    # 🚅 super scaffolding will insert processing for new fields above this line.
  end
end
