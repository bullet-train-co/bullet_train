class CreateJobs < ActiveRecord::Migration[7.1]
  def change
    create_table :jobs do |t|
      t.references :department, null: false, foreign_key: true
      t.string :name
      t.text :description

      t.timestamps
    end
  end
end
