class Webhooks::Outgoing::EndpointMailerPreview < ActionMailer::Preview
  def deactivation_limit_reached
    endpoint = Webhooks::Outgoing::Endpoint.last ||
      Webhooks::Outgoing::Endpoint.new(
        workspace: Workspace.first,
        name: "Test Endpoint",
        url: "https://example.com/webhook",
        event_type_ids: ["contact.updated"]
      )
    Webhooks::Outgoing::EndpointMailer.deactivation_limit_reached endpoint
  end
end
