class AddQuotedByIdToJobs < ActiveRecord::Migration[7.1]
  def change
    add_reference :jobs, :quoted_by, null: true, foreign_key: {to_table: "memberships"}
  end
end
