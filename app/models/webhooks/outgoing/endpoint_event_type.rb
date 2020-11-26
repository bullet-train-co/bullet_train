class Webhooks::Outgoing::EndpointEventType < ApplicationRecord
  belongs_to :endpoint
  belongs_to :event_type
end
