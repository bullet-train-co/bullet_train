class Webhooks::Outgoing::EndpointMailer < ApplicationMailer
  def deactivation_limit_reached(endpoint)
    @endpoint = endpoint
    @values = {
      endpoint_name: @endpoint.name,
      endpoint_events: @endpoint.event_type_ids.join(", "),
      cta_url: account_webhooks_outgoing_endpoint_url(@endpoint)
    }

    mail(
      to: @endpoint.team.users.map(&:email),
      subject: t(".subject", **@values)
    )
  end

  def deactivated(endpoint)
    @endpoint = endpoint
    @values = {
      endpoint_name: @endpoint.name,
      endpoint_events: @endpoint.event_type_ids.join(", "),
      cta_url: account_webhooks_outgoing_endpoint_url(@endpoint)
    }

    mail(
      to: @endpoint.team.users.map(&:email),
      subject: t(".subject", **@values)
    )
  end
end
