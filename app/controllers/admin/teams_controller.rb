class Admin::TeamsController < Admin::ApplicationController
  account_load_and_authorize_resource :team, through: :application, through_association: :teams

  # GET /admin/applications/:application_id/teams
  # GET /admin/applications/:application_id/teams.json
  def index
    delegate_json_to_api
  end

  # GET /admin/teams/:id
  # GET /admin/teams/:id.json
  def show
    delegate_json_to_api
  end

  # GET /admin/applications/:application_id/teams/new
  def new
  end

  # GET /admin/teams/:id/edit
  def edit
  end

  # POST /admin/applications/:application_id/teams
  # POST /admin/applications/:application_id/teams.json
  def create
    respond_to do |format|
      if @team.save
        format.html { redirect_to [:admin, @application, :teams], notice: I18n.t("teams.notifications.created") }
        format.json { render :show, status: :created, location: [:admin, @team] }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @team.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /admin/teams/:id
  # PATCH/PUT /admin/teams/:id.json
  def update
    respond_to do |format|
      if @team.update(team_params)
        format.html { redirect_to [:admin, @team], notice: I18n.t("teams.notifications.updated") }
        format.json { render :show, status: :ok, location: [:admin, @team] }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @team.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /admin/teams/:id
  # DELETE /admin/teams/:id.json
  def destroy
    @team.destroy
    respond_to do |format|
      format.html { redirect_to [:admin, @application, :teams], notice: I18n.t("teams.notifications.destroyed") }
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
