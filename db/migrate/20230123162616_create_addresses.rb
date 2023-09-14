class CreateAddresses < ActiveRecord::Migration[7.0]
  def change
    create_table :addresses do |t|
      t.references :addressable, polymorphic: true, null: false
      t.string :address_one
      t.string :address_two
      t.string :city
      t.integer :region_id
      t.string :region_name
      t.integer :country_id
      t.string :postal_code

      t.timestamps
    end
  end
end
