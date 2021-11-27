module Webhooks::Outgoing::IssuingModel
  extend ActiveSupport::Concern

  # define relationships.
  included do
    after_commit :generate_created_webhook, on: [:create]
    after_commit :generate_updated_webhook, on: [:update]
    after_commit :generate_deleted_webhook, on: [:destroy]
    has_many :webhooks_outgoing_events, as: :subject, class_name: "Webhooks::Outgoing::Event", dependent: :nullify
  end

  # define class methods.
  module ClassMethods
  end

  def generate_webhook(action)
    # we can only generate webhooks for objects that return their team.
    return unless respond_to? :team

    # Try to find an event type definition for this action.
    event_type = Webhooks::Outgoing::EventType.find_by(id: "#{self.class.name.underscore}.#{action}")

    # If the event type is defined as one that people can be subscribed to,
    # and this object has a team where an associated outgoing webhooks endpoint could be registered.
    if event_type && team

      # Only generate an event record if an endpoint is actually listening for this event type.
      if team.webhooks_outgoing_endpoints.listening_for_event_type_id(event_type.id).any?
        data = "Api::V1::#{self.class.name}Serializer".constantize.new(self).serializable_hash[:data]
        webhook = team.webhooks_outgoing_events.create(event_type_id: event_type.id, subject: self, data: data)
        webhook.deliver
      end
    end
  end

  def generate_created_webhook
    generate_webhook("created")
  end

  def generate_updated_webhook
    generate_webhook("updated")
  end

  def generate_deleted_webhook
    return false unless respond_to?(:team)
    return false if team&.being_destroyed?
    generate_webhook("deleted")
  end
end
