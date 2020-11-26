class AddTeamToThing < ActiveRecord::Migration[5.1]
  def change
    add_reference :things, :team, foreign_key: true
  end
end
