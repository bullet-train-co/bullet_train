class Account::DepartmentsController < Account::ApplicationController
  account_load_and_authorize_resource :department, through: :team, through_association: :departments

  # GET /account/teams/:team_id/departments
  # GET /account/teams/:team_id/departments.json
  def index
    delegate_json_to_api
  end

  # GET /account/departments/:id
  # GET /account/departments/:id.json
  def show
    delegate_json_to_api
  end

  # GET /account/teams/:team_id/departments/new
  def new
  end

  # GET /account/departments/:id/edit
  def edit
  end

  # POST /account/teams/:team_id/departments
  # POST /account/teams/:team_id/departments.json
  def create
    respond_to do |format|
      if @department.save
        format.html { redirect_to [:account, @department], notice: I18n.t("departments.notifications.created") }
        format.json { render :show, status: :created, location: [:account, @department] }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @department.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /account/departments/:id
  # PATCH/PUT /account/departments/:id.json
  def update
    respond_to do |format|
      if @department.update(department_params)
        format.html { redirect_to [:account, @department], notice: I18n.t("departments.notifications.updated") }
        format.json { render :show, status: :ok, location: [:account, @department] }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @department.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /account/departments/:id
  # DELETE /account/departments/:id.json
  def destroy
    @department.destroy
    respond_to do |format|
      format.html { redirect_to [:account, @team, :departments], notice: I18n.t("departments.notifications.destroyed") }
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
