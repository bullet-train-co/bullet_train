class AddPlatformAgentToMembership < ActiveRecord::Migration[7.0]
  def change
    add_column :memberships, :platform_agent, :boolean, default: false
  end
end
