class AddTeamToOauthApplications < ActiveRecord::Migration[6.1]
  def change
    add_reference :oauth_applications, :team, null: false, foreign_key: true
  end
end
