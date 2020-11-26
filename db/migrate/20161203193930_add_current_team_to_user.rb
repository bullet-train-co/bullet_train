class AddCurrentTeamToUser < ActiveRecord::Migration[5.0]
  def change
    add_column :users, :current_team_id, :integer
  end
end
