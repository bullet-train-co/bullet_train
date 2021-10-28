class AddDoorkeeperApplicationToMemberships < ActiveRecord::Migration[6.1]
  def change
    add_reference :memberships, :platform_agent_of, null: true, foreign_key: {to_table: "oauth_applications"}
  end
end
