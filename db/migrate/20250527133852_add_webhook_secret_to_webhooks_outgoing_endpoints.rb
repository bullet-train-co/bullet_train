class AddWebhookSecretToWebhooksOutgoingEndpoints < ActiveRecord::Migration[8.0]
  def up
    add_column :webhooks_outgoing_endpoints, :webhook_secret, :string

    total_count = Webhooks::Outgoing::Endpoint.count
    puts "Backfilling webhook_secret for #{total_count} endpoints..."

    Webhooks::Outgoing::Endpoint.unscoped.in_batches(of: 1000).each_with_index do |batch, index|
      batch.each do |endpoint|
        endpoint.update_column(:webhook_secret, SecureRandom.hex(32))
      end

      puts "Processed batch #{index + 1}, #{batch.size} records (#{[1000 * (index + 1), total_count].min}/#{total_count})"
    end

    change_column_null :webhooks_outgoing_endpoints, :webhook_secret, false
  end

  def down
    remove_column :webhooks_outgoing_endpoints, :webhook_secret
  end
end
