require "pry"

class Api::V1::TeamsController < Api::V1::ApplicationController
  
  def index
    @teams = Team.all
  end

  def show
    @team = Team.find(params[:id])
  end

  def update
    binding.pry
  end

  def team_params
    strong_params = params.require(:team).permit(
      :name,
      :time_zone,
      :locale,
    )
  end
end