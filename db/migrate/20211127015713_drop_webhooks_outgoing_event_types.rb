class DropWebhooksOutgoingEventTypes < ActiveRecord::Migration[6.1]
  def up
    drop_table :webhooks_outgoing_event_types
  end

  def down
    raise ActiveRecord::IrreversibleMigration
  end
end
