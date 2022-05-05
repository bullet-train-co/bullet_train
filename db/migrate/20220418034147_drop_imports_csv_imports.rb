class DropImportsCsvImports < ActiveRecord::Migration[7.0]
  def change
    drop_table :imports_csv_imports
  end
end
