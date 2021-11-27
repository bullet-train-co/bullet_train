class MigrateEventTypesOnWebhooksOutgoingEvents < ActiveRecord::Migration[6.1]
  def up
    Webhooks::Outgoing::Event.find_each do |event|
      event.update_column(:event_type_id, event.payload.dig("event_type"))
    end
  end

  def down
  end
end
