class Account::Scaffolding::AbsolutelyAbstract::CreativeConcepts::CollaboratorsController < Account::ApplicationController
  account_load_and_authorize_resource :collaborator, through: :creative_concept, through_association: :collaborators

  # GET /account/scaffolding/absolutely_abstract/creative_concepts/:creative_concept_id/collaborators
  # GET /account/scaffolding/absolutely_abstract/creative_concepts/:creative_concept_id/collaborators.json
  def index
    redirect_to [:account, @creative_concept]
  end

  # GET /account/scaffolding/absolutely_abstract/creative_concepts/collaborators/:id
  # GET /account/scaffolding/absolutely_abstract/creative_concepts/collaborators/:id.json
  def show
    redirect_to [:account, @creative_concept]
  end

  # GET /account/scaffolding/absolutely_abstract/creative_concepts/:creative_concept_id/collaborators/new
  def new
  end

  # GET /account/scaffolding/absolutely_abstract/creative_concepts/collaborators/:id/edit
  def edit
  end

  # POST /account/scaffolding/absolutely_abstract/creative_concepts/:creative_concept_id/collaborators
  # POST /account/scaffolding/absolutely_abstract/creative_concepts/:creative_concept_id/collaborators.json
  def create
    respond_to do |format|
      if @collaborator.save
        format.html { redirect_to [:account, @creative_concept, :collaborators], notice: I18n.t('scaffolding/absolutely_abstract/creative_concepts/collaborators.notifications.created') }
        format.json { render :show, status: :created, location: [:account, @collaborator] }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @collaborator.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /account/scaffolding/absolutely_abstract/creative_concepts/collaborators/:id
  # PATCH/PUT /account/scaffolding/absolutely_abstract/creative_concepts/collaborators/:id.json
  def update
    respond_to do |format|
      if @collaborator.update(collaborator_params)
        format.html { redirect_to [:account, @collaborator], notice: I18n.t('scaffolding/absolutely_abstract/creative_concepts/collaborators.notifications.updated') }
        format.json { render :show, status: :ok, location: [:account, @collaborator] }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @collaborator.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /account/scaffolding/absolutely_abstract/creative_concepts/collaborators/:id
  # DELETE /account/scaffolding/absolutely_abstract/creative_concepts/collaborators/:id.json
  def destroy
    @collaborator.destroy
    respond_to do |format|
      format.html { redirect_to [:account, @creative_concept, :collaborators], notice: I18n.t('scaffolding/absolutely_abstract/creative_concepts/collaborators.notifications.destroyed') }
      format.json { head :no_content }
    end
  end

  private
    # Never trust parameters from the scary internet, only allow the white list through.
    def collaborator_params
      strong_params = params.require(:scaffolding_absolutely_abstract_creative_concepts_collaborator).permit(
        :membership_id,
        # 🚅 super scaffolding will insert new fields above this line.
        roles: [],
        # 🚅 super scaffolding will insert new arrays above this line.
      )

      assign_checkboxes(strong_params, :roles)
      # 🚅 super scaffolding will insert processing for new fields above this line.

      strong_params
    end
end
