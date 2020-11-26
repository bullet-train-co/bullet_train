class Account::DashboardController < Account::ApplicationController
  def index
    redirect_to account_teams_path
  end
end
