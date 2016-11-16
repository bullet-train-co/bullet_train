class Api::V1::AuthenticatedController < Api::V1::ApplicationController
  before_filter :authenticate_user!
  def authenticate_user!
    if user = authenticate_with_http_basic { |api_key, ignored| User.authenticate_by_api_key(api_key) }
      @current_user = user
      return true
    else
      request_http_basic_authentication
      return false
    end
  end
end
