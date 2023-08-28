# Api::V1::ApplicationController is in the starter repository and isn't
# needed for this package's unit tests, but our CI tests will try to load this
# class because eager loading is set to `true` when CI=true.
# We wrap this class in an `if` statement to circumvent this issue.
if defined?(Api::V1::ApplicationController)
  class Api::V1::SectionsController < Api::V1::ApplicationController
    account_load_and_authorize_resource :section, through: :page, through_association: :sections

    # GET /api/v1/pages/:page_id/sections
    def index
    end

    # GET /api/v1/sections/:id
    def show
    end

    # POST /api/v1/pages/:page_id/sections
    def create
      if @section.save
        render :show, status: :created, location: [:api, :v1, @section]
      else
        render json: @section.errors, status: :unprocessable_entity
      end
    end

    # PATCH/PUT /api/v1/sections/:id
    def update
      if @section.update(section_params)
        render :show
      else
        render json: @section.errors, status: :unprocessable_entity
      end
    end

    # DELETE /api/v1/sections/:id
    def destroy
      @section.destroy
    end

    private

    module StrongParameters
      # Only allow a list of trusted parameters through.
      def section_params
        strong_params = params.require(:section).permit(
          *permitted_fields,
          :title,
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
else
  class Api::V1::SectionsController
  end
end
