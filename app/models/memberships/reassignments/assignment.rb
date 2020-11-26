class Memberships::Reassignments::Assignment < ApplicationRecord
  belongs_to :scaffolding_completely_concrete_tangible_things_reassignment, class_name: 'Memberships::Reassignments::ScaffoldingCompletelyConcreteTangibleThingsReassignment'
  belongs_to :membership

  validate :validate_membership

  def validate_membership
    unless scaffolding_completely_concrete_tangible_things_reassignment.valid_memberships.include?(membership)
      errors.add(:membership, :invalid)
    end
  end
end
