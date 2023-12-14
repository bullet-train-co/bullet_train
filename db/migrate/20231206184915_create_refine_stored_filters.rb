class CreateRefineStoredFilters < ActiveRecord::Migration[7.1]
  def change
    create_table :refine_stored_filters, if_not_exists: true do |t|
      t.json :state
      t.string "filter_type"
      t.string "name"
      t.timestamps
    end
  end
end
