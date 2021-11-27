class Webhooks::Outgoing::Event < ApplicationRecord
  include HasUuid
  belongs_to :team
  belongs_to :event_type, class_name: "Webhooks::Outgoing::EventType"
  belongs_to :subject, polymorphic: true
  has_many :deliveries, dependent: :destroy

  before_create do
    self.payload = generate_payload
  end

  def generate_payload
    {
      event_id: uuid,
      event_type: event_type_id,
      subject_id: subject_id,
      subject_type: subject_type,
      data: data
    }
  end

  def event_type_name
    payload.dig("event_type")
  end

  def endpoints
    team.webhooks_outgoing_endpoints.listening_for_event_type_id(event_type_id)
  end

  def deliver
    endpoints.each do |endpoint|
      unless endpoint.deliveries.where(event: self).any?
        endpoint.deliveries.create(event: self, endpoint_url: endpoint.url).deliver_async
      end
    end
  end

  def label_string
    short_uuid
  end
end
