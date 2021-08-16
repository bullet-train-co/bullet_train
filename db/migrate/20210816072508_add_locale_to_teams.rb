class AddLocaleToTeams < ActiveRecord::Migration[6.1]
  def change
    add_column :teams, :locale, :string
  end
end
