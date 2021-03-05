class AddAddedByToMembership < ActiveRecord::Migration[6.0]
  def change
    add_reference :memberships, :added_by, null: true, foreign_key: {to_table: :memberships}
  end
end
