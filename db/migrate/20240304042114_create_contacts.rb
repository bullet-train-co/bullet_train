class CreateContacts < ActiveRecord::Migration[7.1]
  def change
    create_table :contacts do |t|
      t.references :client, null: false, foreign_key: true
      t.string :first_name
      t.string :last_name
      t.string :email
      t.text :notes

      t.timestamps
    end
  end
end
