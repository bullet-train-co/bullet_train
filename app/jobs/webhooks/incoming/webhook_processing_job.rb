class Webhooks::Incoming::WebhookProcessingJob < ApplicationJob
  queue_as :default

  def perform(webhook)
    webhook.verify_and_process
  end
end
