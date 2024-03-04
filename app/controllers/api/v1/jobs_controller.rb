# Api::V1::ApplicationController is in the starter repository and isn't
# needed for this package's unit tests, but our CI tests will try to load this
# class because eager loading is set to `true` when CI=true.
# We wrap this class in an `if` statement to circumvent this issue.
if defined?(Api::V1::ApplicationController)
  class Api::V1::JobsController < Api::V1::ApplicationController
    account_load_and_authorize_resource :job, through: :department, through_association: :jobs

    # GET /api/v1/departments/:department_id/jobs
    def index
    end

    # GET /api/v1/jobs/:id
    def show
    end

    # POST /api/v1/departments/:department_id/jobs
    def create
      if @job.save
        render :show, status: :created, location: [:api, :v1, @job]
      else
        render json: @job.errors, status: :unprocessable_entity
      end
    end

    # PATCH/PUT /api/v1/jobs/:id
    def update
      if @job.update(job_params)
        render :show
      else
        render json: @job.errors, status: :unprocessable_entity
      end
    end

    # DELETE /api/v1/jobs/:id
    def destroy
      @job.destroy
    end

    private

    module StrongParameters
      # Only allow a list of trusted parameters through.
      def job_params
        strong_params = params.require(:job).permit(
          *permitted_fields,
          :name,
          :description,
          :quoted_by_id,
          :project_manager_id,
          # 🚅 super scaffolding will insert new fields above this line.
          *permitted_arrays,
          resource_ids: [],
          # 🚅 super scaffolding will insert new arrays above this line.
        )

        process_params(strong_params)

        strong_params
      end
    end

    include StrongParameters
  end
else
  class Api::V1::JobsController
  end
end
