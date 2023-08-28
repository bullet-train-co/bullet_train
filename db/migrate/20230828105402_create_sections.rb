class CreateSections < ActiveRecord::Migration[7.0]
  def change
    create_table :sections do |t|
      t.references :page, null: false, foreign_key: true
      t.string :title

      t.timestamps
    end
  end
end
