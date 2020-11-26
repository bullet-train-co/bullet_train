class Api::V1::AuthenticatedController < Api::V1::ApplicationController
  include LoadsAndAuthorizesResource

  include ActionController::HttpAuthentication::Basic::ControllerMethods
  include ActionController::HttpAuthentication::Token::ControllerMethods

  before_action :authenticate_user!

  # this is a template method called by LoadsAndAuthorizesResource.
  # it allows that module to understand what namespaces of a controller
  # are organizing the controllers, and which are organizing the models.
  def self.regex_to_remove_controller_namespace
    /^Api::V1::/
  end

  def current_user
    @current_user
  end

  def authenticate_user!
    if user = authenticate_with_http_basic { |token, secret| User.authenticate_by_api_key(token, secret) }
      sign_in user
      @current_user = user
      return true
    else
      request_http_basic_authentication
      return false
    end
  end

end
