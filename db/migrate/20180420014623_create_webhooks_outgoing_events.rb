class CreateWebhooksOutgoingEvents < ActiveRecord::Migration[5.2]
  def change
    create_table :webhooks_outgoing_events do |t|
      t.integer :event_type_id
      t.integer :subject_id
      t.string :subject_type
      t.jsonb :data

      t.timestamps
    end
  end
end
