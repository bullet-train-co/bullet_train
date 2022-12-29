class RemoveNullConstraintFromOauthApplications < ActiveRecord::Migration[7.0]
  def change
    change_column_null :oauth_applications, :team_id, true
  end
end
