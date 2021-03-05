class RemovingLastTeamAdminException < RuntimeError
end

class MembershipRole < ApplicationRecord
  belongs_to :membership
  belongs_to :role
  delegate :team, to: :membership

  after_destroy do
    membership.invalidate_caches
  end

  before_destroy do
    if role.admin?
      unless membership.team.admin_memberships.count > 1
        unless membership.team.being_destroyed?
          raise RemovingLastTeamAdminException.new("You can't remove the last team admin.")
        end
      end
    end
  end
end
