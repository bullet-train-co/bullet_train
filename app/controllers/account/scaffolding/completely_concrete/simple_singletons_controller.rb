class Account::Scaffolding::CompletelyConcrete::SimpleSingletonsController < Account::ApplicationController
  account_load_and_authorize_resource :simple_singleton, through: :absolutely_abstract_creative_concept, through_association: :completely_concrete_simple_singletons

  # GET /account/scaffolding/absolutely_abstract/creative_concepts/:absolutely_abstract_creative_concept_id/completely_concrete/simple_singletons
  # GET /account/scaffolding/absolutely_abstract/creative_concepts/:absolutely_abstract_creative_concept_id/completely_concrete/simple_singletons.json
  def index
    delegate_json_to_api
  end

  # GET /account/scaffolding/completely_concrete/simple_singletons/:id
  # GET /account/scaffolding/completely_concrete/simple_singletons/:id.json
  def show
    delegate_json_to_api
  end

  # GET /account/scaffolding/absolutely_abstract/creative_concepts/:absolutely_abstract_creative_concept_id/completely_concrete/simple_singletons/new
  def new
  end

  # GET /account/scaffolding/completely_concrete/simple_singletons/:id/edit
  def edit
  end

  # POST /account/scaffolding/absolutely_abstract/creative_concepts/:absolutely_abstract_creative_concept_id/completely_concrete/simple_singletons
  # POST /account/scaffolding/absolutely_abstract/creative_concepts/:absolutely_abstract_creative_concept_id/completely_concrete/simple_singletons.json
  def create
    respond_to do |format|
      if @simple_singleton.save
        format.html { redirect_to [:account, @absolutely_abstract_creative_concept, :completely_concrete_simple_singletons], notice: I18n.t("scaffolding/completely_concrete/simple_singletons.notifications.created") }
        format.json { render :show, status: :created, location: [:account, @simple_singleton] }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @simple_singleton.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /account/scaffolding/completely_concrete/simple_singletons/:id
  # PATCH/PUT /account/scaffolding/completely_concrete/simple_singletons/:id.json
  def update
    respond_to do |format|
      if @simple_singleton.update(simple_singleton_params)
        format.html { redirect_to [:account, @simple_singleton], notice: I18n.t("scaffolding/completely_concrete/simple_singletons.notifications.updated") }
        format.json { render :show, status: :ok, location: [:account, @simple_singleton] }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @simple_singleton.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /account/scaffolding/completely_concrete/simple_singletons/:id
  # DELETE /account/scaffolding/completely_concrete/simple_singletons/:id.json
  def destroy
    @simple_singleton.destroy
    respond_to do |format|
      format.html { redirect_to [:account, @absolutely_abstract_creative_concept, :completely_concrete_simple_singletons], notice: I18n.t("scaffolding/completely_concrete/simple_singletons.notifications.destroyed") }
      format.json { head :no_content }
    end
  end

  private

  include strong_parameters_from_api

  def process_params(strong_params)
    # 🚅 super scaffolding will insert processing for new fields above this line.
  end
end
