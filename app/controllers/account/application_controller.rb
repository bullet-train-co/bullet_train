class Account::ApplicationController < ApplicationController
  include LoadsAndAuthorizesResource
  include Fields::SuperSelectSupport

  before_action :set_last_seen_at, if: proc {
    user_signed_in? && (current_user.last_seen_at.nil? || current_user.last_seen_at < 1.minute.ago)
  }

  # this is a template method called by LoadsAndAuthorizesResource.
  # it allows that module to understand what namespaces of a controller
  # are organizing the controllers, and which are organizing the models.
  def self.regex_to_remove_controller_namespace
    /^Account::/
  end

  # TODO 🍩 we need to figure out some way to get this extracted for sprinkles.
  # by default we use the 'account' layout, but we want to be able to disable the
  # layout entirely for polling updates.
  layout :calculate_layout
  def calculate_layout
    params["layoutless"] ? false : "account"
  end

  before_action :authenticate_user!
  before_action :set_paper_trail_whodunnit
  before_action :ensure_onboarding_is_complete

  # many times the team will already be loaded by account_load_and_authorize_resource,
  # so we don't need any of this logic. however, there are a handful of account pages
  # where the instance variable won't be already set, so we have some other methods
  # for populating it.
  def load_team
    # if account_load_and_authorize_resource couldn't load the team.
    unless @team

      # however, the most likely case is that we want to fall back to whatever
      # the last team was the user interacted with.
      if current_user.try(:current_team)
        @team = current_user.current_team

      end

    end

    # if the currently loaded team is saved to the database, make that the
    # user's new current team.
    if @team.try(:persisted?)
      if can? :show, @teams
        current_user.update_column(:current_team_id, @team.id)
      end
    end
  end

  def adding_user_email?
    is_a?(Account::Onboarding::UserEmailController)
  end

  def adding_user_details?
    is_a?(Account::Onboarding::UserDetailsController)
  end

  def adding_team?
    return true if request.get? && request.path == new_account_team_path
    return true if request.post? && request.path == account_teams_path
    false
  end

  def switching_teams?
    return true if request.get? && request.path == account_teams_path
    false
  end

  def managing_account?
    is_a?(Account::UsersController) || self.class.module_parents.include?(Oauth)
  end

  def accepting_invitation?
    (params[:controller] == "account/invitations") && (params[:action] == "show" || params[:action] == "accept")
  end

  def ensure_onboarding_is_complete
    # This is temporary, but if we've gotten this far and `@team` is loaded, we need to ensure current_team is
    # updated for the checks below. This entire concept of `current_team` is going away soon.
    current_user.update(current_team: @team) if @team&.persisted?

    # since the onboarding controllers are child classes of this class,
    # we actually have to check to make sure we're not currently on that
    # step otherwise we'll end up in an endless redirection loop.
    if current_user.email_is_oauth_placeholder?
      if adding_user_email?
        return true
      else
        redirect_to edit_account_onboarding_user_email_path(current_user)
        return false
      end
    end

    # some team-related onboarding steps need to be skipped if we're in the process
    # of creating a new team.
    unless adding_team? || accepting_invitation?

      # USER ONBOARDING STUFF
      # first we make sure the user is properly onboarded.
      unless current_team.present?

        # don't force the user to create a team if they've already got one.
        if current_user.teams.any?
          current_user.update(current_team: current_user.teams.first)
        else
          redirect_to new_account_team_path
          return false
        end
      end

      # TEAM ONBOARDING STUFF.
      # then make sure the team is properly onboarded.

      # since the onboarding controllers are child classes of this class,
      # we actually have to check to make sure we're not currently on that
      # step otherwise we'll end up in an endless redirection loop.
      unless current_user.details_provided?
        if adding_user_details?
          return true
        else
          redirect_to edit_account_onboarding_user_detail_path(current_user)
          return false
        end
      end

      # if you want to add additional onboarding steps, this would be the place to do it:

    end

    true
  end

  def set_last_seen_at
    current_user.update_attribute(:last_seen_at, Time.current)
  end
end
