class Admin::Teams::MasqueradeActionsController < Admin::ApplicationController
  account_load_and_authorize_resource :masquerade_action, through: :team, through_association: :masquerade_actions, member_actions: [:approve]

  # GET /admin/teams/:team_id/masquerade_actions
  # GET /admin/teams/:team_id/masquerade_actions.json
  def index
    redirect_to [:admin, @team]
  end

  # GET /admin/teams/masquerade_actions/:id
  # GET /admin/teams/masquerade_actions/:id.json
  def show
  end

  # GET /admin/teams/:team_id/masquerade_actions/new
  def new
  end

  # GET /admin/teams/masquerade_actions/:id/edit
  def edit
  end

  # POST /admin/teams/masquerade_actions/:id/approve
  def approve
    respond_to do |format|
      if @masquerade_action.approve_by(current_user)
        format.html { redirect_to [:admin, @team, :masquerade_actions], notice: I18n.t("teams/masquerade_actions.notifications.approved") }
        format.json { render :show, status: :ok, location: [:admin, @masquerade_action] }
      else
        format.html { render :show, status: :unprocessable_entity }
        format.json { render json: @masquerade_action.errors, status: :unprocessable_entity }
      end
    end
  end

  # POST /admin/teams/:team_id/masquerade_actions
  # POST /admin/teams/:team_id/masquerade_actions.json
  def create
    respond_to do |format|
      # TODO We should probably employ Current Attributes in Rails and set this in the model, so the same thing is
      # happening automatically when we create an action via the API endpoint as well.
      @masquerade_action.created_by = current_user

      if @masquerade_action.save
        format.html { redirect_to [:admin, @team], notice: I18n.t("teams/masquerade_actions.notifications.created") }
        format.json { render :show, status: :created, location: [:admin, @masquerade_action] }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @masquerade_action.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /admin/teams/masquerade_actions/:id
  # PATCH/PUT /admin/teams/masquerade_actions/:id.json
  def update
    respond_to do |format|
      if @masquerade_action.update(masquerade_action_params)
        format.html { redirect_to [:admin, @masquerade_action], notice: I18n.t("teams/masquerade_actions.notifications.updated") }
        format.json { render :show, status: :ok, location: [:admin, @masquerade_action] }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @masquerade_action.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /admin/teams/masquerade_actions/:id
  # DELETE /admin/teams/masquerade_actions/:id.json
  def destroy
    @masquerade_action.destroy
    respond_to do |format|
      format.html { redirect_to [:admin, @team, :masquerade_actions], notice: I18n.t("teams/masquerade_actions.notifications.destroyed") }
      format.json { head :no_content }
    end
  end

  private

  # Never trust parameters from the scary internet, only allow the white list through.
  def masquerade_action_params
    strong_params = params.require(:teams_masquerade_action).permit(
      :target_count,
      :performed_count,
      :created_by,
      :approved_by,
      :scheduled_for,
      :started_at,
      :completed_at,
      :delay,
      :emoji,
      # 🚅 super scaffolding will insert new fields above this line.
      # 🚅 super scaffolding will insert new arrays above this line.
    )

    assign_date_and_time(strong_params, :scheduled_for)
    assign_date_and_time(strong_params, :started_at)
    assign_date_and_time(strong_params, :completed_at)
    # 🚅 super scaffolding will insert processing for new fields above this line.

    strong_params
  end
end
