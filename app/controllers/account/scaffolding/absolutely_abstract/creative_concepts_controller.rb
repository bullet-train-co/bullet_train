class Account::Scaffolding::AbsolutelyAbstract::CreativeConceptsController < Account::ApplicationController
  include Scaffolding::AbsolutelyAbstract::CreativeConcepts::ControllerSupport

  account_load_and_authorize_resource :creative_concept, through: :team, through_association: :scaffolding_absolutely_abstract_creative_concepts

  # GET /account/teams/:team_id/scaffolding/absolutely_abstract/creative_concepts
  # GET /account/teams/:team_id/scaffolding/absolutely_abstract/creative_concepts.json
  def index
    # since we're showing creative_concepts on the team show page by default,
    # we might as well just go there.
    # redirect_to [:account, @team]
  end

  # GET /account/scaffolding/absolutely_abstract/creative_concepts/:id
  # GET /account/scaffolding/absolutely_abstract/creative_concepts/:id.json
  def show
  end

  # GET /account/teams/:team_id/scaffolding/absolutely_abstract/creative_concepts/new
  def new
  end

  # GET /account/scaffolding/absolutely_abstract/creative_concepts/:id/edit
  def edit
  end

  # POST /account/teams/:team_id/scaffolding/absolutely_abstract/creative_concepts
  # POST /account/teams/:team_id/scaffolding/absolutely_abstract/creative_concepts.json
  def create
    respond_to do |format|
      if @creative_concept.save

        # any user adding a creative concept should be able to manage it.
        ensure_current_user_can_manage_creative_concept @creative_concept

        format.html { redirect_to [:account, @creative_concept], notice: I18n.t("scaffolding/absolutely_abstract/creative_concepts.notifications.created") }
        format.json { render :show, status: :created, location: [:account, @team, @creative_concept] }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @creative_concept.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /account/scaffolding/absolutely_abstract/creative_concepts/:id
  # PATCH/PUT /account/scaffolding/absolutely_abstract/creative_concepts/:id.json
  def update
    respond_to do |format|
      if @creative_concept.update(creative_concept_params)
        format.html { redirect_to [:account, @creative_concept], notice: I18n.t("scaffolding/absolutely_abstract/creative_concepts.notifications.updated") }
        format.json { render :show, status: :ok, location: [:account, @creative_concept] }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @creative_concept.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /account/scaffolding/absolutely_abstract/creative_concepts/:id
  # DELETE /account/scaffolding/absolutely_abstract/creative_concepts/:id.json
  def destroy
    @creative_concept.destroy
    respond_to do |format|
      format.html { redirect_to [:account, @team, :scaffolding, :absolutely_abstract, :creative_concepts], notice: I18n.t("scaffolding/absolutely_abstract/creative_concepts.notifications.destroyed") }
      format.json { head :no_content }
    end
  end

  private

  # Never trust parameters from the scary internet, only allow the white list through.
  def creative_concept_params
    params.require(:scaffolding_absolutely_abstract_creative_concept).permit(
      :name,
      :description,
      # 🚅 super scaffolding will insert new fields above this line.
      # 🚅 super scaffolding will insert new arrays above this line.
    )

    # 🚅 super scaffolding will insert processing for new fields above this line.
  end
end
