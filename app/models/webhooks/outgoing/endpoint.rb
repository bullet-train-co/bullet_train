class Webhooks::Outgoing::Endpoint < ApplicationRecord
  belongs_to :team
  has_many :endpoint_event_types, dependent: :destroy
  has_many :event_types, through: :endpoint_event_types
  has_many :deliveries, dependent: :destroy
  has_many :events, -> { distinct }, through: :deliveries
end
