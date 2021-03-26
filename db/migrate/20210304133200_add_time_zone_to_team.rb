class AddTimeZoneToTeam < ActiveRecord::Migration[6.1]
  def change
    add_column :teams, :time_zone, :string
  end
end
