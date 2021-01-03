class Api::V1::Scaffolding::AbsolutelyAbstract::CreativeConcepts::CollaboratorsController < Api::V1::AuthenticatedController
  account_load_and_authorize_resource :collaborator, through: :creative_concept, through_association: :collaborators

  def serializer
    Api::V1::Scaffolding::AbsolutelyAbstract::CreativeConcepts::CollaboratorSerializer
  end

  # GET /api/v1/scaffolding/absolutely_abstract/creative_concept/1/collaborators
  # GET /api/v1/scaffolding/absolutely_abstract/creative_concept/1/collaborators.json
  def index
    render json: @collaborators, each_serializer: serializer
  end

  # GET /api/v1/collaborators/1
  # GET /api/v1/collaborators/1.json
  def show
    render json: @collaborator, serializer: serializer
  end

  # POST /api/v1/scaffolding/absolutely_abstract/creative_concept/1/collaborators
  # POST /api/v1/scaffolding/absolutely_abstract/creative_concept/1/collaborators.json
  def create
    if @collaborator.save
      render json: @collaborator, status: :created, location: [:api, :v1, @creative_concept, :collaborators], serializer: serializer
    else
      render json: @collaborator.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /api/v1/scaffolding/absolutely_abstract/creative_concepts/collaborators/1
  # PATCH/PUT /api/v1/scaffolding/absolutely_abstract/creative_concepts/collaborators/1.json
  def update
    if @collaborator.update(collaborator_params)
      render json: @collaborator, status: :ok, location: [:api, :v1, @collaborator], serializer: serializer
    else
      render json: @collaborator.errors, status: :unprocessable_entity
    end
  end

  # DELETE /api/v1/scaffolding/absolutely_abstract/creative_concepts/collaborators/1
  # DELETE /api/v1/scaffolding/absolutely_abstract/creative_concepts/collaborators/1.json
  def destroy
    @collaborator.destroy
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

      # 🚅 super scaffolding will insert processing for new fields above this line.

      strong_params
    end
end
