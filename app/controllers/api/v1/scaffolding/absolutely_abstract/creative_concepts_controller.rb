class Api::V1::Scaffolding::AbsolutelyAbstract::CreativeConceptsController < Api::V1::AuthenticatedController
  include Scaffolding::AbsolutelyAbstract::CreativeConcepts::ControllerSupport

  account_load_and_authorize_resource :creative_concept, through: :team, through_association: :scaffolding_absolutely_abstract_creative_concepts

  def serializer
    Api::V1::Scaffolding::AbsolutelyAbstract::CreativeConceptSerializer
  end

  # GET /api/v1/team/1/scaffolding/absolutely_abstract/creative_concepts
  # GET /api/v1/team/1/scaffolding/absolutely_abstract/creative_concepts.json
  def index
    render json: @creative_concepts, each_serializer: serializer
  end

  # GET /api/v1/creative_concepts/1
  # GET /api/v1/creative_concepts/1.json
  def show
    render json: @creative_concept, serializer: serializer
  end

  # POST /api/v1/team/1/scaffolding/absolutely_abstract/creative_concepts
  # POST /api/v1/team/1/scaffolding/absolutely_abstract/creative_concepts.json
  def create

    # any user adding a creative concept should be able to manage it.
    ensure_current_user_can_manage_creative_concept @creative_concept

    if @creative_concept.save
      render json: @creative_concept, status: :created, location: [:api, :v1, @team, :scaffolding, :absolutely_abstract, :creative_concepts], serializer: serializer
    else
      render json: @creative_concept.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /api/v1/scaffolding/absolutely_abstract/creative_concepts/1
  # PATCH/PUT /api/v1/scaffolding/absolutely_abstract/creative_concepts/1.json
  def update
    if @creative_concept.update(creative_concept_params)
      render json: @creative_concept, status: :ok, location: [:api, :v1, @creative_concept], serializer: serializer
    else
      render json: @creative_concept.errors, status: :unprocessable_entity
    end
  end

  # DELETE /api/v1/scaffolding/absolutely_abstract/creative_concepts/1
  # DELETE /api/v1/scaffolding/absolutely_abstract/creative_concepts/1.json
  def destroy
    @creative_concept.destroy
  end

  private

    # Never trust parameters from the scary internet, only allow the white list through.
    def creative_concept_params
      strong_params = params.require(:scaffolding_absolutely_abstract_creative_concept).permit(
        :name,
        :description,
        # 🚅 super scaffolding will insert new fields above this line.
        # 🚅 super scaffolding will insert new arrays above this line.
      )

      # 🚅 super scaffolding will insert processing for new fields above this line.

      strong_params
    end
end
