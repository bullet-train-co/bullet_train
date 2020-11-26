class Api::V1::Scaffolding::CompletelyConcrete::TangibleThingsController < Api::V1::AuthenticatedController
  account_load_and_authorize_resource :tangible_thing, through: :absolutely_abstract_creative_concept, through_association: :completely_concrete_tangible_things

  def serializer
    Api::V1::Scaffolding::CompletelyConcrete::TangibleThingSerializer
  end

  # GET /api/v1/scaffolding/absolutely_abstract/creative_concept/1/completely_concrete/tangible_things
  # GET /api/v1/scaffolding/absolutely_abstract/creative_concept/1/completely_concrete/tangible_things.json
  def index
    render json: @tangible_things, each_serializer: serializer
  end

  # GET /api/v1/tangible_things/1
  # GET /api/v1/tangible_things/1.json
  def show
    render json: @tangible_thing, serializer: serializer
  end

  # POST /api/v1/scaffolding/absolutely_abstract/creative_concept/1/completely_concrete/tangible_things
  # POST /api/v1/scaffolding/absolutely_abstract/creative_concept/1/completely_concrete/tangible_things.json
  def create
    if @tangible_thing.save
      render json: @tangible_thing, status: :created, location: [:api, :v1, @absolutely_abstract_creative_concept, :completely_concrete_tangible_things], serializer: serializer
    else
      render json: @tangible_thing.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /api/v1/scaffolding/completely_concrete/tangible_things/1
  # PATCH/PUT /api/v1/scaffolding/completely_concrete/tangible_things/1.json
  def update
    if @tangible_thing.update(tangible_thing_params)
      render json: @tangible_thing, status: :ok, location: [:api, :v1, @tangible_thing], serializer: serializer
    else
      render json: @tangible_thing.errors, status: :unprocessable_entity
    end
  end

  # DELETE /api/v1/scaffolding/completely_concrete/tangible_things/1
  # DELETE /api/v1/scaffolding/completely_concrete/tangible_things/1.json
  def destroy
    @tangible_thing.destroy
  end

  private

    # Never trust parameters from the scary internet, only allow the white list through.
    def tangible_thing_params
      strong_params = params.require(:scaffolding_completely_concrete_tangible_thing).permit(
        # 🚅 skip this section when scaffolding.
        :text_field_value,
        :button_value,
        :cloudinary_image_value,
        :date_field_value,
        :email_field_value,
        :password_field_value,
        :phone_field_value,
        :select_value,
        :super_select_value,
        :text_area_value,
        :trix_editor_value,
        :ckeditor_value,
        # 🚅 stop any skipping we're doing now.
        # 🚅 super scaffolding will insert new fields above this line.
        # 🚅 super scaffolding will insert new arrays above this line.
      )

      # 🚅 super scaffolding will insert processing for new fields above this line.

      strong_params
    end
end
