class Ability
  include CanCan::Ability

  class UserPermissionCachingDecorator < SimpleDelegator
    CACHEABLE_METHODS = [

      # all of the following should be invalidated anytime a membership for a given user is created, updated, or
      # destroyed, or anytime a team they're a member of has their team's membership on another team created, updated,
      # or destroyed.
      :team_ids,
      :administrating_team_ids,
      :admin_scaffolding_absolutely_abstract_creative_concepts_ids,
      :editor_scaffolding_absolutely_abstract_creative_concepts_ids,
      :viewer_scaffolding_absolutely_abstract_creative_concepts_ids,

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

    def method_missing(method_name, *args, &block)
      if CACHEABLE_METHODS.include?(method_name)
        populate_ability_cache unless ability_cache&.key?(method_name.to_s)
        ability_cache[method_name.to_s]
      else
        super(method_name, *args, &block)
      end
    end

    def respond_to_missing?(method_name, include_private = false)
      CACHEABLE_METHODS.include?(method_name) || super
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
      can :manage, Webhooks::Outgoing::Endpoint, team: {id: user.team_ids}
      can :read, Webhooks::Outgoing::Delivery, endpoint: {team: {id: user.team_ids}}
      can :read, Webhooks::Outgoing::DeliveryAttempt, delivery: {endpoint: {team: {id: user.team_ids}}}
      can :read, Webhooks::Outgoing::Event, team: {id: user.team_ids}

      # the super scaffolding objects.

      # all team admins can read, create, update, and destroy all creative concepts on their team.
      can :manage, Scaffolding::AbsolutelyAbstract::CreativeConcept, team: {id: user.administrating_team_ids}

      # all team members can create new creative concepts.
      # this requires the controller making team members that aren't a team admin an admin of the creative concepts they create.
      can :create, Scaffolding::AbsolutelyAbstract::CreativeConcept, team: {id: user.team_ids}

      # admins and editors at the creative concept level can manage the creative concepts they've been added to.
      # this list of ids will be used again below when evaluating permissions for child objects.
      editable_creative_concept_ids = user.admin_scaffolding_absolutely_abstract_creative_concepts_ids + user.editor_scaffolding_absolutely_abstract_creative_concepts_ids
      can [:read, :update], Scaffolding::AbsolutelyAbstract::CreativeConcept, id: editable_creative_concept_ids

      # beside the team admins above, only admins at the creative concept level can actually delete the creative concept.
      can :destroy, Scaffolding::AbsolutelyAbstract::CreativeConcept, id: user.admin_scaffolding_absolutely_abstract_creative_concepts_ids

      # regular team members can only view creative concepts they've been assigned a viewer for.
      can :read, Scaffolding::AbsolutelyAbstract::CreativeConcept, id: user.viewer_scaffolding_absolutely_abstract_creative_concepts_ids

      # only admins (either team or creative concept level) can manage collaborators for creative concepts.
      can :manage, Scaffolding::AbsolutelyAbstract::CreativeConcepts::Collaborator, creative_concept: {team: {id: user.administrating_team_ids}}
      can :manage, Scaffolding::AbsolutelyAbstract::CreativeConcepts::Collaborator, creative_concept: {id: user.admin_scaffolding_absolutely_abstract_creative_concepts_ids}

      # team members can read, create, update, and destroy tangible things that belong to creative concepts they can edit.
      can :manage, Scaffolding::CompletelyConcrete::TangibleThing, absolutely_abstract_creative_concept: {team: {id: user.administrating_team_ids}}
      can :manage, Scaffolding::CompletelyConcrete::TangibleThing, absolutely_abstract_creative_concept: {id: editable_creative_concept_ids}

      # team members can read tangible things that belong to creative concepts they can read.
      can :read, Scaffolding::CompletelyConcrete::TangibleThing, absolutely_abstract_creative_concept: {id: user.viewer_scaffolding_absolutely_abstract_creative_concepts_ids}

      # we only disable editing by default, because by default there are no settings for oauth accounts.
      # however, if you've added editable settings for your oauth integrations, you should remove the `cannot`
      # statement below the appropriate oauth models.

      if stripe_enabled?
        can [:read, :create, :destroy], Oauth::StripeAccount, user_id: user.id
        can :manage, Integrations::StripeInstallation, team_id: user.team_ids
        can :destroy, Integrations::StripeInstallation, oauth_stripe_account: {user_id: user.id}
      end

      # 🚅 super scaffolding will insert any new oauth providers above.

      # don't remove or edit the following comment or you'll break super scaffolding.
      # the following abilities were added by super scaffolding.

      # all team admins can read, create, update, and destroy all Doorkeeper applications on their team.
      can :manage, Doorkeeper::Application, team_id: user.administrating_team_ids

      # regular team members can only view Doorkeeper applications.
      can :read, Doorkeeper::Application, team_id: user.team_ids

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
