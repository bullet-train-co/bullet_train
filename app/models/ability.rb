class Ability
  include CanCan::Ability
  include Roles::Permit

  if billing_enabled?
    include Billing::AbilitySupport
  end

  def initialize(user)
    if user.present?

      # permit is a Bullet Train created "magic" method. It parses all the roles in `config/roles.yml` and automatically inserts the appropriate `can` method calls here
      permit user, through: :memberships, parent: :team
      permit user, through: :scaffolding_absolutely_abstract_creative_concepts_collaborators, parent: :creative_concept

      # INDIVIDUAL USER PERMISSIONS.
      can :manage, User, id: user.id
      can :destroy, Membership, user_id: user.id

      can :create, Team

      if stripe_enabled?
        can [:read, :create, :destroy], Oauth::StripeAccount, user_id: user.id
        can :manage, Integrations::StripeInstallation, team_id: user.team_ids
        can :destroy, Integrations::StripeInstallation, oauth_stripe_account: {user_id: user.id}
      end

      # 🚅 super scaffolding will insert any new oauth providers above.

      if billing_enabled?
        apply_billing_abilities user
      end

      if user.developer?
        # the following admin abilities were added by super scaffolding.
      end
    end
  end
end
