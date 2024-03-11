class AddLockableToDeviseUsers < ActiveRecord::Migration[7.1]
  def up
    ## Lockable
    unless column_exists?(:users, :failed_attempts)
      # Only if lock strategy is :failed_attempts
      add_column :users, :failed_attempts, :integer, default: 0, null: false
    end

    unless column_exists?(:users, :unlock_token)
      # Only if unlock strategy is :email or :both
      add_column :users, :unlock_token, :string
    end

    unless column_exists?(:users, :locked_at)
      add_column :users, :locked_at, :datetime
    end

    add_index :users, :unlock_token, unique: true unless index_exists?(:users, :unlock_token)
  end

  def down
    remove_column :users, :failed_attempts
    remove_column :users, :unlock_token
    remove_column :users, :locked_at
  end
end
