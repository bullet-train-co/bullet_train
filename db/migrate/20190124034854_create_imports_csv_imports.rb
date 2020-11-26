class CreateImportsCsvImports < ActiveRecord::Migration[5.2]
  def change
    create_table :imports_csv_imports do |t|
      t.string :type
      t.references :team, foreign_key: true
      t.integer :lines_count
      t.integer :processed_count, default: 0
      t.integer :rejected_count, default: 0
      t.text :logging_output, default: ""
      t.text :error_message
      t.text :rejected_lines, default: ""
      t.datetime :started_at
      t.datetime :estimated_finish_at
      t.datetime :completed_at
      t.datetime :failed_at

      t.timestamps
    end
  end
end
