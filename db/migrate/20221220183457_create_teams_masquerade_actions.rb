class CreateTeamsMasqueradeActions < ActiveRecord::Migration[7.0]
  def change
    create_table :teams_masquerade_actions do |t|
      t.references :team, null: false, foreign_key: true
      t.datetime :started_at
      t.datetime :completed_at
      t.integer :target_count
      t.integer :performed_count, default: 0
      t.datetime :scheduled_for
      t.string :sidekiq_jid
      t.references :created_by, null: false, foreign_key: {to_table: "users"}, index: {name: "index_teams_masquerades_on_created_by_id"}
      t.references :approved_by, null: true, foreign_key: {to_table: "users"}, index: {name: "index_teams_masquerades_on_approved_by_id"}

      t.timestamps
    end
  end
end
