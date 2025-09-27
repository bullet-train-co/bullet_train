# Api::V1::ApplicationController is in the starter repository and isn't
# needed for this package's unit tests, but our CI tests will try to load this
# class because eager loading is set to `true` when CI=true.
# We wrap this class in an `if` statement to circumvent this issue.
if defined?(Api::V1::ApplicationController)
  class Api::V1::PagesController < Api::V1::ApplicationController
    account_load_and_authorize_resource :page, through: :team, through_association: :pages

    # GET /api/v1/teams/:team_id/pages
    def index
    end

    # GET /api/v1/pages/:id
    def show
    end

    # POST /api/v1/teams/:team_id/pages
    def create
      if @page.save
        render :show, status: :created, location: [:api, :v1, @page]
      else
        render json: @page.errors, status: :unprocessable_entity
      end
    end

    # PATCH/PUT /api/v1/pages/:id
    def update
      if @page.update(page_params)
        render :show
      else
        render json: @page.errors, status: :unprocessable_entity
      end
    end

    # DELETE /api/v1/pages/:id
    def destroy
      @page.destroy
    end

    private

    module StrongParameters
      # Only allow a list of trusted parameters through.
      def page_params
        strong_params = params.require(:page).permit(
          *permitted_fields,
          :name,
          :path,
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
  class Api::V1::PagesController
  end
end
