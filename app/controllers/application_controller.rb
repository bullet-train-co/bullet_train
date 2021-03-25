class ApplicationController < ActionController::Base
  include Sprinkles::ControllerSupport

  # these are common for authentication workflows.
  include InvitationOnlyHelper
  include InvitationsHelper

  protect_from_forgery with: :exception, prepend: true

  before_action :set_raven_context
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

  def set_raven_context
    if ENV["SENTRY_DSN"]
      Raven.user_context(id: current_user.id, email: current_user.email) if current_user.present?
      Raven.extra_context(params: params.to_unsafe_h, url: request.url)
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

  # TODO i think we'll need to account for a user's time formats here.
  def assign_date(strong_params, attribute)
    attribute = attribute.to_s
    if strong_params.key?(attribute)
      parsed_value = Chronic.parse(strong_params[attribute])
      return nil unless parsed_value
      strong_params[attribute] = parsed_value.to_date
    end
  end

  # TODO i think we'll need to account for a user's time formats here.
  def assign_date_and_time(strong_params, attribute)
    attribute = attribute.to_s
    if strong_params.key?(attribute)
      parsed_value = Chronic.parse(strong_params[attribute])
      return nil unless parsed_value
      strong_params[attribute] = parsed_value
    end
  end

  def assign_boolean(strong_params, attribute)
    attribute = attribute.to_s
    if strong_params.key?(attribute)
      # TODO i _think_ only the string values are required here. can we confirm and remove the others if so?
      strong_params[attribute] = (["1", 1, "true", true].include?(strong_params[attribute]) ? true : false)
    end
  end

  def assign_checkboxes(strong_params, attribute)
    attribute = attribute.to_s
    if strong_params.key?(attribute)
      # filter out the placeholder inputs that arrive along with the form submission.
      strong_params[attribute] = strong_params[attribute].reject { |value| value == "0" }
    end
  end

  def assign_select_options(strong_params, attribute)
    attribute = attribute.to_s
    if strong_params.key?(attribute)
      # filter out the placeholder inputs that arrive along with the form submission.
      strong_params[attribute] = strong_params[attribute].select(&:present?)
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

end
