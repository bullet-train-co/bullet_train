class MigrateEventTypeIdsOnWebhooksOutgoingEndpoints < ActiveRecord::Migration[6.1]
  def change
    Webhooks::Outgoing::Endpoint.find_each do |endpoint|
      event_type_ids = ActiveRecord::Base.connection.execute("SELECT * FROM webhooks_outgoing_endpoint_event_types JOIN webhooks_outgoing_event_types ON webhooks_outgoing_endpoint_event_types.event_type_id = webhooks_outgoing_event_types.id WHERE endpoint_id = #{endpoint.id}").to_a.map { |result| result.dig("name") }
      endpoint.update(event_type_ids: event_type_ids)
    end
  end
end
