class Webhooks::Outgoing::Event < ApplicationRecord
  include HasUuid
  belongs_to :team
  belongs_to :event_type
  belongs_to :subject, polymorphic: true
  has_many :deliveries, dependent: :destroy

  before_create do
    self.payload = generate_payload
  end

  def generate_payload
    {
      event_id: uuid,
      event_type: event_type.try(:name),
      subject_id: subject_id,
      subject_type: subject_type,
      body: body
    }
  end

  def endpoints
    team.webhooks_outgoing_endpoints
      .joins("LEFT JOIN webhooks_outgoing_endpoint_event_types ON webhooks_outgoing_endpoint_event_types.endpoint_id = webhooks_outgoing_endpoints.id")
      .where("webhooks_outgoing_endpoint_event_types.event_type_id = ? OR webhooks_outgoing_endpoint_event_types.id IS NULL", event_type.id)
  end

  def deliver
    endpoints.each do |endpoint|
      unless endpoint.deliveries.where(event: self).any?
        endpoint.deliveries.create(event: self, endpoint_url: endpoint.url).deliver_async
      end
    end
  end

  def name
    uuid
  end
end
