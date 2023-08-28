class CreatePages < ActiveRecord::Migration[7.0]
  def change
    create_table :pages do |t|
      t.references :site, null: false, foreign_key: true
      t.string :name

      t.timestamps
    end
  end
end
