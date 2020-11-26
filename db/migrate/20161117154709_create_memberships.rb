class CreateMemberships < ActiveRecord::Migration[5.0]
  def change
    create_table :memberships do |t|
      t.references :user, foreign_key: true
      t.references :team, foreign_key: true
      t.boolean :admin

      t.timestamps
    end
  end
end
