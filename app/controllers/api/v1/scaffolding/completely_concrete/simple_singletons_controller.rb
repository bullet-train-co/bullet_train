class Api::V1::Scaffolding::CompletelyConcrete::SimpleSingletonsController < Api::V1::ApplicationController
  account_load_and_authorize_resource :simple_singleton, through: :absolutely_abstract_creative_concept, through_association: :completely_concrete_simple_singletons

  # GET /api/v1/scaffolding/absolutely_abstract/creative_concepts/:absolutely_abstract_creative_concept_id/completely_concrete/simple_singletons
  def index
  end

  # GET /api/v1/scaffolding/completely_concrete/simple_singletons/:id
  def show
  end

  # POST /api/v1/scaffolding/absolutely_abstract/creative_concepts/:absolutely_abstract_creative_concept_id/completely_concrete/simple_singletons
  def create
    if @simple_singleton.save
      render :show, status: :created, location: [:api, :v1, @simple_singleton]
    else
      render json: @simple_singleton.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /api/v1/scaffolding/completely_concrete/simple_singletons/:id
  def update
    if @simple_singleton.update(simple_singleton_params)
      render :show
    else
      render json: @simple_singleton.errors, status: :unprocessable_entity
    end
  end

  # DELETE /api/v1/scaffolding/completely_concrete/simple_singletons/:id
  def destroy
    @simple_singleton.destroy
  end

  private

  module StrongParameters
    # Only allow a list of trusted parameters through.
    def simple_singleton_params
      strong_params = params.require(:scaffolding_completely_concrete_simple_singleton).permit(
        *permitted_fields,
        :name,
        # 🚅 super scaffolding will insert new fields above this line.
        *permitted_arrays,
        # 🚅 super scaffolding will insert new arrays above this line.
      )

      process_params(strong_params)

      strong_params
    end
  end

  include StrongParameters
end
