class AddDepartmentIdToContacts < ActiveRecord::Migration[7.1]
  def change
    add_reference :contacts, :department, null: true, foreign_key: true
  end
end
