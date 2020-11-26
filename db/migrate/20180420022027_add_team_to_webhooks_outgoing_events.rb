class AddTeamToWebhooksOutgoingEvents < ActiveRecord::Migration[5.2]
  def change
    add_reference :webhooks_outgoing_events, :team, foreign_key: true
  end
end
