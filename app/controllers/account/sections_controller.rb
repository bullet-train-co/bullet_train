class Account::SectionsController < Account::ApplicationController
  account_load_and_authorize_resource :section, through: :page, through_association: :sections

  # GET /account/pages/:page_id/sections
  # GET /account/pages/:page_id/sections.json
  def index
    delegate_json_to_api
  end

  # GET /account/sections/:id
  # GET /account/sections/:id.json
  def show
    delegate_json_to_api
  end

  # GET /account/pages/:page_id/sections/new
  def new
  end

  # GET /account/sections/:id/edit
  def edit
  end

  # POST /account/pages/:page_id/sections
  # POST /account/pages/:page_id/sections.json
  def create
    respond_to do |format|
      if @section.save
        format.html { redirect_to [:account, @section], notice: I18n.t("sections.notifications.created") }
        format.json { render :show, status: :created, location: [:account, @section] }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @section.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /account/sections/:id
  # PATCH/PUT /account/sections/:id.json
  def update
    respond_to do |format|
      if @section.update(section_params)
        format.html { redirect_to [:account, @section], notice: I18n.t("sections.notifications.updated") }
        format.json { render :show, status: :ok, location: [:account, @section] }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @section.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /account/sections/:id
  # DELETE /account/sections/:id.json
  def destroy
    @section.destroy
    respond_to do |format|
      format.html { redirect_to [:account, @page, :sections], notice: I18n.t("sections.notifications.destroyed") }
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
