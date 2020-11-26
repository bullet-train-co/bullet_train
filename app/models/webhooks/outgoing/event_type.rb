class Webhooks::Outgoing::EventType < ApplicationRecord
  has_many :endpoint_event_types, dependent: :destroy
  has_many :endpoints, through: :endpoint_event_types
  has_many :events, dependent: :destroy
end
