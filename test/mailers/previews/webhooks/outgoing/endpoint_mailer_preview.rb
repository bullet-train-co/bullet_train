class Webhooks::Outgoing::EndpointMailerPreview < ActionMailer::Preview
  def deactivation_limit_reached
    endpoint = Webhooks::Outgoing::Endpoint.last ||
      Webhooks::Outgoing::Endpoint.new(
        team: Team.first,
        name: "Test Endpoint",
        url: "https://example.com/webhook",
        event_type_ids: ["contact.updated"]
      )
    Webhooks::Outgoing::EndpointMailer.deactivation_limit_reached endpoint
  end

  def deactivated
    endpoint = Webhooks::Outgoing::Endpoint.last ||
      Webhooks::Outgoing::Endpoint.new(
        team: Team.first,
        name: "Test Endpoint",
        url: "https://example.com/webhook",
        event_type_ids: ["contact.updated"]
      )
    Webhooks::Outgoing::EndpointMailer.deactivated endpoint
  end
end
