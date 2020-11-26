class CreateWebhooksOutgoingEndpoints < ActiveRecord::Migration[5.2]
  def change
    create_table :webhooks_outgoing_endpoints do |t|
      t.references :team, foreign_key: true
      t.text :url

      t.timestamps
    end
  end
end
