[
  Scaffolding::AbsolutelyAbstract::CreativeConcept,
  Scaffolding::CompletelyConcrete::TangibleThing,
  Oauth::StripeAccount,
  Invitation,
  Membership,
  MembershipRole
].each do |model_class|
  ["created", "updated", "deleted"].each do |action|
    Webhooks::Outgoing::EventType.find_or_create_by(name: "#{model_class.name.underscore}.#{action}")
  end
end
