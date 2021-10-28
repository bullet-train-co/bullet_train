class Api::V1::Root < Api::Base
  include Api::V1::Defaults
  include Api::V1::LoadsAndAuthorizesApiResource

  version "v1"
  use ::WineBouncer::OAuth2

  rescue_from :all do |error|
    handle_api_error(error)
  end

  unless scaffolding_things_disabled?
    mount Api::V1::Scaffolding::AbsolutelyAbstract::CreativeConceptsEndpoint
    mount Api::V1::Scaffolding::CompletelyConcrete::TangibleThingsEndpoint
  end

  mount Api::V1::MeEndpoint
  mount Api::V1::TeamsEndpoint
  mount Api::V1::Webhooks::Outgoing::EndpointsEndpoint
  mount Api::V1::Webhooks::Outgoing::DeliveriesEndpoint
  mount Api::V1::Webhooks::Outgoing::DeliveryAttemptsEndpoint
  # 🚅 super scaffolding will mount new endpoints above this line.

  route :any, "*path" do
    raise StandardError, "Unable to find API endpoint"
  end
end
