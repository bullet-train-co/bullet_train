class CreateSites < ActiveRecord::Migration[7.0]
  def change
    create_table :sites do |t|
      t.references :team, null: false, foreign_key: true
      t.string :name
      t.text :url

      t.timestamps
    end
  end
end
