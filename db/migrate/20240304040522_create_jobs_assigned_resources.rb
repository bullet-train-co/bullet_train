class CreateJobsAssignedResources < ActiveRecord::Migration[7.1]
  def change
    create_table :jobs_assigned_resources do |t|
      t.references :job, null: false, foreign_key: true
      t.references :resource, null: false, foreign_key: {to_table: "memberships"}

      t.timestamps
    end
  end
end
