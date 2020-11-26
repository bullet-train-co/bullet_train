class CreateWebhooksOutgoingEventTypes < ActiveRecord::Migration[5.2]
  def change
    create_table :webhooks_outgoing_event_types do |t|
      t.string :name

      t.timestamps
    end
  end
end
