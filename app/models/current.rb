# See https://api.rubyonrails.org/classes/ActiveSupport/CurrentAttributes.html for details.
class Current < ActiveSupport::CurrentAttributes
  attribute :user, :team, :membership, :ability

  resets do
    Time.zone = nil
  end

  def user=(user)
    super

    if user
      Time.zone = user.time_zone
      self.ability = Ability.new(user)
    else
      Time.zone = nil
      self.ability = nil
    end

    update_membership
  end

  def team=(team)
    super
    update_membership
  end

  def update_membership
    self.membership = if user && team
      user.memberships.where(team: team)
    end
  end
end
