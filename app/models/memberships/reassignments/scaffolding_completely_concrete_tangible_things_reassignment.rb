class Memberships::Reassignments::ScaffoldingCompletelyConcreteTangibleThingsReassignment < ApplicationRecord
  # 🚅 add concerns above.

  belongs_to :membership # this is the member being reassigned from.
  # 🚅 add belongs_to associations above.

  has_many :assignments
  has_many :memberships, through: :assignments # these are the members being reassigned to.
  # 🚅 add has_many associations above.

  # 🚅 add has_one associations above.

  # 🚅 add scopes above.

  # 🚅 add validations above.

  after_save :reassign
  # 🚅 add callbacks above.

  delegate :team, to: :membership
  # 🚅 add delegations above.

  def valid_memberships
    team.memberships.current_and_invited
  end

  def reassign
    membership.scaffolding_completely_concrete_tangible_things_assignments.each do |existing_assignment|
      memberships.each do |target_membership|
        unless existing_assignment.tangible_thing.memberships.include?(target_membership)
          existing_assignment.tangible_thing.memberships << target_membership
        end
      end
      existing_assignment.destroy
    end
  end
  # 🚅 add methods above.
end
