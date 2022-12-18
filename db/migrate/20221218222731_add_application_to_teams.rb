class AddApplicationToTeams < ActiveRecord::Migration[7.0]
  def change
    add_reference :teams, :application, null: false, foreign_key: true, default: 1
  end
end
