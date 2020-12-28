class Ability
  include CanCan::Ability

  class UserPermissionCachingDecorator < SimpleDelegator
    CACHEABLE_METHODS = [

      # all of the following should be invalidated anytime a membership for a given user is created, updated, or
      # destroyed, or anytime a team they're a member of has their team's membership on another team created, updated,
      # or destroyed.
      :team_ids,
      :administrating_team_ids,

    ]

    # we need to unwrap the decorator when generating the ability cache
    # adding a method for that unwrapping makes that code easier to read.
    def user
      __getobj__
    end

    def generate_ability_cache
      CACHEABLE_METHODS.map { |key| [key.to_s, user.send(key)] }.to_h
    end

    def populate_ability_cache
      update_column(:ability_cache, generate_ability_cache)
    end

    def method_missing(m, *args, &block)
      if CACHEABLE_METHODS.include?(m)
        populate_ability_cache unless ability_cache && ability_cache.keys.include?(m.to_s)
        ability_cache[m.to_s]
      else
        super(m, *args, &block)
      end
    end
  end

  def initialize(user)

    if user.present?

      # we've implemented some caching of abilities to improve response times.
      user = Ability::UserPermissionCachingDecorator.new(user)

      # TODO is this even used?
      can :dashboard, User, user_id: user.id

      # INDIVIDUAL USER PERMISSIONS.
      can :manage, User, id: user.id
      can :manage, ApiKey, user_id: user.id, revoked_at: nil

      # TEAM ADMINISTRATOR PERMISSIONS.
      # get a list of team ids this user is an administrator for.
      can :manage, Team, id: user.administrating_team_ids
      can :manage, Membership, team_id: user.administrating_team_ids
      can :destroy, Membership, user_id: user.id

      # TEAM MEMBER PERMISSIONS.
      can :read, Team, id: user.team_ids
      can :create, Team

      # we don't let people edit invitations because admins have an option to
      # pass on administrative permissions to other users, but regular users
      # could edit an invitation like that and hijack the admin permissions.
      can [:index, :show], Membership, team_id: user.team_ids
      can [:read, :create, :destroy], Invitation, team_id: user.team_ids

      # outgoing webhooks.
      can :manage, Webhooks::Outgoing::Endpoint, {team: {id: user.team_ids}}
      can :read, Webhooks::Outgoing::Delivery, {endpoint: {team: {id: user.team_ids}}}
      can :read, Webhooks::Outgoing::DeliveryAttempt, {delivery: {endpoint: {team: {id: user.team_ids}}}}
      can :read, Webhooks::Outgoing::Event, {team: {id: user.team_ids}}

      # the super scaffolding objects.
      can :manage, Scaffolding::CompletelyConcrete::TangibleThing, {absolutely_abstract_creative_concept: {team: {id: user.team_ids}}}
      can :manage, Scaffolding::AbsolutelyAbstract::CreativeConcept, {team: {id: user.team_ids}}
      can :manage, Memberships::Reassignments::ScaffoldingCompletelyConcreteTangibleThingsReassignment, membership: {team_id: user.team_ids}

      # we only disable editing by default, because by default there are no settings for oauth accounts.
      # however, if you've added editable settings for your oauth integrations, you should remove the `cannot`
      # statement below the appropriate oauth models.

      if stripe_enabled?
        can :manage, Oauth::StripeAccount, team_id: user.team_ids
        # cannot :edit, Oauth::StripeAccount
      end

      # 🚅 super scaffolding will insert any new oauth providers above.

      # don't remove or edit the following comment or you'll break super scaffolding.
      # the following abilities were added by super scaffolding.

      if user.developer?
        # the following admin abilities were added by super scaffolding.
      end

    end

    # Define abilities for the passed in user here. For example:
    #
    #   user ||= User.new # guest user (not logged in)
    #   if user.admin?
    #     can :manage, :all
    #   else
    #     can :read, :all
    #   end
    #
    # The first argument to `can` is the action you are giving the user
    # permission to do.
    # If you pass :manage it will apply to every action. Other common actions
    # here are :read, :create, :update and :destroy.
    #
    # The second argument is the resource the user can perform the action on.
    # If you pass :all it will apply to every resource. Otherwise pass a Ruby
    # class of the resource.
    #
    # The third argument is an optional hash of conditions to further filter the
    # objects.
    # For example, here the user can only update published articles.
    #
    #   can :update, Article, :published => true
    #
    # See the wiki for details:
    # https://github.com/CanCanCommunity/cancancan/wiki/Defining-Abilities
  end
end
