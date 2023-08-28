# Api::V1::ApplicationController is in the starter repository and isn't
# needed for this package's unit tests, but our CI tests will try to load this
# class because eager loading is set to `true` when CI=true.
# We wrap this class in an `if` statement to circumvent this issue.
if defined?(Api::V1::ApplicationController)
  class Api::V1::SitesController < Api::V1::ApplicationController
    account_load_and_authorize_resource :site, through: :team, through_association: :sites

    # GET /api/v1/teams/:team_id/sites
    def index
    end

    # GET /api/v1/sites/:id
    def show
    end

    # POST /api/v1/teams/:team_id/sites
    def create
      if @site.save
        render :show, status: :created, location: [:api, :v1, @site]
      else
        render json: @site.errors, status: :unprocessable_entity
      end
    end

    # PATCH/PUT /api/v1/sites/:id
    def update
      if @site.update(site_params)
        render :show
      else
        render json: @site.errors, status: :unprocessable_entity
      end
    end

    # DELETE /api/v1/sites/:id
    def destroy
      @site.destroy
    end

    private

    module StrongParameters
      # Only allow a list of trusted parameters through.
      def site_params
        strong_params = params.require(:site).permit(
          *permitted_fields,
          :name,
          :url,
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
  class Api::V1::SitesController
  end
end
