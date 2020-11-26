class Api::V1::TeamsController < Api::V1::AuthenticatedController
  load_and_authorize_resource :team

  def serializer
    Api::V1::TeamSerializer
  end

  # GET /api/v1/teams
  # GET /api/v1/teams.json
  def index
    render json: @teams, each_serializer: serializer
  end

  # GET /api/v1/teams/1
  # GET /api/v1/teams/1.json
  def show
    render json: @team, serializer: serializer
  end

  # POST /api/v1/teams
  # POST /api/v1/teams.json
  def create
    if @team.save
      render json: @team, status: :created, location: [:api, :v1, @team], serializer: serializer
    else
      render json: @team.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /api/v1/teams/1
  # PATCH/PUT /api/v1/teams/1.json
  def update
    if @team.update(team_params)
      render json: @team, status: :ok, location: [:api, :v1, @team], serializer: serializer
    else
      render json: @team.errors, status: :unprocessable_entity
    end
  end

  # DELETE /api/v1/teams/1
  # DELETE /api/v1/teams/1.json
  def destroy
    @team.destroy
  end

  private

    # Never trust parameters from the scary internet, only allow the white list through.
    def team_params
      strong_params = params.require(:team).permit(
        :name,
        # 🚅 super scaffolding will insert new fields above this line.
        # 🚅 super scaffolding will insert new arrays above this line.
      )
      
      # 🚅 super scaffolding will insert processing for new fields above this line.

      strong_params
    end
end
