module Scaffolding::AbsolutelyAbstract::CreativeConcepts::ControllerSupport
  extend ActiveSupport::Concern

  def ensure_current_user_can_manage_creative_concept(creative_concept)
    unless can? :manage, creative_concept
      collaborator = creative_concept.collaborators.find_or_create_by(membership: current_membership)
      collaborator.roles << :admin
      collaborator.save
    end
  end
end
