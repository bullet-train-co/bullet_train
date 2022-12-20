class Admin::Ability
  include CanCan::Ability

  def initialize(user)
    if user.present?

      # ❌ Don't merge this.
      can :manage, Application
      can :manage, Team


    end
  end
end
