class Account::JobsController < Account::ApplicationController
  account_load_and_authorize_resource :job, through: :department, through_association: :jobs

  # GET /account/departments/:department_id/jobs
  # GET /account/departments/:department_id/jobs.json
  def index
    delegate_json_to_api
  end

  # GET /account/jobs/:id
  # GET /account/jobs/:id.json
  def show
    delegate_json_to_api
  end

  # GET /account/departments/:department_id/jobs/new
  def new
  end

  # GET /account/jobs/:id/edit
  def edit
  end

  # POST /account/departments/:department_id/jobs
  # POST /account/departments/:department_id/jobs.json
  def create
    respond_to do |format|
      if @job.save
        format.html { redirect_to [:account, @job], notice: I18n.t("jobs.notifications.created") }
        format.json { render :show, status: :created, location: [:account, @job] }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @job.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /account/jobs/:id
  # PATCH/PUT /account/jobs/:id.json
  def update
    respond_to do |format|
      if @job.update(job_params)
        format.html { redirect_to [:account, @job], notice: I18n.t("jobs.notifications.updated") }
        format.json { render :show, status: :ok, location: [:account, @job] }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @job.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /account/jobs/:id
  # DELETE /account/jobs/:id.json
  def destroy
    @job.destroy
    respond_to do |format|
      format.html { redirect_to [:account, @department, :jobs], notice: I18n.t("jobs.notifications.destroyed") }
      format.json { head :no_content }
    end
  end

  private

  if defined?(Api::V1::ApplicationController)
    include strong_parameters_from_api
  end

  def process_params(strong_params)
    assign_select_options(strong_params, :resource_ids)
    # 🚅 super scaffolding will insert processing for new fields above this line.
  end
end
