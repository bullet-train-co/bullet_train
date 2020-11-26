# this is the policy used for rails admin, which is disabled by default.
class Admin::Ability
  include CanCan::Ability

  def initialize(user)
    if user&.developer?
      can :manage, :all
    end
  end
end
