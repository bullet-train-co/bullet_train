class Webhooks::Outgoing::DeliveryJob < ApplicationJob
  queue_as :default

  def perform(delivery)
    delivery.deliver
  end
end
