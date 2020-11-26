class Api::V1::Memberships::Reassignments::ScaffoldingCompletelyConcreteTangibleThingsReassignmentsController < Api::V1::AuthenticatedController
  account_load_and_authorize_resource :scaffolding_completely_concrete_tangible_things_reassignment, through: :membership, through_association: :reassignments_scaffolding_completely_concrete_tangible_things_reassignments

  def serializer
    Api::V1::Memberships::Reassignments::ScaffoldingCompletelyConcreteTangibleThingsReassignmentSerializer
  end

  # GET /api/v1/membership/1/reassignments/scaffolding_completely_concrete_tangible_things_reassignments
  # GET /api/v1/membership/1/reassignments/scaffolding_completely_concrete_tangible_things_reassignments.json
  def index
    render json: @scaffolding_completely_concrete_tangible_things_reassignments, each_serializer: serializer
  end

  # GET /api/v1/scaffolding_completely_concrete_tangible_things_reassignments/1
  # GET /api/v1/scaffolding_completely_concrete_tangible_things_reassignments/1.json
  def show
    render json: @scaffolding_completely_concrete_tangible_things_reassignment, serializer: serializer
  end

  # POST /api/v1/membership/1/reassignments/scaffolding_completely_concrete_tangible_things_reassignments
  # POST /api/v1/membership/1/reassignments/scaffolding_completely_concrete_tangible_things_reassignments.json
  def create
    if @scaffolding_completely_concrete_tangible_things_reassignment.save
      render json: @scaffolding_completely_concrete_tangible_things_reassignment, status: :created, location: [:api, :v1, @membership, :reassignments_scaffolding_completely_concrete_tangible_things_reassignments], serializer: serializer
    else
      render json: @scaffolding_completely_concrete_tangible_things_reassignment.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /api/v1/memberships/reassignments/scaffolding_completely_concrete_tangible_things_reassignments/1
  # PATCH/PUT /api/v1/memberships/reassignments/scaffolding_completely_concrete_tangible_things_reassignments/1.json
  def update
    if @scaffolding_completely_concrete_tangible_things_reassignment.update(scaffolding_completely_concrete_tangible_things_reassignment_params)
      render json: @scaffolding_completely_concrete_tangible_things_reassignment, status: :ok, location: [:api, :v1, @scaffolding_completely_concrete_tangible_things_reassignment], serializer: serializer
    else
      render json: @scaffolding_completely_concrete_tangible_things_reassignment.errors, status: :unprocessable_entity
    end
  end

  # DELETE /api/v1/memberships/reassignments/scaffolding_completely_concrete_tangible_things_reassignments/1
  # DELETE /api/v1/memberships/reassignments/scaffolding_completely_concrete_tangible_things_reassignments/1.json
  def destroy
    @scaffolding_completely_concrete_tangible_things_reassignment.destroy
  end

  private

    # Never trust parameters from the scary internet, only allow the white list through.
    def scaffolding_completely_concrete_tangible_things_reassignment_params
      strong_params = params.require(:memberships_reassignments_scaffolding_completely_concrete_tangible_things_reassignment).permit(
        :membership_ids,
        # 🚅 super scaffolding will insert new fields above this line.
        # 🚅 super scaffolding will insert new arrays above this line.
      )

      # 🚅 super scaffolding will insert processing for new fields above this line.

      strong_params
    end
end
