class Account::ApplicationController < ApplicationController
  include LoadsAndAuthorizesResource
  include Fields::ControllerSupport

  before_action :set_last_seen_at, if: proc {
    user_signed_in? && (current_user.last_seen_at.nil? || current_user.last_seen_at < 1.minute.ago)
  }

  # this is a template method called by LoadsAndAuthorizesResource.
  # it allows that module to understand what namespaces of a controller
  # are organizing the controllers, and which are organizing the models.
  def self.regex_to_remove_controller_namespace
    /^Account::/
  end

  layout "account"

  before_action :authenticate_user!
  before_action :set_paper_trail_whodunnit
  before_action :ensure_onboarding_is_complete_and_set_next_step

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

  def ensure_onboarding_is_complete_and_set_next_step
    unless ensure_onboarding_is_complete
      session[:after_onboarding_url] ||= request.url
    end
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
