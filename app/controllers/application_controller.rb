class ApplicationController < ActionController::Base
  # these are common for authentication workflows.
  include InvitationOnlyHelper
  include InvitationsHelper

  protect_from_forgery with: :exception, prepend: true

  around_action :set_locale
  before_action :set_sentry_context
  layout :layout_by_resource

  protect_from_forgery with: :exception
  skip_before_action :verify_authenticity_token, if: -> { controller_name == "sessions" && action_name == "create" }

  # this is an ugly hack, but it's what is recommended at
  # https://github.com/plataformatec/devise/wiki/How-To:-Create-custom-layouts
  def layout_by_resource
    if devise_controller?
      "devise"
    else
      "public"
    end
  end

  def after_sign_in_path_for(resource_or_scope)
    resource = resource_or_scope.class.name.downcase
    stored_location_for(resource) || account_dashboard_path
  end

  def after_sign_up_path_for(resource_or_scope)
    resource = resource_or_scope.class.name.downcase
    stored_location_for(resource) || account_dashboard_path
  end

  def set_sentry_context
    return unless ENV["SENTRY_DSN"]

    Sentry.configure_scope do |scope|
      scope.set_user(id: current_user.id, email: current_user.email) if current_user

      scope.set_context(
        "request",
        {
          url: request.url,
          params: params.to_unsafe_h
        }
      )
    end
  end

  def current_team
    helpers.current_team
  end

  def current_membership
    helpers.current_membership
  end

  def enforce_invitation_only
    if invitation_only?
      unless helpers.invited?
        redirect_to [:account, :teams], notice: t("teams.notifications.invitation_only")
      end
    end
  end

  rescue_from CanCan::AccessDenied do |exception|
    if current_user.nil?
      respond_to do |format|
        format.html do
          session["user_return_to"] = request.path
          redirect_to [:new, :user, :session], alert: exception.message
        end
      end
    elsif current_user.teams.none?
      respond_to do |format|
        format.html { redirect_to [:new, :account, :team], alert: exception.message }
      end
    else
      respond_to do |format|
        # TODO we do this for now because it ensures `current_team` doesn't remain set in an invalid state.
        format.html { redirect_to [:account, current_user.teams.first], alert: exception.message }
      end
    end
  end

  def set_locale
    I18n.locale = [
      current_user&.locale,
      current_user&.current_team&.locale,
      http_accept_language.compatible_language_from(I18n.available_locales),
      I18n.default_locale.to_s
    ].compact.find { |potential_locale| I18n.available_locales.include?(potential_locale.to_sym) }
    yield
    I18n.locale = I18n.default_locale
  end

  # Whitelist the account namespace and prevent JavaScript
  # embedding when passing paths as parameters in links.
  def only_allow_path(path)
    return if path.nil?
    account_namespace_regexp = /^\/account\/*+/
    scheme = URI.parse(path).scheme
    return nil unless path.match?(account_namespace_regexp) && scheme != "javascript"
    path
  end
end
