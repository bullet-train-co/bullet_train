class Account::PagesController < Account::ApplicationController
  include SortableActions

  account_load_and_authorize_resource :page, through: :team, through_association: :pages

  # GET /account/teams/:team_id/pages
  # GET /account/teams/:team_id/pages.json
  def index
    delegate_json_to_api
  end

  # GET /account/pages/:id
  # GET /account/pages/:id.json
  def show
    delegate_json_to_api
  end

  # GET /account/teams/:team_id/pages/new
  def new
  end

  # GET /account/pages/:id/edit
  def edit
  end

  # POST /account/teams/:team_id/pages
  # POST /account/teams/:team_id/pages.json
  def create
    respond_to do |format|
      if @page.save
        format.html { redirect_to [:account, @page], notice: I18n.t("pages.notifications.created") }
        format.json { render :show, status: :created, location: [:account, @page] }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @page.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /account/pages/:id
  # PATCH/PUT /account/pages/:id.json
  def update
    respond_to do |format|
      if @page.update(page_params)
        format.html { redirect_to [:account, @page], notice: I18n.t("pages.notifications.updated") }
        format.json { render :show, status: :ok, location: [:account, @page] }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @page.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /account/pages/:id
  # DELETE /account/pages/:id.json
  def destroy
    @page.destroy
    respond_to do |format|
      format.html { redirect_to [:account, @team, :pages], notice: I18n.t("pages.notifications.destroyed") }
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
