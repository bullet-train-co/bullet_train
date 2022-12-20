class Admin::Ability
  include CanCan::Ability

  def initialize(user)
    if user&.developer?
      can [:read, :update], Application
      can [:read, :update], Team
      can [:read, :update], User
    end
  end
end
