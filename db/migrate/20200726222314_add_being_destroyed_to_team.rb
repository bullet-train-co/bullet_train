class AddBeingDestroyedToTeam < ActiveRecord::Migration[6.0]
  def change
    add_column :teams, :being_destroyed, :boolean
  end
end
