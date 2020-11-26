class RenameThings < ActiveRecord::Migration[5.2]
  def change
    rename_table :things, :scaffolding_things
  end
end
