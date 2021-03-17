module Webhooks::Outgoing::IssuingModel
  extend ActiveSupport::Concern

  # define relationships.
  included do
    after_create :generate_created_webhook
    after_update :generate_updated_webhook
    after_destroy :generate_deleted_webhook
    has_many :webhooks_outgoing_events, as: :subject, class_name: "Webhooks::Outgoing::Event", dependent: :nullify
  end

  # define class methods.
  module ClassMethods
  end

  def generate_webhook(action)
    # we can only generate webhooks for objects that return their team.
    return unless respond_to? :team

    # we only generate a webhook for event types that are defined in the database.
    # this is what allows users to filter which webhooks they receive, if they want to.
    # however, even if they're not filtering, we only deliver webhooks that are
    # defined in this table.
    event_type = Webhooks::Outgoing::EventType.find_by(name: "#{self.class.name.underscore}.#{action}")
    if event_type && team
      webhook = team.webhooks_outgoing_events.create(event_type: event_type, subject: self, body: as_json)
      webhook.deliver
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
