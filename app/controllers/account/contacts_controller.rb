class Account::ContactsController < Account::ApplicationController
  account_load_and_authorize_resource :contact, through: :client, through_association: :contacts

  # GET /account/clients/:client_id/contacts
  # GET /account/clients/:client_id/contacts.json
  def index
    delegate_json_to_api
  end

  # GET /account/contacts/:id
  # GET /account/contacts/:id.json
  def show
    delegate_json_to_api
  end

  # GET /account/clients/:client_id/contacts/new
  def new
  end

  # GET /account/contacts/:id/edit
  def edit
  end

  # POST /account/clients/:client_id/contacts
  # POST /account/clients/:client_id/contacts.json
  def create
    respond_to do |format|
      if @contact.save
        format.html { redirect_to [:account, @contact], notice: I18n.t("contacts.notifications.created") }
        format.json { render :show, status: :created, location: [:account, @contact] }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @contact.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /account/contacts/:id
  # PATCH/PUT /account/contacts/:id.json
  def update
    respond_to do |format|
      if @contact.update(contact_params)
        format.html { redirect_to [:account, @contact], notice: I18n.t("contacts.notifications.updated") }
        format.json { render :show, status: :ok, location: [:account, @contact] }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @contact.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /account/contacts/:id
  # DELETE /account/contacts/:id.json
  def destroy
    @contact.destroy
    respond_to do |format|
      format.html { redirect_to [:account, @client, :contacts], notice: I18n.t("contacts.notifications.destroyed") }
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
