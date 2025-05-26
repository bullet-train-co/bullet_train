class AddDeactivationFieldsToEndpoints < ActiveRecord::Migration[8.0]
  disable_ddl_transaction!

  def change
    add_column :webhooks_outgoing_endpoints, :deactivation_limit_reached_at, :datetime
    add_column :webhooks_outgoing_endpoints, :deactivated_at, :datetime
    add_index :webhooks_outgoing_endpoints, :deactivated_at, algorithm: :concurrently
  end
end
